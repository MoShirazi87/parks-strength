/// Maps exercise names to local asset paths
/// Falls back to the exercise name as a placeholder if no local asset exists

class ExerciseAssets {
  static const String _basePath = 'assets/exercises/';
  
  /// Map of exercise name patterns to local asset file names
  static final Map<String, String> _assetMap = {
    // Chest
    'bench press': 'bench-press.jpg',
    'dumbbell press': 'dumbbell-press.jpg',
    'dumbbell bench': 'dumbbell-press.jpg',
    'cable fly': 'cable-fly.jpg',
    'cable crossover': 'cable-fly.jpg',
    'chest fly': 'cable-fly.jpg',
    
    // Back
    'deadlift': 'deadlift.jpg',
    'barbell row': 'row.jpg',
    'bent over row': 'row.jpg',
    'dumbbell row': 'row.jpg',
    'lat pulldown': 'lat-pulldown.jpg',
    'pull-up': 'pull-up.jpg',
    'pullup': 'pull-up.jpg',
    'chin-up': 'pull-up.jpg',
    'chinup': 'pull-up.jpg',
    
    // Shoulders
    'shoulder press': 'shoulder-press.jpg',
    'overhead press': 'shoulder-press.jpg',
    'military press': 'shoulder-press.jpg',
    
    // Arms
    'barbell curl': 'barbell-curl.jpg',
    'bicep curl': 'dumbbell-curl.jpg',
    'dumbbell curl': 'dumbbell-curl.jpg',
    'hammer curl': 'dumbbell-curl.jpg',
    'tricep dip': 'tricep-dip.jpg',
    'dips': 'tricep-dip.jpg',
    
    // Legs
    'squat': 'squat.jpg',
    'back squat': 'squat.jpg',
    'front squat': 'squat.jpg',
    'leg press': 'leg-press.jpg',
    'leg curl': 'leg-curl.jpg',
    'hamstring curl': 'leg-curl.jpg',
    'calf raise': 'calf-raise.jpg',
    'lunge': 'lunge.jpg',
    'walking lunge': 'lunge.jpg',
    
    // Core
    'plank': 'plank.jpg',
    'crunch': 'crunch.jpg',
    'sit-up': 'crunch.jpg',
    'mountain climber': 'mountain-climber.jpg',
    
    // Full Body
    'kettlebell swing': 'kettlebell-swing.jpg',
    'kettlebell': 'kettlebell-swing.jpg',
  };
  
  /// Get the local asset path for an exercise
  /// Returns null if no local asset exists
  static String? getLocalAsset(String exerciseName) {
    final nameLower = exerciseName.toLowerCase();
    
    // Check for exact or partial matches
    for (final entry in _assetMap.entries) {
      if (nameLower.contains(entry.key)) {
        return '$_basePath${entry.value}';
      }
    }
    
    return null;
  }
  
  /// Check if a local asset exists for an exercise
  static bool hasLocalAsset(String exerciseName) {
    return getLocalAsset(exerciseName) != null;
  }
  
  /// Get the best image source - local asset if available, otherwise network URL
  static String? getBestImageSource(String exerciseName, String? networkUrl) {
    final localAsset = getLocalAsset(exerciseName);
    if (localAsset != null) {
      return localAsset;
    }
    return networkUrl;
  }
  
  /// All available local asset paths
  static List<String> get allAssets => [
    '${_basePath}barbell-curl.jpg',
    '${_basePath}bench-press.jpg',
    '${_basePath}cable-fly.jpg',
    '${_basePath}calf-raise.jpg',
    '${_basePath}crunch.jpg',
    '${_basePath}deadlift.jpg',
    '${_basePath}dumbbell-curl.jpg',
    '${_basePath}dumbbell-press.jpg',
    '${_basePath}kettlebell-swing.jpg',
    '${_basePath}lat-pulldown.jpg',
    '${_basePath}leg-curl.jpg',
    '${_basePath}leg-press.jpg',
    '${_basePath}lunge.jpg',
    '${_basePath}mountain-climber.jpg',
    '${_basePath}plank.jpg',
    '${_basePath}pull-up.jpg',
    '${_basePath}row.jpg',
    '${_basePath}shoulder-press.jpg',
    '${_basePath}squat.jpg',
    '${_basePath}tricep-dip.jpg',
  ];
}

