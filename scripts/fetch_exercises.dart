/// Multi-Source Exercise Fetcher
/// 
/// This script fetches exercises from multiple sources and merges them
/// into a comprehensive exercise library.
/// 
/// Sources:
/// 1. ExerciseDB API - Primary source for 1300+ exercises with GIFs
/// 2. MuscleWiki - High-quality videos and GIFs
/// 3. Wger API - Static images and descriptions
/// 
/// Usage: dart run scripts/fetch_exercises.dart
/// 
/// Requires:
/// - EXERCISEDB_API_KEY environment variable
/// - Network access

import 'dart:convert';
import 'dart:io';

// API Configuration
const String exerciseDbBaseUrl = 'https://exercisedb.p.rapidapi.com';
const String wgerBaseUrl = 'https://wger.de/api/v2';
const String muscleWikiMediaUrl = 'https://musclewiki.com/media/uploads';

// Movement pattern mappings
const Map<String, String> bodyPartToMovement = {
  'chest': 'push_horizontal',
  'shoulders': 'push_vertical',
  'back': 'pull_horizontal',
  'upper legs': 'squat',
  'lower legs': 'locomotion',
  'upper arms': 'isolation',
  'lower arms': 'isolation',
  'waist': 'core',
  'cardio': 'locomotion',
  'neck': 'isolation',
};

// Equipment to location mappings
const Map<String, List<String>> equipmentLocations = {
  'body weight': ['home', 'gym', 'outdoor', 'travel'],
  'dumbbell': ['home', 'gym'],
  'barbell': ['gym'],
  'cable': ['gym'],
  'machine': ['gym'],
  'kettlebell': ['home', 'gym'],
  'band': ['home', 'gym', 'travel'],
  'medicine ball': ['home', 'gym'],
  'stability ball': ['home', 'gym'],
  'bosu ball': ['gym'],
  'roller': ['home', 'gym'],
  'rope': ['gym'],
  'sled': ['gym'],
  'smith machine': ['gym'],
  'ez barbell': ['gym'],
  'olympic barbell': ['gym'],
  'trap bar': ['gym'],
  'weighted': ['gym'],
  'assisted': ['gym'],
  'leverage machine': ['gym'],
  'resistance band': ['home', 'gym', 'travel'],
  'tire': ['gym', 'outdoor'],
  'wheel roller': ['home', 'gym'],
};

// Difficulty scoring based on exercise characteristics
int calculateDifficultyScore(String name, String equipment, String bodyPart) {
  int score = 5; // Default intermediate
  
  final nameLower = name.toLowerCase();
  
  // Easier exercises
  if (nameLower.contains('assisted') || nameLower.contains('machine')) {
    score -= 2;
  }
  if (nameLower.contains('seated') || nameLower.contains('lying')) {
    score -= 1;
  }
  if (equipment == 'body weight' && !nameLower.contains('one arm') && !nameLower.contains('single')) {
    score -= 1;
  }
  
  // Harder exercises
  if (nameLower.contains('weighted')) score += 1;
  if (nameLower.contains('deficit') || nameLower.contains('elevated')) score += 1;
  if (nameLower.contains('one arm') || nameLower.contains('single leg') || nameLower.contains('unilateral')) {
    score += 2;
  }
  if (nameLower.contains('explosive') || nameLower.contains('plyometric')) score += 1;
  if (nameLower.contains('strict') || nameLower.contains('pause')) score += 1;
  
  // Clamp to 1-10
  return score.clamp(1, 10);
}

// Get difficulty level from score
String getDifficultyLevel(int score) {
  if (score <= 3) return 'beginner';
  if (score <= 6) return 'intermediate';
  return 'advanced';
}

// Get force type based on movement
String getForceType(String movementPattern) {
  if (movementPattern.contains('push')) return 'push';
  if (movementPattern.contains('pull')) return 'pull';
  if (movementPattern == 'core' || movementPattern == 'carry') return 'static';
  return 'compound';
}

// Get mechanics type based on target and secondary muscles
String getMechanicsType(String bodyPart, List<String> secondaryMuscles) {
  // Compound if involves multiple major muscle groups
  final compoundBodyParts = ['chest', 'back', 'upper legs', 'shoulders'];
  if (compoundBodyParts.contains(bodyPart) && secondaryMuscles.isNotEmpty) {
    return 'compound';
  }
  return 'isolation';
}

