import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// ExerciseDB API Service
/// Provides access to 1,300+ exercises with animated GIF demonstrations
/// API documentation: https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb
class ExerciseDbService {
  // RapidAPI configuration
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String _host = 'exercisedb.p.rapidapi.com';
  
  // API key should be loaded from environment or secure storage
  String? _apiKey;
  
  // Cache for exercises to reduce API calls
  final Map<String, List<ExerciseDbExercise>> _cache = {};
  List<ExerciseDbExercise>? _allExercises;
  
  ExerciseDbService({String? apiKey}) : _apiKey = apiKey;
  
  /// Set API key (should be called during app initialization)
  void setApiKey(String key) {
    _apiKey = key;
  }
  
  /// Get request headers
  Map<String, String> get _headers => {
    'X-RapidAPI-Key': _apiKey ?? '',
    'X-RapidAPI-Host': _host,
  };
  
  /// Fetch all exercises (cached)
  Future<List<ExerciseDbExercise>> getAllExercises({int limit = 0}) async {
    if (_allExercises != null && limit == 0) {
      return _allExercises!;
    }
    
    final url = limit > 0 
      ? '$_baseUrl/exercises?limit=$limit'
      : '$_baseUrl/exercises?limit=1500';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exercises = data.map((e) => ExerciseDbExercise.fromJson(e)).toList();
        
        if (limit == 0) {
          _allExercises = exercises;
        }
        return exercises;
      } else {
        debugPrint('ExerciseDB API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
      return [];
    }
  }
  
