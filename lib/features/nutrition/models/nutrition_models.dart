import 'dart:math' as math;

// ═══════════════════════════════════════════════════════════════════════════
// CALORIE & MACRO CALCULATOR
// ═══════════════════════════════════════════════════════════════════════════

/// Nutrition calculator using evidence-based formulas
class NutritionCalculator {
  NutritionCalculator._();

  // ─────────────────────────────────────────────────────────────────────────
  // BMR CALCULATIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Mifflin-St Jeor Equation (most accurate for most people)
  /// Men: BMR = (10 × weight[kg]) + (6.25 × height[cm]) - (5 × age) + 5
  /// Women: BMR = (10 × weight[kg]) + (6.25 × height[cm]) - (5 × age) - 161
  static double calculateBMRMifflinStJeor({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? base + 5 : base - 161;
  }

  /// Katch-McArdle Formula (requires body fat %)
  /// BMR = 370 + (21.6 × lean body mass[kg])
  static double calculateBMRKatchMcArdle({
    required double weightKg,
    required double bodyFatPercentage,
  }) {
    final leanMass = weightKg * (1 - bodyFatPercentage / 100);
    return 370 + (21.6 * leanMass);
  }

  /// Calculate BMR with automatic formula selection
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    double? bodyFatPercentage,
  }) {
    if (bodyFatPercentage != null) {
      return calculateBMRKatchMcArdle(
        weightKg: weightKg,
        bodyFatPercentage: bodyFatPercentage,
      );
    }
    return calculateBMRMifflinStJeor(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TDEE CALCULATIONS
  // ─────────────────────────────────────────────────────────────────────────

  /// Calculate Total Daily Energy Expenditure
  static double calculateTDEE({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    return bmr * activityLevel.multiplier;
  }

  /// Full TDEE calculation from inputs
  static NutritionTargets calculateTargets({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
    required ActivityLevel activityLevel,
    required NutritionGoal goal,
    double? bodyFatPercentage,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      bodyFatPercentage: bodyFatPercentage,
    );

    final tdee = calculateTDEE(bmr: bmr, activityLevel: activityLevel);
    final adjustedCalories = _adjustCaloriesForGoal(tdee, goal);
    final macros = _calculateMacros(
      calories: adjustedCalories,
      weightKg: weightKg,
      goal: goal,
    );

    return NutritionTargets(
      bmr: bmr.round(),
      tdee: tdee.round(),
      targetCalories: adjustedCalories.round(),
      proteinGrams: macros.protein,
      carbsGrams: macros.carbs,
      fatGrams: macros.fat,
      goal: goal,
    );
  }

  static double _adjustCaloriesForGoal(double tdee, NutritionGoal goal) {
    return switch (goal) {
      NutritionGoal.loseFat => tdee * 0.80,         // 20% deficit
      NutritionGoal.loseFatSlow => tdee * 0.90,    // 10% deficit
      NutritionGoal.maintain => tdee,
      NutritionGoal.buildMuscleLean => tdee * 1.10, // 10% surplus
      NutritionGoal.buildMuscle => tdee * 1.15,     // 15% surplus
    };
  }

  static MacroTargets _calculateMacros({
    required double calories,
    required double weightKg,
    required NutritionGoal goal,
  }) {
    // Protein: 1.6-2.2 g/kg for muscle building/retention
    final proteinPerKg = switch (goal) {
      NutritionGoal.loseFat => 2.2,      // Higher protein when cutting
      NutritionGoal.loseFatSlow => 2.0,
      NutritionGoal.maintain => 1.8,
      NutritionGoal.buildMuscleLean => 2.0,
      NutritionGoal.buildMuscle => 2.2,
    };

    final protein = (weightKg * proteinPerKg).round();
    final proteinCalories = protein * 4;

    // Fat: 25-30% of calories
    final fatPercentage = switch (goal) {
      NutritionGoal.loseFat => 0.25,
      NutritionGoal.loseFatSlow => 0.25,
      NutritionGoal.maintain => 0.28,
      NutritionGoal.buildMuscleLean => 0.25,
      NutritionGoal.buildMuscle => 0.28,
    };

    final fatCalories = calories * fatPercentage;
    final fat = (fatCalories / 9).round();

    // Carbs: remaining calories
    final carbCalories = calories - proteinCalories - fatCalories;
    final carbs = (carbCalories / 4).round();

    return MacroTargets(protein: protein, carbs: carbs, fat: fat);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BODY COMPOSITION
  // ─────────────────────────────────────────────────────────────────────────

  /// Calculate BMI
  static double calculateBMI({
    required double weightKg,
    required double heightCm,
  }) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category
  static BMICategory getBMICategory(double bmi) {
    if (bmi < 18.5) return BMICategory.underweight;
    if (bmi < 25) return BMICategory.normal;
    if (bmi < 30) return BMICategory.overweight;
    return BMICategory.obese;
  }

  /// Estimate body fat percentage using Navy method
  static double? estimateBodyFatNavy({
    required Gender gender,
    required double waistCm,
    required double neckCm,
    required double heightCm,
    double? hipsCm, // Required for women
  }) {
    if (gender == Gender.male) {
      return 495 /
              (1.0324 -
                  0.19077 * _log10(waistCm - neckCm) +
                  0.15456 * _log10(heightCm)) -
          450;
    } else {
      if (hipsCm == null) return null;
      return 495 /
              (1.29579 -
                  0.35004 * _log10(waistCm + hipsCm - neckCm) +
                  0.22100 * _log10(heightCm)) -
          450;
    }
  }

  static double _log10(double x) => math.log(x) / math.ln10;

  // ─────────────────────────────────────────────────────────────────────────
  // WATER INTAKE
  // ─────────────────────────────────────────────────────────────────────────

  /// Calculate recommended daily water intake (ml)
  static int calculateWaterIntake({
    required double weightKg,
    required ActivityLevel activityLevel,
  }) {
    // Base: 30-35ml per kg of body weight
    final base = weightKg * 33;
    
    // Add extra for activity
    final activityBonus = switch (activityLevel) {
      ActivityLevel.sedentary => 0.0,
      ActivityLevel.lightlyActive => 300.0,
      ActivityLevel.moderatelyActive => 500.0,
      ActivityLevel.veryActive => 750.0,
      ActivityLevel.extraActive => 1000.0,
    };

    return (base + activityBonus).round();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

enum Gender { male, female }

enum ActivityLevel {
  sedentary(1.2, 'Sedentary', 'Little or no exercise'),
  lightlyActive(1.375, 'Lightly Active', 'Light exercise 1-3 days/week'),
  moderatelyActive(1.55, 'Moderately Active', 'Moderate exercise 3-5 days/week'),
  veryActive(1.725, 'Very Active', 'Hard exercise 6-7 days/week'),
  extraActive(1.9, 'Extra Active', 'Very hard exercise & physical job');

  final double multiplier;
  final String name;
  final String description;

  const ActivityLevel(this.multiplier, this.name, this.description);
}

enum NutritionGoal {
  loseFat('Lose Fat', 'Aggressive deficit (-20%)', -500),
  loseFatSlow('Lose Fat Slowly', 'Moderate deficit (-10%)', -250),
  maintain('Maintain', 'Stay at current weight', 0),
  buildMuscleLean('Lean Bulk', 'Minimize fat gain (+10%)', 250),
  buildMuscle('Build Muscle', 'Maximize muscle gain (+15%)', 400);

  final String name;
  final String description;
  final int calorieAdjustment;

  const NutritionGoal(this.name, this.description, this.calorieAdjustment);
}

enum BMICategory {
  underweight('Underweight', 'BMI < 18.5'),
  normal('Normal', 'BMI 18.5-24.9'),
  overweight('Overweight', 'BMI 25-29.9'),
  obese('Obese', 'BMI ≥ 30');

  final String name;
  final String range;

  const BMICategory(this.name, this.range);
}

class MacroTargets {
  final int protein;
  final int carbs;
  final int fat;

  const MacroTargets({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  int get totalCalories => (protein * 4) + (carbs * 4) + (fat * 9);

  double get proteinPercentage => (protein * 4) / totalCalories * 100;
  double get carbsPercentage => (carbs * 4) / totalCalories * 100;
  double get fatPercentage => (fat * 9) / totalCalories * 100;
}

class NutritionTargets {
  final int bmr;
  final int tdee;
  final int targetCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final NutritionGoal goal;

  const NutritionTargets({
    required this.bmr,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.goal,
  });

  int get proteinCalories => proteinGrams * 4;
  int get carbCalories => carbsGrams * 4;
  int get fatCalories => fatGrams * 9;

  double get proteinPercentage => proteinCalories / targetCalories * 100;
  double get carbsPercentage => carbCalories / targetCalories * 100;
  double get fatPercentage => fatCalories / targetCalories * 100;
}

// ═══════════════════════════════════════════════════════════════════════════
// FOOD TRACKING
// ═══════════════════════════════════════════════════════════════════════════

/// Food quality tier based on NOVA classification
enum FoodQuality {
  tier1('Whole Foods', 'Unprocessed or minimally processed'),
  tier2('Healthy Prepared', 'Simple processed with healthy methods'),
  tier3('Moderate', 'Some processing, consume in moderation'),
  tier4('Processed', 'Limit intake'),
  tier5('UltraProcessed', 'Avoid when possible');

  final String name;
  final String description;

  const FoodQuality(this.name, this.description);
}

/// Logged food entry
class FoodEntry {
  final String id;
  final String name;
  final double servingSize;
  final String servingUnit;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final FoodQuality quality;
  final DateTime timestamp;
  final MealType mealType;

  const FoodEntry({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.quality,
    required this.timestamp,
    required this.mealType,
  });
}

enum MealType {
  breakfast('Breakfast', '🍳'),
  lunch('Lunch', '🥗'),
  dinner('Dinner', '🍽️'),
  snack('Snack', '🍎'),
  preworkout('Pre-Workout', '⚡'),
  postworkout('Post-Workout', '💪');

  final String name;
  final String emoji;

  const MealType(this.name, this.emoji);
}

/// Daily nutrition log
class DailyNutritionLog {
  final DateTime date;
  final List<FoodEntry> entries;
  final NutritionTargets targets;

  const DailyNutritionLog({
    required this.date,
    required this.entries,
    required this.targets,
  });

  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  int get totalProtein => entries.fold(0, (sum, e) => sum + e.protein);
  int get totalCarbs => entries.fold(0, (sum, e) => sum + e.carbs);
  int get totalFat => entries.fold(0, (sum, e) => sum + e.fat);

  double get caloriesProgress => totalCalories / targets.targetCalories;
  double get proteinProgress => totalProtein / targets.proteinGrams;
  double get carbsProgress => totalCarbs / targets.carbsGrams;
  double get fatProgress => totalFat / targets.fatGrams;

  bool get isProteinGoalMet => totalProtein >= targets.proteinGrams;
  bool get isUnderCalorieTarget => totalCalories <= targets.targetCalories;
}

// ═══════════════════════════════════════════════════════════════════════════
// SUPPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════

/// Recommended supplements
class SupplementRecommendation {
  final String name;
  final String dosage;
  final String timing;
  final String benefit;
  final SupplementTier tier;

  const SupplementRecommendation({
    required this.name,
    required this.dosage,
    required this.timing,
    required this.benefit,
    required this.tier,
  });
}

enum SupplementTier {
  essential('Essential', 'Strong evidence, widely recommended'),
  beneficial('Beneficial', 'Good evidence for most people'),
  optional('Optional', 'Situational benefit');

  final String name;
  final String description;

  const SupplementTier(this.name, this.description);
}

class SupplementDatabase {
  static const List<SupplementRecommendation> forStrengthTraining = [
    SupplementRecommendation(
      name: 'Creatine Monohydrate',
      dosage: '5g daily',
      timing: 'Any time, consistency matters',
      benefit: 'Increased strength, power, and muscle mass',
      tier: SupplementTier.essential,
    ),
    SupplementRecommendation(
      name: 'Protein Powder',
      dosage: '20-40g per serving',
      timing: 'Post-workout or to meet daily protein',
      benefit: 'Convenient protein source',
      tier: SupplementTier.essential,
    ),
    SupplementRecommendation(
      name: 'Vitamin D3',
      dosage: '2000-5000 IU daily',
      timing: 'With fat-containing meal',
      benefit: 'Hormone support, bone health, immune function',
      tier: SupplementTier.essential,
    ),
    SupplementRecommendation(
      name: 'Omega-3 (Fish Oil)',
      dosage: '2-3g EPA+DHA daily',
      timing: 'With meals',
      benefit: 'Inflammation reduction, joint health',
      tier: SupplementTier.beneficial,
    ),
    SupplementRecommendation(
      name: 'Magnesium',
      dosage: '200-400mg daily',
      timing: 'Before bed',
      benefit: 'Sleep quality, muscle function',
      tier: SupplementTier.beneficial,
    ),
    SupplementRecommendation(
      name: 'Caffeine',
      dosage: '3-6mg/kg body weight',
      timing: '30-60 min pre-workout',
      benefit: 'Enhanced performance and focus',
      tier: SupplementTier.beneficial,
    ),
    SupplementRecommendation(
      name: 'Beta-Alanine',
      dosage: '3-5g daily',
      timing: 'Any time, splits OK',
      benefit: 'Improved muscular endurance',
      tier: SupplementTier.optional,
    ),
    SupplementRecommendation(
      name: 'Citrulline Malate',
      dosage: '6-8g pre-workout',
      timing: '30-60 min pre-workout',
      benefit: 'Improved blood flow and pump',
      tier: SupplementTier.optional,
    ),
  ];
}