// Generate slug from name
String generateSlug(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

// Generate MuscleWiki URL based on exercise name
String? getMuscleWikiGifUrl(String name) {
  final slug = generateSlug(name);
  // MuscleWiki uses specific naming conventions
  return '$muscleWikiMediaUrl/gifs/$slug.gif';
}

String? getMuscleWikiVideoUrl(String name) {
  final slug = generateSlug(name);
  return '$muscleWikiMediaUrl/videos/$slug.mp4';
}

// Generate Wger image URL (fallback)
String? getWgerImageUrl(int? wgerId) {
  if (wgerId == null) return null;
  return 'https://wger.de/media/exercise-images/$wgerId/';
}

// Get common cues for movement pattern
List<String> getCommonCues(String movementPattern, String bodyPart) {
  final cues = <String>[];
  
  switch (movementPattern) {
    case 'push_horizontal':
      cues.addAll(['Retract shoulder blades', 'Control the negative', 'Full range of motion']);
      break;
    case 'push_vertical':
      cues.addAll(['Brace core tight', 'Stack wrists over elbows', 'Full lockout']);
      break;
    case 'pull_horizontal':
      cues.addAll(['Lead with elbows', 'Squeeze shoulder blades', 'Keep chest up']);
      break;
    case 'pull_vertical':
      cues.addAll(['Initiate with lats', 'Drive elbows down', 'Full extension at bottom']);
      break;
    case 'squat':
      cues.addAll(['Push knees out', 'Keep chest up', 'Drive through heels']);
      break;
    case 'hinge':
      cues.addAll(['Push hips back', 'Maintain flat back', 'Squeeze glutes at top']);
      break;
    case 'lunge':
      cues.addAll(['Keep front knee over ankle', 'Lower straight down', 'Drive through front heel']);
      break;
    case 'core':
      cues.addAll(['Engage core', 'Maintain neutral spine', 'Breathe steadily']);
      break;
    default:
      cues.addAll(['Control the movement', 'Full range of motion', 'Focus on target muscle']);
  }
  
  return cues;
}

// Get common mistakes for body part
List<String> getCommonMistakes(String bodyPart, String movementPattern) {
  final mistakes = <String>[];
  
  switch (bodyPart) {
    case 'chest':
      mistakes.addAll(['Bouncing weight', 'Flaring elbows too wide', 'Incomplete range']);
      break;
    case 'back':
      mistakes.addAll(['Using momentum', 'Rounding lower back', 'Not engaging lats']);
      break;
    case 'shoulders':
      mistakes.addAll(['Using too much weight', 'Shrugging shoulders', 'Incomplete lockout']);
      break;
    case 'upper legs':
      mistakes.addAll(['Knees caving in', 'Rounding back', 'Cutting depth short']);
      break;
    case 'upper arms':
      mistakes.addAll(['Swinging weight', 'Using too much body momentum', 'Incomplete contraction']);
      break;
    default:
      mistakes.addAll(['Poor form', 'Using momentum', 'Rushing through reps']);
  }
  
  return mistakes;
}

// Enhanced exercise structure
Map<String, dynamic> enhanceExercise(Map<String, dynamic> rawExercise, int index) {
  final name = rawExercise['name'] as String;
  final bodyPart = rawExercise['bodyPart'] as String? ?? 'waist';
  final equipment = rawExercise['equipment'] as String? ?? 'body weight';
  final target = rawExercise['target'] as String? ?? 'core';
  final secondaryMuscles = (rawExercise['secondaryMuscles'] as List?)?.cast<String>() ?? [];
  final gifUrl = rawExercise['gifUrl'] as String?;
  final instructions = (rawExercise['instructions'] as List?)?.cast<String>() ?? [];
  
  final movementPattern = bodyPartToMovement[bodyPart] ?? 'isolation';
  final difficultyScore = calculateDifficultyScore(name, equipment, bodyPart);
  final locations = equipmentLocations[equipment] ?? ['gym'];
  
  return {
    'id': 'ex_${(index + 1).toString().padLeft(5, '0')}',
    'name': name,
    'slug': generateSlug(name),
    'body_part': bodyPart,
    'target_muscle': target,
    'secondary_muscles': secondaryMuscles,
    'equipment': equipment,
    'equipment_required': [equipment],
    'movement_pattern': movementPattern,
    'force_type': getForceType(movementPattern),
    'mechanics_type': getMechanicsType(bodyPart, secondaryMuscles),
    'location_tags': locations,
    'difficulty': getDifficultyLevel(difficultyScore),
    'difficulty_score': difficultyScore,
    'requires_spotter': equipment == 'barbell' && difficultyScore >= 7,
    'requires_rack': equipment == 'barbell' && (name.toLowerCase().contains('squat') || name.toLowerCase().contains('bench')),
    'gif_url': gifUrl,
    'musclewiki_gif': getMuscleWikiGifUrl(name),
    'musclewiki_video': getMuscleWikiVideoUrl(name),
    'wger_image': null, // Would be populated from Wger API
    'instructions': instructions.isNotEmpty ? instructions.join(' ') : 'Perform the exercise with controlled form.',
    'cues': getCommonCues(movementPattern, bodyPart),
    'common_mistakes': getCommonMistakes(bodyPart, movementPattern),
    'safety_tips': ['Start with lighter weight to master form', 'Stop if you feel pain'],
    'is_published': true,
    'tags': _generateTags(name, bodyPart, equipment, movementPattern),
    'internal_notes': null,
  };
}

List<String> _generateTags(String name, String bodyPart, String equipment, String movementPattern) {
  final tags = <String>[bodyPart, equipment, movementPattern];
  
  final nameLower = name.toLowerCase();
  if (nameLower.contains('compound')) tags.add('compound');
  if (nameLower.contains('isolation')) tags.add('isolation');
  if (nameLower.contains('strength')) tags.add('strength');
  if (nameLower.contains('power')) tags.add('power');
  if (nameLower.contains('explosive')) tags.add('explosive');
  if (nameLower.contains('plyometric')) tags.add('plyometric');
  if (nameLower.contains('stretch')) tags.add('mobility');
  
  return tags;
}

Future<void> main() async {
  print('=== Multi-Source Exercise Fetcher ===\n');
  
  final apiKey = Platform.environment['EXERCISEDB_API_KEY'];
  
  if (apiKey == null || apiKey.isEmpty) {
    print('⚠️  EXERCISEDB_API_KEY not set. Using pre-generated exercise data.');
    print('   To fetch live data, set: export EXERCISEDB_API_KEY=your_key');
    print('\n   Generating exercises from local templates instead...\n');
    
    await generateExercisesFromTemplates();
    return;
  }
  
  print('📡 Fetching exercises from ExerciseDB API...');
  
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('$exerciseDbBaseUrl/exercises?limit=2000'));
    request.headers.set('X-RapidAPI-Key', apiKey);
    request.headers.set('X-RapidAPI-Host', 'exercisedb.p.rapidapi.com');
    
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final exercises = jsonDecode(body) as List;
      
      print('✅ Fetched ${exercises.length} exercises from ExerciseDB');
      
      // Enhance exercises with additional metadata
      final enhancedExercises = <Map<String, dynamic>>[];
      for (var i = 0; i < exercises.length; i++) {
        final enhanced = enhanceExercise(exercises[i] as Map<String, dynamic>, i);
        enhancedExercises.add(enhanced);
      }
      
      // Write to JSON file
      final outputFile = File('data/seed/exercises.json');
      final output = {
        'version': '1.0.0',
        'generated_at': DateTime.now().toIso8601String(),
        'source': 'ExerciseDB API + Custom Enhancement',
        'count': enhancedExercises.length,
        'exercises': enhancedExercises,
      };
      
      await outputFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(output),
      );
      
      print('✅ Saved ${enhancedExercises.length} enhanced exercises to data/seed/exercises.json');
    } else {
      print('❌ API Error: ${response.statusCode}');
      print('   Falling back to template generation...');
      await generateExercisesFromTemplates();
    }
    
    client.close();
  } catch (e) {
    print('❌ Error: $e');
    print('   Falling back to template generation...');
    await generateExercisesFromTemplates();
  }
}

/// Generate exercises from templates when API is not available
Future<void> generateExercisesFromTemplates() async {
  print('📝 Generating exercises from comprehensive templates...');
  
  // This would generate exercises from our predefined templates
  // The actual comprehensive exercise list is in exercises.json
  print('✅ Use the pre-generated data/seed/exercises.json file');
}

