# Saku — Personal Finance Tracker

> Record. Monitor. Save. All in your pocket.

Saku is a minimalist personal finance tracker for Indonesian users, built with Flutter and a strict **black & white iOS-style** design language.

---

## Highlights

- **Dashboard** — total balance, monthly income, monthly expense
- **Quick Add** — modal sheet with custom Rupiah keypad and category grid
- **History** — month selector, segmented filter (All / Income / Expense), swipe-to-delete
- **Reports** — daily-spending bar chart and category breakdown
- **Local first** — all data stored on device with Hive (no backend, no account)
- **Light / Dark** — both modes follow the system theme

---

## Design

- **Style:** Minimalist Black & White, Apple Human Interface Guidelines
- **Typography:** Inter (Google Fonts proxy for SF Pro)
- **Palette:** `#000000` · `#FFFFFF` · `#F5F5F5` · `#1C1C1E` · `#8E8E93` · `#E0E0E0` · `#2C2C2E`
- **Currency:** IDR with dot thousand separator (e.g. `Rp 1.250.000`) — all amounts stored as `int` (no decimals)

---

## Tech stack

| Layer            | Choice                                |
| ---------------- | ------------------------------------- |
| Framework        | Flutter (stable channel)              |
| Architecture     | Clean Architecture (data/domain/UI)   |
| State management | flutter_riverpod                      |
| Routing          | go_router (with `ShellRoute`)         |
| Local storage    | Hive CE (`hive_ce`, `hive_ce_flutter`)|
| Charts           | fl_chart                              |
| Code generation  | freezed, json_serializable, hive_ce_generator |
| Typography       | google_fonts (Inter)                  |

> Hive CE is used in place of the original `hive`/`hive_flutter` packages because the originals no longer support the latest Dart analyzer. The public API is identical.

---

## Project structure

```
lib/
├── main.dart                      # Default entry → bootstraps `Flavor.development`
├── main_development.dart          # Explicit dev entry point
├── main_production.dart           # Explicit prod entry point
├── hive_registrar.g.dart          # Generated — registers all Hive adapters
│
├── app/
│   ├── app.dart                   # MaterialApp.router + theme + router
│   ├── router.dart                # go_router configuration
│   ├── main_shell.dart            # ShellRoute scaffold + bottom NavigationBar
│   └── theme.dart                 # Light & dark themes (B&W)
│
├── core/
│   ├── config/
│   │   └── flavor_config.dart     # Flavor enum + runtime config
│   ├── constants/
│   │   ├── app_strings.dart       # Centralized UI strings
│   │   └── categories.dart        # `kCategories` + `categoryById()`
│   ├── errors/
│   │   └── failure.dart           # Sealed `Failure` hierarchy
│   └── utils/
│       ├── currency_formatter.dart # `formatRupiah()` / `parseRupiah()`
│       └── date_helper.dart        # Date formatting + month math
│
└── features/
    ├── splash/
    │   └── presentation/pages/splash_page.dart
    │
    └── transaction/
        ├── data/
        │   ├── datasources/transaction_local_datasource.dart
        │   ├── models/transaction_model.dart           # Hive `@HiveType`
        │   └── repositories/transaction_repository_impl.dart
        │
        ├── domain/
        │   ├── entities/
        │   │   ├── transaction.dart                    # Freezed
        │   │   └── transaction_summary.dart            # Freezed
        │   ├── repositories/transaction_repository.dart # Abstract
        │   └── usecases/
        │       ├── add_transaction.dart
        │       ├── delete_transaction.dart
        │       ├── get_all_transactions.dart
        │       ├── get_transactions_by_month.dart
        │       └── get_summary.dart
        │
        └── presentation/
            ├── providers/transaction_provider.dart    # Riverpod wiring
            ├── pages/
            │   ├── home_page.dart
            │   ├── add_transaction_page.dart
            │   ├── history_page.dart
            │   └── report_page.dart
            └── widgets/
                ├── amount_input.dart      # Custom numeric keypad
                ├── balance_card.dart      # Black hero card on Home
                ├── category_picker.dart   # 3-column category grid
                ├── month_selector.dart    # < May 2026 >
                ├── monthly_chart.dart     # fl_chart bar graph
                └── transaction_item.dart  # Single row
```

---

## Architecture — Clean Architecture flow

```
presentation (UI / Riverpod)
        │  reads
        ▼
   use cases (domain)         ← no Flutter, pure Dart
        │  uses
        ▼
   abstract repository (domain)
        ▲
        │  implemented by
        ▼
 repository impl (data)
        │  delegates to
        ▼
   local datasource (data)    ← talks to Hive box
```

**Strict rules** (enforced by code review and `.cursorrules`):

- Presentation never imports from `data/`. It only depends on use cases through Riverpod providers.
- Domain has zero Flutter imports.
- All monetary amounts are `int` IDR (no decimals).
- Use `formatRupiah()` for any on-screen amount.
- New feature checklist: entity → abstract repository → repository impl → datasource → use case → provider → UI.

