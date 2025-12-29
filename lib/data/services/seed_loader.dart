/// Seed Loader Service
///
/// Loads exercise library, equipment catalog, and programs from JSON files
/// into Supabase database. Used for initial seeding and data updates.
library;

import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../main.dart';
import 'exercise_enhancement_engine.dart';

class SeedLoader {
  static SeedLoader? _instance;
  
  SeedLoader._();
  
  static SeedLoader get instance {
    _instance ??= SeedLoader._();
    return _instance!;
  }

  /// Load all seed data into Supabase
  Future<void> loadAllSeedData({
    bool force = false,
    Function(String status)? onProgress,
  }) async {
    try {
      onProgress?.call('Checking existing data...');
      
      // Check if data already exists
      if (!force) {
        final existingExercises = await supabase
            .from('exercises')
            .select('id')
            .limit(1);
        
        if (existingExercises.isNotEmpty) {
          onProgress?.call('Data already exists. Use force=true to reload.');
          return;
        }
      }

      onProgress?.call('Loading equipment...');
      await seedEquipment();

      onProgress?.call('Loading exercises...');
      await seedExercises();

      onProgress?.call('Loading programs...');
      await seedPrograms();

      onProgress?.call('Seed data loaded successfully!');
    } catch (e) {
      onProgress?.call('Error loading seed data: $e');
      rethrow;
    }
  }

  /// Seed equipment catalog
  Future<void> seedEquipment() async {
    try {
      final jsonString = await rootBundle.loadString('assets/seed/equipment.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final categories = data['categories'] as List;

      final allEquipment = <Map<String, dynamic>>[];
      
      for (final category in categories) {
        final categoryId = category['id'] as String;
        final categoryName = category['name'] as String;
        final items = category['items'] as List;
        
        for (final item in items) {
          allEquipment.add({
            'id': item['id'],
            'name': item['name'],
            'category': categoryId,
            'category_name': categoryName,
            'locations': item['locations'],
            'common': item['common'] ?? false,
          });
        }
      }

      // Batch upsert in chunks
      await _batchUpsert('equipment', allEquipment, 50);
      print('Seeded ${allEquipment.length} equipment items');
    } catch (e) {
      print('Error seeding equipment: $e');
      rethrow;
    }
  }

  /// Seed exercises from JSON
  Future<void> seedExercises() async {
    try {
      final jsonString = await rootBundle.loadString('assets/seed/exercises.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final exercises = data['exercises'] as List;

      // Enhance and prepare exercises
      final enhancedExercises = exercises.map((ex) {
        final enhanced = ExerciseEnhancementEngine.enhanceExercise(ex as Map<String, dynamic>);
        return _prepareExerciseForDb(enhanced);
      }).toList();

      // Batch upsert
      await _batchUpsert('exercises', enhancedExercises, 100);
      print('Seeded ${enhancedExercises.length} exercises');
    } catch (e) {
      print('Error seeding exercises: $e');
      rethrow;
    }
  }

  /// Prepare exercise data for database insertion
  Map<String, dynamic> _prepareExerciseForDb(Map<String, dynamic> exercise) {
    return {
      'id': exercise['id'],
      'name': exercise['name'],
      'slug': exercise['slug'],
      'body_part': exercise['body_part'],
      'target_muscle': exercise['target_muscle'],
      'secondary_muscles': exercise['secondary_muscles'],
      'equipment': exercise['equipment'],
      'equipment_required': exercise['equipment_required'],
      'movement_pattern': exercise['movement_pattern'],
      'force_type': exercise['force_type'],
      'mechanics_type': exercise['mechanics_type'],
      'location_tags': exercise['location_tags'],
      'difficulty': exercise['difficulty'],
      'difficulty_score': exercise['difficulty_score'],
      'requires_spotter': exercise['requires_spotter'] ?? false,
      'requires_rack': exercise['requires_rack'] ?? false,
      'gif_url': exercise['gif_url'],
      'video_url': exercise['video_url'] ?? exercise['musclewiki_video'],
      'musclewiki_gif': exercise['musclewiki_gif'],
      'wger_image': exercise['wger_image'],
      'instructions': exercise['instructions'],
      'cues': exercise['cues'],
      'common_mistakes': exercise['common_mistakes'],
      'safety_tips': exercise['safety_tips'],
      'is_published': exercise['is_published'] ?? true,
      'tags': exercise['tags'],
      'internal_notes': exercise['internal_notes'],
    };
  }

  /// Seed programs from JSON files
  Future<void> seedPrograms() async {
    final programFiles = [
      'assets/seed/programs/foundation_strength.json',
      'assets/seed/programs/hypertrophy_max.json',
      'assets/seed/programs/home_workout.json',
      'assets/seed/programs/functional_athlete.json',
      'assets/seed/programs/powerbuilding.json',
      'assets/seed/programs/bodyweight_mastery.json',
    ];

    for (final file in programFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final programData = jsonDecode(jsonString) as Map<String, dynamic>;
        await _seedProgram(programData);
      } catch (e) {
        print('Error seeding program from $file: $e');
        // Continue with other programs
      }
    }
  }

  /// Seed a single program with all its data
  Future<void> _seedProgram(Map<String, dynamic> programData) async {
    final programId = programData['id'] as String;

    // Insert program
    await supabase.from('programs').upsert({
      'id': programId,
      'name': programData['name'],
      'slug': programData['slug'],
      'description': programData['description'],
      'duration_weeks': programData['duration_weeks'],
      'days_per_week': programData['days_per_week'],
      'difficulty': programData['difficulty'],
      'goal': programData['goal'],
      'equipment_required': programData['equipment_required'],
      'location': programData['location'],
      'image_url': programData['image_url'],
      'progression_type': programData['progression_type'],
      'is_published': true,
    });

    // Insert program weeks and workouts
    final weeks = programData['weeks'] as List;
    for (final week in weeks) {
      final weekNumber = week['week_number'] as int;
      final weekId = '${programId}_week_$weekNumber';

      await supabase.from('program_weeks').upsert({
        'id': weekId,
        'program_id': programId,
        'week_number': weekNumber,
        'theme': week['theme'],
        'intensity': week['intensity'],
        'focus': week['focus'],
      });

      // Insert workouts
      final workouts = week['workouts'] as List;
      for (final workout in workouts) {
        final day = workout['day'] as int;
        final workoutId = '${weekId}_day_$day';

        await supabase.from('workouts').upsert({
          'id': workoutId,
          'program_id': programId,
          'program_week_id': weekId,
          'name': workout['name'],
          'day_number': day,
          'workout_type': workout['type'],
          'estimated_minutes': workout['estimated_minutes'],
        });

        // Insert workout exercises
        final exercises = workout['exercises'] as List;
        for (var i = 0; i < exercises.length; i++) {
          final exercise = exercises[i];
          await supabase.from('workout_exercises').upsert({
            'id': '${workoutId}_ex_$i',
            'workout_id': workoutId,
            'exercise_slug': exercise['exercise_slug'],
            'order_index': i,
            'sets': exercise['sets'],
            'reps': exercise['reps'],
            'rest_seconds': exercise['rest_seconds'],
            'notes': exercise['notes'],
          });
        }
      }
    }

    print('Seeded program: ${programData['name']}');
  }

  /// Batch upsert helper
  Future<void> _batchUpsert(String table, List<Map<String, dynamic>> data, int chunkSize) async {
    for (var i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize > data.length) ? data.length : i + chunkSize;
      final chunk = data.sublist(i, end);
      
      await supabase.from(table).upsert(chunk);
    }
  }

