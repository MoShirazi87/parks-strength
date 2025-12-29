# Parks Strength

**Functional Strength Training App by Coach Brian Parks**

A premium cross-platform fitness application built with Flutter and Supabase, featuring structured strength training programs with video demonstrations, intelligent workout logging, progressive overload algorithms, gamification, nutrition tracking, and community features.

---

## Features

### Core Functionality
- **Structured Programs** - Multi-week training programs with periodization
- **Video Demonstrations** - 1,300+ exercises with animated GIFs (via ExerciseDB API)
- **Workout Logging** - Real-time set tracking with weight, reps, and RPE
- **Progress Tracking** - Personal records, volume analysis, and strength graphs
- **Intelligent Algorithms** - Progressive overload suggestions, plateau detection, 1RM estimation

### Gamification
- **Streak System** - Track consecutive workout days with tier rewards
- **Points System** - Earn points for workouts, PRs, and consistency
- **Badges** - 20+ achievement badges across categories
- **Leaderboards** - Weekly rankings with cohort-based scoring

### Nutrition Module
- **Calorie Calculator** - Mifflin-St Jeor and Katch-McArdle formulas
- **Macro Tracking** - Protein-first approach with visual breakdowns
- **Supplement Guide** - Evidence-based recommendations

### Community (Tribe)
- **Real-time Chat** - Community messaging with Supabase Realtime
- **Workout Sharing** - Celebrate PRs and milestones with the community
- **Coach Posts** - Direct content from Coach Brian Parks

---

## Tech Stack

| Category | Technology |
|----------|------------|
| Frontend | Flutter 3.27+ with Dart |
| State Management | Riverpod |
| Navigation | go_router |
| Backend | Supabase (Auth, Database, Storage, Realtime) |
| Exercise Data | ExerciseDB API (RapidAPI) |
| Stock Media | Pixabay (photos), Mixkit (videos) |
| Payments | RevenueCat |
| Push Notifications | OneSignal |
| Analytics | PostHog / Mixpanel |

---

## Project Structure

```
parks_strength/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # Root widget
│   ├── core/
│   │   ├── algorithms/           # Progressive overload, 1RM, RPE
│   │   ├── constants/            # Colors, typography, spacing
│   │   ├── router/               # go_router configuration
│   │   ├── theme/                # Material theme
│   │   └── utils/                # Extensions, helpers
│   ├── data/
│   │   ├── repositories/         # Supabase data access
│   │   └── services/             # ExerciseDB API, caching
│   ├── features/
│   │   ├── auth/                 # Authentication screens
│   │   ├── home/                 # Home dashboard
│   │   ├── workout/              # Workout player
│   │   ├── programs/             # Program browser
│   │   ├── progress/             # Analytics, PRs
│   │   ├── nutrition/            # Calorie/macro tracking
│   │   ├── gamification/         # Streaks, badges, points
│   │   ├── tribe/                # Community features
│   │   ├── profile/              # User profile
│   │   └── onboarding/           # Onboarding wizard
│   └── shared/
│       ├── models/               # Data models
│       ├── services/             # Cross-feature services
│       └── widgets/              # Reusable components
├── supabase/
│   └── migrations/               # Database schema
├── assets/
│   ├── images/                   # Stock photos
│   ├── videos/                   # Stock videos
│   └── icons/                    # Custom icons
└── .github/
    └── workflows/                # CI/CD pipeline
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.27+
- Dart SDK 3.2+
- Supabase account
- ExerciseDB API key (RapidAPI)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/parks-strength.git
   cd parks-strength
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new Supabase project
   - Run migrations in order:
     ```sql
     -- Execute in Supabase SQL Editor
     -- 1. supabase/migrations/001_initial_schema.sql
     -- 2. supabase/migrations/002_rls_policies.sql
     -- 3. supabase/migrations/003_seed_data.sql
     -- 4. supabase/migrations/004_add_streak_fields.sql
     -- 5. supabase/migrations/005_comprehensive_workouts.sql (V2 MVP)
     -- 6-15. Run all remaining migrations in order
     -- 16. supabase/migrations/016_comprehensive_exercise_library.sql (1000+ exercises)
     ```
   - Enable Email provider in Authentication settings
   - (Optional) Configure Google and Apple OAuth

4. **Configure environment**
   
   Update `lib/main.dart` with your Supabase credentials:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

5. **Run the app**
   ```bash
   # Web
   flutter run -d chrome

   # iOS (requires Xcode)
   flutter run -d ios

   # Android
   flutter run -d android
   ```

---

## API Keys Required

| Service | Purpose | Get Key |
|---------|---------|---------|
| Supabase | Backend | [supabase.com](https://supabase.com) |
| ExerciseDB | Exercise GIFs | [rapidapi.com](https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb) |
| RevenueCat | Subscriptions | [revenuecat.com](https://revenuecat.com) (later) |
| OneSignal | Push Notifications | [onesignal.com](https://onesignal.com) (later) |

---

## CI/CD Pipeline

GitHub Actions workflow runs on push to `main`:

1. **Analyze** - Code analysis and tests
2. **Build Android** - APK generation
3. **Build iOS** - iOS build (unsigned)
4. **Build Web** - Web deployment
5. **Deploy Migrations** - Supabase database sync

Required GitHub Secrets:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `SUPABASE_PROJECT_ID`
- `SUPABASE_ACCESS_TOKEN`

---

## Design System

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| Background | `#0A0A0A` | Primary dark |
| Surface | `#1A1A1A` | Cards, inputs |
| Primary | `#6366F1` | Buttons, CTAs |
| Secondary | `#BFFF00` | Accents, highlights |
| Streak | `#F97316` | Fire/streak indicators |
| Points | `#22C55E` | Points/success |