  /// Fetch exercises by body part
  Future<List<ExerciseDbExercise>> getExercisesByBodyPart(String bodyPart) async {
    final cacheKey = 'bodyPart_$bodyPart';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final url = '$_baseUrl/exercises/bodyPart/${Uri.encodeComponent(bodyPart)}';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exercises = data.map((e) => ExerciseDbExercise.fromJson(e)).toList();
        _cache[cacheKey] = exercises;
        return exercises;
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Fetch exercises by target muscle
  Future<List<ExerciseDbExercise>> getExercisesByTarget(String target) async {
    final cacheKey = 'target_$target';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final url = '$_baseUrl/exercises/target/${Uri.encodeComponent(target)}';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exercises = data.map((e) => ExerciseDbExercise.fromJson(e)).toList();
        _cache[cacheKey] = exercises;
        return exercises;
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Fetch exercises by equipment type
  Future<List<ExerciseDbExercise>> getExercisesByEquipment(String equipment) async {
    final cacheKey = 'equipment_$equipment';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final url = '$_baseUrl/exercises/equipment/${Uri.encodeComponent(equipment)}';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final exercises = data.map((e) => ExerciseDbExercise.fromJson(e)).toList();
        _cache[cacheKey] = exercises;
        return exercises;
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Fetch single exercise by ID
  Future<ExerciseDbExercise?> getExerciseById(String id) async {
    final url = '$_baseUrl/exercises/exercise/$id';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ExerciseDbExercise.fromJson(data);
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return null;
  }
  
  /// Search exercises by name
  Future<List<ExerciseDbExercise>> searchExercises(String query) async {
    final url = '$_baseUrl/exercises/name/${Uri.encodeComponent(query)}';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => ExerciseDbExercise.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Get list of all body parts
  Future<List<String>> getBodyPartList() async {
    const url = '$_baseUrl/exercises/bodyPartList';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Get list of all equipment types
  Future<List<String>> getEquipmentList() async {
    const url = '$_baseUrl/exercises/equipmentList';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Get list of all target muscles
  Future<List<String>> getTargetList() async {
    const url = '$_baseUrl/exercises/targetList';
    
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      }
    } catch (e) {
      debugPrint('ExerciseDB API exception: $e');
    }
    return [];
  }
  
  /// Clear cache
  void clearCache() {
    _cache.clear();
    _allExercises = null;
  }
}

/// ExerciseDB Exercise Model
class ExerciseDbExercise {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  
  const ExerciseDbExercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
  });
  
  factory ExerciseDbExercise.fromJson(Map<String, dynamic> json) {
    return ExerciseDbExercise(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      equipment: json['equipment'] ?? '',
      gifUrl: json['gifUrl'] ?? '',
      target: json['target'] ?? '',
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'bodyPart': bodyPart,
    'equipment': equipment,
    'gifUrl': gifUrl,
    'target': target,
    'secondaryMuscles': secondaryMuscles,
    'instructions': instructions,
  };
  
  /// Get display name (capitalized)
  String get displayName => name
    .split(' ')
    .map((word) => word.isNotEmpty 
      ? '${word[0].toUpperCase()}${word.substring(1)}'
      : '')
    .join(' ');
  
  /// Map body part to movement pattern
  String get movementPattern {
    switch (bodyPart.toLowerCase()) {
      case 'chest':
        return 'Push (Horizontal)';
      case 'shoulders':
        return 'Push (Vertical)';
      case 'back':
        return 'Pull';
      case 'upper legs':
      case 'lower legs':
        return target.toLowerCase().contains('glut') 
          ? 'Hinge' 
          : 'Squat';
      case 'waist':
        return 'Core';
      case 'upper arms':
      case 'lower arms':
        return 'Accessory';
      case 'cardio':
        return 'Locomotion';
      default:
        return 'General';
    }
  }
  
  /// Check if exercise matches equipment filter
  bool matchesEquipment(List<String> availableEquipment) {
    if (availableEquipment.isEmpty) return true;
    if (equipment == 'body weight') return true;
    return availableEquipment.any(
      (e) => e.toLowerCase() == equipment.toLowerCase()
    );
  }
  
  @override
  String toString() => 'ExerciseDbExercise(id: $id, name: $name)';
}

/// Body part categories from ExerciseDB
class ExerciseBodyParts {
  static const String back = 'back';
  static const String cardio = 'cardio';
  static const String chest = 'chest';
  static const String lowerArms = 'lower arms';
  static const String lowerLegs = 'lower legs';
  static const String neck = 'neck';
  static const String shoulders = 'shoulders';
  static const String upperArms = 'upper arms';
  static const String upperLegs = 'upper legs';
  static const String waist = 'waist';
  
  static const List<String> all = [
    back, cardio, chest, lowerArms, lowerLegs,
    neck, shoulders, upperArms, upperLegs, waist,
  ];
}

/// Equipment types from ExerciseDB
class ExerciseEquipment {
  static const String assisted = 'assisted';
  static const String band = 'band';
  static const String barbell = 'barbell';
  static const String bodyWeight = 'body weight';
  static const String bosuBall = 'bosu ball';
  static const String cable = 'cable';
  static const String dumbbell = 'dumbbell';
  static const String elliptical = 'elliptical machine';
  static const String ezBarbell = 'ez barbell';
  static const String hammer = 'hammer';
  static const String kettlebell = 'kettlebell';
  static const String leverageMachine = 'leverage machine';
  static const String medicineBall = 'medicine ball';
  static const String olympicBarbell = 'olympic barbell';
  static const String resistanceBand = 'resistance band';
  static const String roller = 'roller';
  static const String rope = 'rope';
  static const String skiergMachine = 'skierg machine';
  static const String sledMachine = 'sled machine';
  static const String smithMachine = 'smith machine';
  static const String stabilityBall = 'stability ball';
  static const String stationary = 'stationary bike';
  static const String stepmill = 'stepmill machine';
  static const String tire = 'tire';
  static const String trapBar = 'trap bar';
  static const String upperBody = 'upper body ergometer';
  static const String weighted = 'weighted';
  static const String wheelRoller = 'wheel roller';
  
  static const List<String> common = [
    bodyWeight, dumbbell, barbell, cable, 
    kettlebell, resistanceBand, medicineBall,
  ];
}

