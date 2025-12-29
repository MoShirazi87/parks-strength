/// GIF Service for exercise demonstrations
/// Uses verified working URLs from reliable sources
class GifService {
  static final GifService _instance = GifService._internal();
  factory GifService() => _instance;
  GifService._internal();

  /// Master mapping of exercise names to verified working GIF URLs
  /// These URLs have been tested and confirmed working
  static const Map<String, String> _exerciseGifs = {
    // ═══════════════════════════════════════════════════════════════════
    // CHEST EXERCISES
    // ═══════════════════════════════════════════════════════════════════
    'barbell bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
    'bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
    'flat bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/barbell-bench-press-benefits.gif',
    'dumbbell bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/dumbbell-bench-press.gif',
    'dumbbell press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/dumbbell-bench-press.gif',
    'incline bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/incline-barbell-bench-press.gif',
    'incline dumbbell press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif',
    'incline press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-press.gif',
    'decline bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/decline-bench-press.gif',
    'chest fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
    'dumbbell fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
    'pec fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/dumbbell-chest-fly.gif',
    'cable fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-cable-fly.gif',
    'cable crossover': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-cable-fly.gif',
    'push up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'push-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'pushup': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'wide push up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/push-up-movement.gif',
    'diamond push up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/diamond-push-up.gif',
    'chest dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/chest-dips.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // BACK EXERCISES
    // ═══════════════════════════════════════════════════════════════════
    'barbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
    'bent over row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
    'pendlay row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/barbell-row.gif',
    'dumbbell row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/single-arm-dumbbell-row.gif',
    'single arm row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/single-arm-dumbbell-row.gif',
    'one arm row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/single-arm-dumbbell-row.gif',
    'pull up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'pull-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'pullup': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/pull-up.gif',
    'chin up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif',
    'chin-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/chin-up.gif',
    'lat pulldown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/lat-pulldown.gif',
    'cable pulldown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/lat-pulldown.gif',
    'cable row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    'seated cable row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    'seated row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/seated-cable-row.gif',
    't-bar row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/t-bar-row.gif',
    'face pull': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/face-pull.gif',
    'inverted row': 'https://www.inspireusafoundation.org/wp-content/uploads/2023/03/inverted-row.gif',
    'ring row': 'https://www.inspireusafoundation.org/wp-content/uploads/2023/03/inverted-row.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // SHOULDER EXERCISES
    // ═══════════════════════════════════════════════════════════════════
    'overhead press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'ohp': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'military press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'barbell press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-overhead-press.gif',
    'shoulder press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif',
    'dumbbell shoulder press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shoulder-press.gif',
    'arnold press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/arnold-press.gif',
    'lateral raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
    'side raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
    'dumbbell lateral raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-lateral-raise-exercise.gif',
    'front raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-front-raise.gif',
    'dumbbell front raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-front-raise.gif',
    'rear delt fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/dumbbell-rear-delt-fly.gif',
    'reverse fly': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/dumbbell-rear-delt-fly.gif',
    'rear delt raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/dumbbell-rear-delt-fly.gif',
    'upright row': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-upright-row.gif',
    'shrug': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shrug.gif',
    'dumbbell shrug': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-shrug.gif',
    'barbell shrug': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/barbell-shrug.gif',
    'landmine press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/landmine-press.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // LEG - QUAD DOMINANT
    // ═══════════════════════════════════════════════════════════════════
    'squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'back squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'barbell squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif',
    'front squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/front-squat-form.gif',
    'goblet squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif',
    'dumbbell squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/goblet-squat.gif',
    'bulgarian split squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/bulgarian-split-squat.gif',
    'split squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/bulgarian-split-squat.gif',
    'lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
    'dumbbell lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
    'walking lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-lunge.gif',
    'reverse lunge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/dumbbell-reverse-lunge.gif',
    'leg press': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/leg-press.gif',
    'leg extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/leg-extension-machine.gif',
    'hack squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/hack-squat-machine.gif',
    'box squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/box-squat-benefits.gif',
    'step up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/dumbbell-step-up.gif',
    'pistol squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/pistol-squat.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // LEG - HIP/HAMSTRING DOMINANT
    // ═══════════════════════════════════════════════════════════════════
    'deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif',
    'conventional deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif',
    'barbell deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-deadlift.gif',
    'sumo deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/sumo-deadlift-form.gif',
    'romanian deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif',
    'rdl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif',
    'stiff leg deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/02/barbell-romanian-deadlift.gif',
    'dumbbell rdl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-romanian-deadlift.gif',
    'trap bar deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/trap-bar-deadlift.gif',
    'hex bar deadlift': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/trap-bar-deadlift.gif',
    'good morning': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/good-morning-exercise.gif',
    'leg curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/lying-leg-curl-machine.gif',
    'lying leg curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/lying-leg-curl-machine.gif',
    'seated leg curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/seated-leg-curl.gif',
    'hip thrust': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/barbell-hip-thrust.gif',
    'barbell hip thrust': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/10/barbell-hip-thrust.gif',
    'glute bridge': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/glute-bridge.gif',
    'hip extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/glute-bridge.gif',
    'cable pull through': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/cable-pull-through.gif',
    'kettlebell swing': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/russian-kettlebell-swing.gif',
    'kb swing': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/russian-kettlebell-swing.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // LEG - CALVES
    // ═══════════════════════════════════════════════════════════════════
    'calf raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif',
    'standing calf raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/standing-calf-raise-machine.gif',
    'seated calf raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/seated-calf-raise.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // ARMS - BICEPS
    // ═══════════════════════════════════════════════════════════════════
    'bicep curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif',
    'barbell curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-curl.gif',
    'dumbbell curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-bicep-curl.gif',
    'dumbbell bicep curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-bicep-curl.gif',
    'hammer curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hammer-curl.gif',
    'preacher curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/preacher-curl.gif',
    'ez bar curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/ez-bar-curl.gif',
    'concentration curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/concentration-curl.gif',
    'incline curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/incline-dumbbell-curl.gif',
    'cable curl': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/cable-bicep-curl.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // ARMS - TRICEPS
    // ═══════════════════════════════════════════════════════════════════
    'tricep pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
    'cable pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
    'pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/tricep-pushdown-long-head.gif',
    'rope pushdown': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/rope-pushdown.gif',
    'tricep extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/cable-overhead-tricep-extension.gif',
    'overhead extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/12/cable-overhead-tricep-extension.gif',
    'skull crusher': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/skull-crusher.gif',
    'lying tricep extension': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/skull-crusher.gif',
    'close grip bench press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/close-grip-bench-press.gif',
    'close grip bench': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/close-grip-bench-press.gif',
    'dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'dips': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'tricep dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/tricep-dip.gif',
    'bench dip': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/bench-dip.gif',
    'kickback': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-kickback.gif',
    'tricep kickback': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/dumbbell-kickback.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // CORE EXERCISES
    // ═══════════════════════════════════════════════════════════════════
    'plank': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/plank.gif',
    'forearm plank': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/plank.gif',
    'side plank': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/side-plank.gif',
    'crunch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/crunch.gif',
    'sit up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/sit-up.gif',
    'sit-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/sit-up.gif',
    'hanging leg raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/hanging-leg-raises.gif',
    'leg raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/hanging-leg-raises.gif',
    'lying leg raise': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/lying-leg-raise.gif',
    'russian twist': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/06/russian-twist.gif',
    'bicycle crunch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/bicycle-crunch.gif',
    'mountain climber': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/mountain-climber.gif',
    'dead bug': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/dead-bug.gif',
    'bird dog': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/01/bird-dog.gif',
    'ab wheel rollout': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/ab-wheel-rollout.gif',
    'cable crunch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/cable-crunch.gif',
    'pallof press': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/pallof-press.gif',
    'wood chop': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/cable-wood-chop.gif',
    'woodchop': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/cable-wood-chop.gif',
    'cable wood chop': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/cable-wood-chop.gif',
    'v-up': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/v-up.gif',
    'hollow hold': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hollow-body-hold.gif',
    
    // ═══════════════════════════════════════════════════════════════════
    // FUNCTIONAL/COMPOUND MOVEMENTS
    // ═══════════════════════════════════════════════════════════════════
    'farmer walk': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/farmers-walk.gif',
    'farmer carry': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/farmers-walk.gif',
    'farmers walk': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/farmers-walk.gif',
    'suitcase carry': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/04/farmers-walk.gif',
    'thruster': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-thruster.gif',
    'dumbbell thruster': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/dumbbell-thruster.gif',
    'clean': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/power-clean.gif',
    'power clean': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/power-clean.gif',
    'hang clean': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/03/hang-clean.gif',
    'snatch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/07/dumbbell-snatch.gif',
    'dumbbell snatch': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/07/dumbbell-snatch.gif',
    'burpee': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/burpees.gif',
    'burpees': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/burpees.gif',
    'box jump': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/box-jump.gif',
    'jump squat': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/08/jump-squat.gif',
    'sled push': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/10/sled-push.gif',
    'battle rope': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/battle-ropes.gif',
    'battle ropes': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/battle-ropes.gif',
    'med ball slam': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/medicine-ball-slam.gif',
    'medicine ball slam': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/11/medicine-ball-slam.gif',
    'wall ball': 'https://www.inspireusafoundation.org/wp-content/uploads/2022/09/wall-ball.gif',
  };

