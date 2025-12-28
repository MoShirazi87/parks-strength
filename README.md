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

- [x] Core app structure
- [x] Supabase auth and database
- [x] Design system (Onemor/TITAN-inspired)
- [x] ExerciseDB integration
- [x] Progressive overload algorithms
- [x] Gamification system
- [x] Nutrition calculator
- [x] Community/Tribe database
- [ ] Active workout player refinement
- [ ] RevenueCat subscription integration
- [ ] OneSignal push notifications
- [ ] App Store / Play Store deployment
- [ ] Coach content management

---

## Contributing

This is a private project for Coach Brian Parks. Contact for collaboration inquiries.

---

## License

Proprietary - All rights reserved.

---

**Built with ❤️ using Flutter and Supabase**
