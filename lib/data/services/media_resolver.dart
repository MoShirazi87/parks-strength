/// Media Resolver Service
///
/// Resolves the best available media URL from multiple sources:
/// 1. MuscleWiki (videos, GIFs) - Primary for high-quality demos
/// 2. ExerciseDB (GIFs) - Backup for exercise GIFs
/// 3. Wger (static images) - Fallback thumbnails
/// 4. InspireUSA Foundation - Verified working GIFs
library;

import 'package:flutter/material.dart';

class MediaResolver {
  static MediaResolver? _instance;

  MediaResolver._();

  static MediaResolver get instance {
    _instance ??= MediaResolver._();
    return _instance!;
  }

  /// Verified working GIF URLs from inspireusafoundation.org
  static const Map<String, String> _verifiedGifs = {
    // Chest
    'bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
    'barbell bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
    'incline bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/incline-bench-press.gif',
    'incline dumbbell press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif',
    'dumbbell bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-bench-press.gif',
    'dumbbell fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
    'chest fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
    'push up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'push-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'pushup': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'cable crossover': 'https://www.inspireusafoundation.org/wp-content/uploads/2023/05/cable-crossover.gif',

    // Back
    'barbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
    'bent over row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
    'pull up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'pull-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'pullup': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'chin up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif',
    'chin-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif',
    'lat pulldown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/lat-pulldown.gif',
    'cable row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    'seated cable row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    'seated row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    'deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif',
    'romanian deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif',
    'dumbbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/one-arm-dumbbell-row.gif',
    'single arm dumbbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/one-arm-dumbbell-row.gif',
    'one arm dumbbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/one-arm-dumbbell-row.gif',
    'dumbbell pullover': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/lying-dumbbell-pullover.gif',

    // Shoulders
    'overhead press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'military press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'shoulder press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif',
    'dumbbell shoulder press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif',
    'lateral raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
    'side raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
    'face pull': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/face-pull.gif',
    'shrug': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shrug.gif',
    'shrugs': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shrug.gif',

    // Legs
    'squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'back squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'barbell back squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'goblet squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif',
    'leg press': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/leg-press.gif',
    'lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
    'walking lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
    'leg curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/lying-leg-curl-machine.gif',
    'leg extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/leg-extension-machine.gif',
    'hip thrust': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/barbell-hip-thrust.gif',
    'calf raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif',
    'standing calf raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif',

    // Arms
    'barbell curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif',
    'bicep curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif',
    'dumbbell curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-bicep-curl.gif',
    'hammer curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hammer-curl.gif',
    'tricep pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
    'pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
    'tricep extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/cable-overhead-tricep-extension.gif',
    'overhead tricep extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/cable-overhead-tricep-extension.gif',
    'skull crusher': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/skull-crusher.gif',
    'dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'dips': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'tricep dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'chest dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',

    // Core
    'plank': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/plank.gif',
    'crunch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/crunch.gif',
    'leg raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/hanging-leg-raises.gif',
    'hanging leg raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/hanging-leg-raises.gif',
    'russian twist': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/russian-twist.gif',

    // Compounds
    'clean': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/power-clean.gif',
    'power clean': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/power-clean.gif',
    'kettlebell swing': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/07/kettlebell-swing.gif',
  };

  /// MuscleWiki URL patterns
  static const String _muscleWikiBaseUrl = 'https://musclewiki.com/media/uploads';

  /// Wger API base URL - Reserved for future wger.de integration
  // ignore: unused_field
  static const String _wgerBaseUrl = 'https://wger.de/media/exercise-images';

  /// Resolve the best GIF URL for an exercise
  String resolveGifUrl({
    required String exerciseName,
    String? existingGifUrl,
    String? muscleWikiGif,
    String? wgerImage,
  }) {
    final nameLower = exerciseName.toLowerCase().trim();

    // 1. Try verified GIFs first (most reliable)
    for (final entry in _verifiedGifs.entries) {
      if (nameLower.contains(entry.key) || entry.key.contains(nameLower)) {
        return entry.value;
      }
    }

    // 2. Try existing GIF URL if provided
    if (existingGifUrl != null && existingGifUrl.isNotEmpty) {
      return existingGifUrl;
    }

    // 3. Try MuscleWiki GIF
    if (muscleWikiGif != null && muscleWikiGif.isNotEmpty) {
      return muscleWikiGif;
    }

    // 4. Try Wger image
    if (wgerImage != null && wgerImage.isNotEmpty) {
      return wgerImage;
    }

    // 5. Generate MuscleWiki URL from exercise name
    final slug = _generateSlug(exerciseName);
    return '$_muscleWikiBaseUrl/gifs/$slug.gif';
  }

  /// Resolve video URL (MuscleWiki is primary source)
  String? resolveVideoUrl({
    required String exerciseName,
    String? existingVideoUrl,
  }) {
    if (existingVideoUrl != null && existingVideoUrl.isNotEmpty) {
      return existingVideoUrl;
    }

    // Generate MuscleWiki video URL
    final slug = _generateSlug(exerciseName);
    return '$_muscleWikiBaseUrl/videos/$slug.mp4';
  }

  /// Resolve thumbnail/static image (Wger is primary)
  String? resolveThumbnailUrl({
    required String exerciseName,
    String? wgerImage,
    String? gifUrl,
  }) {
    if (wgerImage != null && wgerImage.isNotEmpty) {
      return wgerImage;
    }

    // Fallback to GIF as thumbnail
    return gifUrl;
  }

  /// Generate slug from exercise name
  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Get all verified GIF URLs (for preloading)
  List<String> getAllVerifiedGifUrls() {
    return _verifiedGifs.values.toSet().toList();
  }

  /// Check if we have a verified GIF for an exercise
  bool hasVerifiedGif(String exerciseName) {
    final nameLower = exerciseName.toLowerCase().trim();
    return _verifiedGifs.keys.any((key) => 
        nameLower.contains(key) || key.contains(nameLower));
  }

  /// Get media URLs for an exercise
  ExerciseMedia getMediaForExercise({
    required String exerciseName,
    String? existingGifUrl,
    String? existingVideoUrl,
    String? muscleWikiGif,
    String? wgerImage,
  }) {
    return ExerciseMedia(
      gifUrl: resolveGifUrl(
        exerciseName: exerciseName,
        existingGifUrl: existingGifUrl,
        muscleWikiGif: muscleWikiGif,
        wgerImage: wgerImage,
      ),
      videoUrl: resolveVideoUrl(
        exerciseName: exerciseName,
        existingVideoUrl: existingVideoUrl,
      ),
      thumbnailUrl: resolveThumbnailUrl(
        exerciseName: exerciseName,
        wgerImage: wgerImage,
        gifUrl: existingGifUrl,
      ),
    );
  }
}

/// Container for exercise media URLs
class ExerciseMedia {
  final String gifUrl;
  final String? videoUrl;
  final String? thumbnailUrl;

  ExerciseMedia({
    required this.gifUrl,
    this.videoUrl,
    this.thumbnailUrl,
  });

  /// Get the best available URL for display
  String get displayUrl => thumbnailUrl ?? gifUrl;
  
  /// Check if video is available
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
}

/// Widget to display exercise media with fallback handling
class ExerciseMediaDisplay extends StatelessWidget {
  final String exerciseName;
  final String? gifUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ExerciseMediaDisplay({
    super.key,
    required this.exerciseName,
    this.gifUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = MediaResolver.instance.resolveGifUrl(
      exerciseName: exerciseName,
      existingGifUrl: gifUrl,
    );

    return Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                color: Colors.grey[600],
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                exerciseName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