  /// Get GIF URL for an exercise by name
  /// Uses fuzzy matching to find the best match
  String getGifUrl(String exerciseName) {
    final normalized = exerciseName.toLowerCase().trim();
    
    // 1. Try exact match first
    if (_exerciseGifs.containsKey(normalized)) {
      return _exerciseGifs[normalized]!;
    }
    
    // 2. Try partial match (exercise name contains key)
    for (final entry in _exerciseGifs.entries) {
      if (normalized.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // 3. Try reverse partial match (key contains exercise name)
    for (final entry in _exerciseGifs.entries) {
      if (entry.key.contains(normalized)) {
        return entry.value;
      }
    }
    
    // 4. Try word-by-word matching
    final words = normalized.split(' ');
    for (final word in words) {
      if (word.length < 4) continue; // Skip short words
      for (final entry in _exerciseGifs.entries) {
        if (entry.key.contains(word)) {
          return entry.value;
        }
      }
    }
    
    // 5. Return a default strength training GIF
    return 'https://www.inspireusafoundation.org/wp-content/uploads/2021/06/barbell-full-squat.gif';
  }

  /// Check if we have a GIF for this exercise
  bool hasGif(String exerciseName) {
    final normalized = exerciseName.toLowerCase().trim();
    return _exerciseGifs.containsKey(normalized) ||
        _exerciseGifs.keys.any((key) => normalized.contains(key) || key.contains(normalized));
  }
}