  /// Get seed data statistics
  Future<Map<String, int>> getStats() async {
    final stats = <String, int>{};

    try {
      final exercises = await supabase.from('exercises').select('id');
      stats['exercises'] = exercises.length;

      final equipment = await supabase.from('equipment').select('id');
      stats['equipment'] = equipment.length;

      final programs = await supabase.from('programs').select('id');
      stats['programs'] = programs.length;

      final workouts = await supabase.from('workouts').select('id');
      stats['workouts'] = workouts.length;
    } catch (e) {
      print('Error getting stats: $e');
    }

    return stats;
  }

  /// Clear all seed data (use with caution!)
  Future<void> clearAllData() async {
    // Delete in order to respect foreign keys
    await supabase.from('workout_exercises').delete().neq('id', '');
    await supabase.from('workouts').delete().neq('id', '');
    await supabase.from('program_weeks').delete().neq('id', '');
    await supabase.from('programs').delete().neq('id', '');
    await supabase.from('exercises').delete().neq('id', '');
    await supabase.from('equipment').delete().neq('id', '');
    print('All seed data cleared');
  }
}

/// Extension for chunking lists
extension ListChunking<T> on List<T> {
  List<List<T>> chunked(int chunkSize) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += chunkSize) {
      chunks.add(sublist(i, i + chunkSize > length ? length : i + chunkSize));
    }
    return chunks;
  }
}