### Typography
- **Headings**: Outfit (Google Fonts)
- **Body**: Plus Jakarta Sans (Google Fonts)

---

## Progressive Overload Algorithm

The app implements evidence-based progression:

1. **2-for-2 Rule**: If user exceeds target reps by 2+ for 2 sessions → increase weight
2. **Plateau Detection**: Same weight/reps for 3+ sessions → suggest alternatives
3. **RPE-Based Adjustment**: Real-time load suggestions based on perceived effort
4. **1RM Estimation**: Epley (low reps) and Brzycki (mid reps) formulas

---

## Roadmap

### V1 MVP ✅
- [x] Core app structure
- [x] Supabase auth and database
- [x] Design system (Onemor/TITAN-inspired)
- [x] ExerciseDB integration
- [x] Progressive overload algorithms
- [x] Gamification system
- [x] Nutrition calculator
- [x] Community/Tribe database

### V2 MVP ✅
- [x] Comprehensive sample workouts (1 per muscle group + complex/isolation)
- [x] Working "Start Program" enrollment flow
- [x] Full workout overview with exercises
- [x] Active workout player with set logging
- [x] Progress tracking (PRs, volume charts, streak history)
- [x] Enhanced home screen with quick actions
- [x] Progressive overload weight suggestions
- [x] Management app database preparation

### V2.1 Fixes ✅
- [x] Fixed floating bubble text spacing/overflow
- [x] Fixed workout logging for demo/quick workouts
- [x] Added animated GIFs for all exercises
- [x] Improved user stats tracking (streak, volume, total workouts)
- [x] Migration 006: Added missing user columns and real exercise media

### V3 MVP ✅ (Full Functionality)
- [x] Fixed onboarding save with all missing DB columns and RLS policies
- [x] Fixed auth flow - sign-in routing and onboarding check
- [x] 300+ exercise library with GIFs, instructions, and full metadata
- [x] 6 complete programs with structured workouts (Foundation, Hypertrophy, Functional, Powerbuilding, Home, HIIT)
- [x] Program enrollment working with proper RLS policies
- [x] Workout logging with set tracking and immediate feedback
- [x] Gamification system - streaks, points, PRs, badges
- [x] Progressive overload algorithm with weight suggestions
- [x] Tribe/community screen with leaderboard
- [x] Admin management RLS policies and audit logging
- [x] Profile screen with real user stats

### QA Sign-off ✅
- [x] Backend data integrity validated (user creation, onboarding, enrollment, logging)
- [x] Gamification verified (streaks, points, PRs, badges)
- [x] Progressive overload algorithms validated (2-for-2 rule, plateau detection, RPE adjustment)
- [x] All user flows tested (signup to first workout)
- [x] UI components verified (buttons, images, forms, navigation)
- [x] No linter errors across key files

### V3.1 Comprehensive Exercise Library ✅
- [x] 100+ exercises with full metadata in SQL migration
- [x] Equipment catalog (free weights, machines, bodyweight, cardio, accessories)
- [x] Muscle group taxonomy with sub-muscles
- [x] Movement pattern classification (squat, hinge, push, pull, carry, rotation, core)
- [x] Progression chain system (push-up, squat, pull-up, deadlift, bench, row)
- [x] Exercise filter provider with comprehensive matching logic
- [x] Exercise enhancement engine (auto-classify movement patterns, difficulty, location)
- [x] Media resolver service (MuscleWiki > ExerciseDB > Wger priority)
- [x] JSON schema files for equipment, muscles, movement patterns
- [x] Sample program JSON files with weekly progressions
- [x] Seed loader service for JSON to Supabase migration

### Next Up
- [ ] RevenueCat subscription integration
- [ ] OneSignal push notifications
- [ ] App Store / Play Store deployment
- [ ] Coach content management dashboard
- [ ] Expand exercise library to 1000+ with fetch script (ExerciseDB + MuscleWiki + Wger)

---

## Contributing

This is a private project for Coach Brian Parks. Contact for collaboration inquiries.

---

## License

Proprietary - All rights reserved.

---

**Built with ❤️ using Flutter and Supabase**