---

## Data model

### Domain entity

```dart
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,    // income | expense
    required int amount,              // IDR, no decimals
    required String categoryId,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}
```

### Hive model

`TransactionModel` (`typeId: 0`) is a thin Hive-friendly mirror with `toEntity()` / `fromEntity()` mappers. It is the only class that knows about Hive.

---

## Riverpod providers (presentation)

| Provider                              | Purpose                                                     |
| ------------------------------------- | ----------------------------------------------------------- |
| `transactionBoxProvider`              | Provides the open `Box<TransactionModel>` (overridden in `main.dart`) |
| `transactionLocalDataSourceProvider`  | Wraps the Hive box                                          |
| `transactionRepositoryProvider`       | Concrete `TransactionRepositoryImpl`                        |
| `addTransactionUseCaseProvider`       | `AddTransaction` use case                                   |
| `deleteTransactionUseCaseProvider`    | `DeleteTransaction` use case                                |
| `getAllTransactionsUseCaseProvider`   | `GetAllTransactions` use case                               |
| `getTransactionsByMonthUseCaseProvider` | `GetTransactionsByMonth` use case                         |
| `getSummaryUseCaseProvider`           | `GetSummary` use case                                       |
| `allTransactionsStreamProvider`       | `StreamProvider` of all transactions, reactive to Hive changes |
| `selectedMonthProvider`               | Currently-selected month for History / Report               |
| `monthTransactionsProvider`           | Transactions filtered by `selectedMonthProvider`            |
| `monthSummaryProvider`                | Summary computed from `monthTransactionsProvider`           |
| `overallSummaryProvider`              | All-time summary used by the Home balance card              |

---

## Screens

| Route        | Page                                  | Notes                                                       |
| ------------ | ------------------------------------- | ----------------------------------------------------------- |
| `/splash`    | `SplashPage`                          | 2.5s pure-Flutter animation, then auto-routes to `/home`    |
| `/home`      | `HomePage`                            | Balance card + recent 5 transactions, FAB → Add modal       |
| `/add`       | (modal sheet) `AddTransactionPage`    | Segmented Expense/Income, keypad, category grid, date, notes |
| `/history`   | `HistoryPage`                         | Month selector + filter + grouped list with swipe-to-delete |
| `/report`    | `ReportPage`                          | Stat cards, daily-spending bar chart, category breakdown    |

The Add tab in the bottom `NavigationBar` opens the same modal sheet (it doesn't push a route).

---

## Bottom navigation

```dart
NavigationBar(
  destinations: [
    NavigationDestination(icon: Icons.home_outlined,        selectedIcon: Icons.home,        label: 'Home'),
    NavigationDestination(icon: Icons.add_circle_outline,   selectedIcon: Icons.add_circle,  label: 'Add'),
    NavigationDestination(icon: Icons.list_alt_outlined,    selectedIcon: Icons.list_alt,    label: 'History'),
    NavigationDestination(icon: Icons.bar_chart_outlined,   selectedIcon: Icons.bar_chart,   label: 'Report'),
  ],
)
```

---

## Flavors

Saku ships with two real platform-level flavors plus matching Dart bootstrap entry points. They can be installed side-by-side on the same device.

### Dart layer (`lib/core/config/flavor_config.dart`)

| Flavor        | App title    | Hive box suffix | Dart entry point             |
| ------------- | ------------ | --------------- | ---------------------------- |
| `development` | `Saku (Dev)` | `_dev`          | `lib/main_development.dart`  |
| `production`  | `Saku`       | _(none)_        | `lib/main_production.dart`   |

The Hive box-name suffix means dev and prod data never collide on the same device.

### Android (`android/app/build.gradle.kts`)

Two product flavors on the `env` dimension:

| Flavor        | `applicationId`              | App label   | Version name suffix |
| ------------- | ---------------------------- | ----------- | ------------------- |
| `development` | `com.example.saku_apps.dev`  | `Saku Dev`  | `-dev`              |
| `production`  | `com.example.saku_apps`      | `Saku`      | _(none)_            |

The label is injected via the `${appName}` manifest placeholder in `AndroidManifest.xml`. Because the application IDs differ, both builds can coexist on the same Android device.

### iOS (`ios/Runner.xcodeproj/xcshareddata/xcschemes/`)

Two shared schemes are committed alongside the default one:

- `development.xcscheme`
- `production.xcscheme`

Both currently reuse the existing `Debug` / `Profile` / `Release` build configurations and the default `Runner.app` target. On iOS, behavioural differences are driven entirely by `--dart-define=FLAVOR=...` and `FlavorConfig`. If you later want different bundle IDs / display names per flavor, add per-flavor `.xcconfig` overrides (e.g. `Flutter/Development.xcconfig`) in Xcode.

### Running a flavor

```bash
# CLI
flutter run -t lib/main_development.dart --flavor development --dart-define=FLAVOR=development
flutter run -t lib/main_production.dart  --flavor production  --dart-define=FLAVOR=production --release

# Make
make run-dev
make run-prod

# VS Code
# Pick "Saku · Development (debug|profile|release)" or
#      "Saku · Production  (debug|profile|release)" from Run & Debug
```

---

## Build & run (Makefile)

The repo ships a `Makefile` with the following targets:

```bash
make get               # flutter pub get
make gen               # build_runner build (delete-conflicting-outputs)
make watch             # build_runner watch

make run-dev           # flutter run, dev flavor
make run-prod          # flutter run --release, prod flavor

make apk-dev           # debug APK from dev flavor
make apk-prod          # release APK from prod flavor (--split-per-abi)
make appbundle-prod    # release AAB for the Play Store

make ios-dev           # iOS dev build (no codesign)
make ios-prod          # iOS prod release build

make analyze           # flutter analyze
make format            # dart format .
make test              # flutter test
```

Equivalent raw Flutter commands if you don't have `make`:

```bash
# APK — Development
flutter build apk -t lib/main_development.dart --dart-define=FLAVOR=development --debug

# APK — Production (split per ABI)
flutter build apk -t lib/main_production.dart --dart-define=FLAVOR=production --release --split-per-abi

# App Bundle — Production
flutter build appbundle -t lib/main_production.dart --dart-define=FLAVOR=production --release
```

---

## Code generation

Whenever you change a `@freezed` class or a `@HiveType` model, regenerate sources:

```bash
make gen
# or
dart run build_runner build --delete-conflicting-outputs
```

---

## Categories

Defined in `lib/core/constants/categories.dart`. Each category has an `id`, `label`, and an emoji `icon`. Add new categories by appending to `kCategories` — no code changes elsewhere required.

| Icon | Label          |
| ---- | -------------- |
| 🍽️    | Food           |
| 🍺    | Drink          |
| ☕️    | Coffee         |
| 💧    | Mineral Water  |
| 🚬    | Cigar          |
| ⛽️    | Fuel           |
| 🚗    | Transport      |
| 🌐    | Internet Wifi  |
| 📱    | Quota          |
| 🧼    | Toiletries     |
| 🏠    | Rent           |
| 🍫    | Snack          |
| 🍜    | Street Food    |
| 🛍️    | Shopping       |
| 💼    | Salary         |
| 🎁    | Bonus          |
| 📦    | Others         |

---

## Currency formatting

```dart
formatRupiah(0);          // "Rp 0"
formatRupiah(1250000);    // "Rp 1.250.000"
formatRupiah(3251606);    // "Rp 3.251.606"
formatRupiah(-1500);      // "-Rp 1.500"
```

---

## Assets

Registered in `pubspec.yaml`:

```
assets/app_icons/   # 1024×1024 master + per-platform sizes
assets/icons/       # Custom SVG/PNG icons (Stitch-generated)
assets/images/      # Illustrations / empty-state art
```

App icons are already generated in `assets/app_icons/` (Android, iPad, iPhone, App Store, Play Store sizes).

---

## Quality gates

This project keeps the following clean:

```bash
flutter analyze   # 0 issues
flutter test      # currency formatter unit tests
```

---

## Changelog (project bootstrap)

**2026-05-23 — Initial scaffold**

- Replaced default Flutter counter app with the full Saku architecture.
- Added Clean-Architecture layered structure (`data` / `domain` / `presentation`) under `lib/features/transaction/`.
- Wired Hive CE (`hive_ce` + `hive_ce_flutter` + `hive_ce_generator`) — chosen over `hive` because the original is incompatible with the current Dart analyzer.
- Added Riverpod providers for the entire transaction feature, including a reactive `Hive.box.watch()`-backed stream.
- Implemented Splash → Home → Add → History → Report flows with go_router `ShellRoute` and a black & white `NavigationBar`.
- Added flavor system (`Flavor.development` / `Flavor.production`) with separate Hive box names to keep dev and prod data isolated.
- Added `Makefile` with `apk-dev`, `apk-prod`, `appbundle-prod`, and per-flavor run/iOS targets.
- Added `formatRupiah()` and accompanying unit tests.

**2026-05-23 — Editor + platform flavors**

- Added `.vscode/launch.json` (8 launch configs: dev/prod × debug/profile/release plus default-entry and tests), `.vscode/settings.json`, and `.vscode/tasks.json` for one-click pub-get / analyze / build_runner / APK / AAB tasks.
- Wired real **Android product flavors** in `android/app/build.gradle.kts` (`development` → `com.example.saku_apps.dev` with label `Saku Dev`, `production` → `com.example.saku_apps` with label `Saku`). `AndroidManifest.xml` now uses an `${appName}` manifest placeholder.
- Added matching **iOS Xcode schemes** (`development.xcscheme`, `production.xcscheme`) so `flutter run --flavor development|production` works on both platforms.
- Updated `Makefile` and `.vscode/tasks.json` to pass `--flavor` to all Flutter run/build commands.

> *"Healthy finances start with organized records."* 🪙
