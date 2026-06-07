# Saku — Personal Finance Tracker

> Catat. Pantau. Hemat. Semua di saku Anda.

Saku is a minimalist personal finance tracker for Indonesian users, built with Flutter and a strict **black & white iOS-style** design language. All data is stored locally on device — no backend, no account required.

---

## Highlights

| Feature | Description |
| -------- | ------------ |
| **Dashboard** | Balance card, wallet filter chips, recent transactions |
| **Quick Add** | Modal sheet with custom Rupiah keypad and category grid |
| **History** | Month selector, filter (Semua / Pemasukan / Pengeluaran / Transfer) |
| **Reports** | Daily spending chart and category breakdown |
| **Search** | Full-text search by category, notes, or amount |
| **Wallets** | Multiple wallets (Kas, BCA, e-wallet, etc.) with computed balance |
| **Transfer** | Move balance between wallets — not counted as income/expense |
| **Settings** | Theme, daily reminder, CSV export, clear all data |
| **Flavors** | Development & Production side-by-side installs |

---

## Design

- **Style:** Minimalist Black & White, Apple Human Interface Guidelines
- **Typography:** Inter (bundled in `assets/fonts/`)
- **Icons:** [HugeIcons](https://hugeicons.com/) (monochrome stroke style)
- **Palette:** `#000000` · `#FFFFFF` · `#F5F5F5` · `#1C1C1E` · `#8E8E93` · `#E0E0E0` · `#2C2C2E`
- **Currency:** IDR with dot thousand separator (e.g. `Rp 1.250.000`) — all amounts stored as `int` (no decimals)
- **Language:** UI strings in Bahasa Indonesia (`lib/core/constants/app_strings.dart`)

---

## Tech stack

| Layer | Choice |
| ----- | ------ |
| Framework | Flutter (stable channel, Dart ^3.8.0) |
| Architecture | Clean Architecture (data / domain / presentation) |
| State management | flutter_riverpod |
| Routing | go_router (ShellRoute + CustomTransitionPage) |
| Local storage | Hive CE (`hive_ce`, `hive_ce_flutter`) |
| Charts | fl_chart |
| Notifications | flutter_local_notifications + timezone |
| Code generation | freezed, json_serializable, hive_ce_generator |
| Animation | lottie (splash screen) |

> Hive CE replaces the original `hive` package — same public API, maintained for current Dart analyzer.

---

## Architecture

```
presentation (UI / Riverpod providers)
        │  reads use cases via providers
        ▼
   use cases (domain)              ← pure Dart, no Flutter imports
        │  uses abstract repository
        ▼
   abstract repository (domain)
        ▲
        │  implemented by
        ▼
 repository impl (data)
        │  delegates to
        ▼
   local datasource (data)         ← talks to Hive Box
        │
        ▼
   Hive model (data)               ← @HiveType, toEntity() / fromEntity()
        │
        ▼
   Freezed entity (domain)         ← business object used by UI & use cases
```

### Rules (enforced in `.cursorrules`)

1. **Presentation** never imports from `data/` — only domain entities and providers.
2. **Domain** has zero Flutter imports.
3. All monetary amounts are `int` IDR — use `formatRupiah()` for display.
4. New feature checklist: entity → abstract repo → repo impl → datasource → use cases → provider → UI → route → main.dart box registration → `build_runner`.
5. Black & white design only — no accent colors.

---

## Project structure

```
lib/
├── main.dart                          # Default entry → Flavor.development
├── main_development.dart              # Explicit dev entry
├── main_production.dart             # Explicit prod entry
├── hive_registrar.g.dart              # Generated Hive adapter registration
│
├── app/
│   ├── app.dart                       # MaterialApp.router + themeMode
│   ├── router.dart                    # go_router routes
│   ├── main_shell.dart                # Bottom NavigationBar shell
│   └── theme.dart                     # Light & dark B&W themes
│
├── core/
│   ├── config/flavor_config.dart      # Flavor enum + Hive box suffix
│   ├── constants/
│   │   ├── app_strings.dart           # All UI strings (Indonesian)
│   │   └── categories.dart            # Transaction categories + HugeIcons
│   ├── services/notification_service.dart
│   └── utils/
│       ├── currency_formatter.dart    # formatRupiah() / parseRupiah()
│       └── date_helper.dart           # Indonesian date formatting
│
└── features/
    ├── splash/
    │   └── presentation/pages/splash_page.dart
    │
    ├── transaction/                   # Core feature (Phase 1)
    │   ├── data/                      # TransactionModel (typeId: 0)
    │   ├── domain/
    │   └── presentation/
    │       ├── providers/transaction_provider.dart
    │       ├── pages/                 # home, add, history, report
    │       └── widgets/             # balance_card, amount_input, etc.
    │
    ├── settings/                        # Phase 1
    │   ├── data/settings_datasource.dart
    │   └── presentation/pages/settings_page.dart
    │
    ├── search/                          # Phase 2
    │   └── presentation/
    │       ├── pages/search_page.dart
    │       └── widgets/search_bar_widget.dart
    │
    ├── wallets/                         # Phase 2
    │   ├── data/models/wallet_model.dart          # typeId: 1
    │   ├── domain/utils/wallet_balance.dart       # Balance formula
    │   └── presentation/
    │       ├── providers/wallet_provider.dart
    │       └── pages/                 # wallets, add_wallet, wallet_detail
    │
    └── transfer/                        # Phase 2
        ├── data/models/wallet_transfer_model.dart # typeId: 4
        ├── domain/usecases/
        │   ├── execute_transfer.dart
        │   └── delete_transfer.dart
        └── presentation/
            ├── providers/transfer_provider.dart
            ├── pages/transfer_history_page.dart
            └── widgets/               # transfer_sheet, transfer_item
```

---

## Data model & Hive boxes

All Hive boxes use a flavor suffix (`_dev` for development) so dev and prod data never collide.

| Box name | Model | typeId | Purpose |
| -------- | ----- | ------ | ------- |
| `transactions` | `TransactionModel` | 0 | Income & expense records |
| `wallets` | `WalletModel` | 1 | Wallet definitions |
| `wallet_transfers` | `WalletTransferModel` | 4 | Inter-wallet transfers |
| `settings` | plain Map | — | Theme, notifications, preferences |

> typeIds 2 (recurring) and 3 (budget) are reserved for upcoming Phase 2 features.

### Transaction entity

```dart
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required TransactionType type,       // income | expense
    required int amount,                 // IDR integer
    required String categoryId,
    @Default('default') String walletId, // linked wallet
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _Transaction;
}
```

### Wallet entity

```dart
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String name,
    required String icon,          // emoji e.g. '💵'
    @Default(0) int seedBalance,   // initial balance before app usage
    required bool isDefault,
    required DateTime createdAt,
  }) = _Wallet;
}
```

### Wallet transfer entity

```dart
@freezed
abstract class WalletTransfer with _$WalletTransfer {
  const factory WalletTransfer({
    required String id,
    required String fromWalletId,
    required String toWalletId,
    required int amount,
    required DateTime date,
    String? notes,
    required DateTime createdAt,
  }) = _WalletTransfer;
}
```

### Wallet balance formula

Balance is **computed**, not stored on the wallet entity:

```
saldo = seedBalance
      + total pemasukan (walletId match)
      - total pengeluaran (walletId match)
      + transfer masuk (toWalletId match)
      - transfer keluar (fromWalletId match)
```

Implementation: `lib/features/wallets/domain/utils/wallet_balance.dart`

Transfer does **not** create income/expense transactions. Deleting a transfer record automatically reverses its balance effect because balance is derived from stored records.

---

## Routes

| Route | Page | Access |
| ----- | ---- | ------ |
| `/splash` | SplashPage | App launch (Lottie animation) |
| `/home` | HomePage | Bottom nav — Beranda |
| `/add` | AddTransactionPage | FAB tap / bottom nav Tambah (modal) |
| `/history` | HistoryPage | Bottom nav — Riwayat |
| `/report` | ReportPage | Bottom nav — Laporan |
| `/search` | SearchPage | Search icon on Home / History AppBar |
| `/settings` | SettingsPage | Gear icon on Home AppBar |
| `/wallets` | WalletsPage | Wallet icon on Home AppBar |
| `/wallets/:id` | WalletDetailPage | Tap wallet in list |
| `/transfers` | TransferHistoryPage | Wallet detail → Riwayat Transfer |
| `/transfers?walletId=X` | TransferHistoryPage | Filtered by wallet |

---

## Key Riverpod providers

### Transaction

| Provider | Purpose |
| -------- | ------- |
| `transactionBoxProvider` | Open Hive box (overridden in main.dart) |
| `allTransactionsStreamProvider` | Reactive stream of all transactions |
| `selectedMonthProvider` | Selected month for History / Report |
| `monthTransactionsProvider` | Transactions filtered by selected month |
| `searchQueryProvider` / `searchResultsProvider` | Search feature |

### Wallets

| Provider | Purpose |
| -------- | ------- |
| `walletBoxProvider` | Open Hive box (overridden in main.dart) |
| `walletsStreamProvider` | Reactive stream of all wallets |
| `selectedWalletIdProvider` | Home page wallet filter (`null` = Semua) |
| `walletCurrentBalanceProvider` | Computed balance per wallet (includes transfers) |
| `totalBalanceProvider` | Sum of all wallet balances |

### Transfer

| Provider | Purpose |
| -------- | ------- |
| `transferBoxProvider` | Open Hive box (overridden in main.dart) |
| `allTransfersStreamProvider` | Reactive stream of all transfers |
| `monthTransfersProvider` | Transfers filtered by selected month |
| `executeTransferUseCaseProvider` | Validate balance + save transfer |
| `deleteTransferUseCaseProvider` | Delete transfer (auto-reverses balance) |

---

## Getting started

### Prerequisites

- Flutter SDK (stable channel, Dart ^3.8.0)
- Android Studio / Xcode for platform builds
- Make (optional, for Makefile shortcuts)

### First-time setup

```bash
# 1. Clone and enter project
cd saku_apps

# 2. Install dependencies
flutter pub get

# 3. Generate Freezed + Hive code
dart run build_runner build

# 4. Run development flavor
flutter run -t lib/main_development.dart --flavor development --dart-define=FLAVOR=development
```

### VS Code

Use **Run & Debug** panel — pick `Saku · Development (debug)` or `Saku · Production (release)`.

Config lives in `.vscode/launch.json`.

---

## Build commands (Makefile)

```bash
make get               # flutter pub get
make gen               # build_runner build
make watch             # build_runner watch

make run-dev           # Run development flavor
make run-prod          # Run production flavor (release)

make apk-dev           # Debug APK (development)
make apk-prod          # Release APK split-per-ABI (production)
make appbundle-prod    # Play Store AAB

make analyze           # flutter analyze
make test              # flutter test
make format            # dart format .
```

### Raw Flutter commands

```bash
# Development APK
flutter build apk -t lib/main_development.dart --dart-define=FLAVOR=development --debug

# Production APK
flutter build apk -t lib/main_production.dart --dart-define=FLAVOR=production --release --split-per-abi

# Production App Bundle
flutter build appbundle -t lib/main_production.dart --dart-define=FLAVOR=production --release
```

---

## Flavors

| Flavor | App title | Hive suffix | Android applicationId |
| ------ | --------- | ----------- | --------------------- |
| `development` | Saku (Dev) | `_dev` | `com.example.saku_apps.dev` |
| `production` | Saku | _(none)_ | `com.example.saku_apps` |

Both flavors can be installed side-by-side on the same device.

Entry points:
- `lib/main_development.dart`
- `lib/main_production.dart`
- `lib/main.dart` (defaults to development)

---

## Code generation

Run after changing any `@freezed` class or `@HiveType` model:

```bash
dart run build_runner build
# or
make gen
```

Generated files (do not edit manually):
- `*.freezed.dart` — Freezed immutable classes
- `*.g.dart` — Hive type adapters
- `lib/hive_registrar.g.dart` — Central adapter registration

---

## Adding a new Hive model manually

If you add a new `@HiveType` model, follow these steps:

1. Create the model in `features/<feature>/data/models/`
2. Assign a unique `typeId` (see table above — don't reuse existing IDs)
3. Run `dart run build_runner build`
4. Verify `lib/hive_registrar.g.dart` includes your adapter
5. Open the box in `lib/main.dart`:

```dart
final myBox = await Hive.openBox<MyModel>('my_box_name$suffix');
```

6. Create a Riverpod provider and override it in `ProviderScope`:

```dart
final myBoxProvider = Provider<Box<MyModel>>((ref) {
  throw UnimplementedError('Override in main.dart');
});

// In bootstrap():
overrides: [
  myBoxProvider.overrideWithValue(myBox),
],
```

---

## Adding a new feature manually

Follow this order (Clean Architecture):

```
1. domain/entities/          → @freezed entity
2. domain/repositories/      → abstract repository interface
3. data/models/              → @HiveType model (if persisted)
4. data/datasources/         → Hive CRUD + watch stream
5. data/repositories/        → repository implementation
6. domain/usecases/          → one class per operation
7. presentation/providers/   → Riverpod wiring
8. presentation/pages/       → screens
9. presentation/widgets/     → reusable components
10. app/router.dart          → GoRoute
11. main.dart                → open Hive box + provider override
12. core/constants/app_strings.dart → UI strings
13. dart run build_runner build
```

---

## User guide

### Add a transaction
1. Tap **+** FAB on Home (or bottom nav **Tambah**)
2. Choose Pemasukan / Pengeluaran
3. Enter amount via keypad, pick category, date, optional notes
4. If multiple wallets exist, pick a wallet
5. Tap **Simpan**

### Transfer between wallets
1. **Long-press** the **+** FAB on Home → choose **Transfer**
   - Or tap **⇄** on Wallet Detail page
2. Select **Dari** and **Ke** wallets (tap ⇄ to swap)
3. Enter amount, date, optional notes
4. Tap **Transfer Sekarang**
5. View history: Wallet Detail → **Riwayat Transfer**, or History tab → **Transfer**

### Manage wallets
1. Tap wallet icon on Home AppBar → **Dompet**
2. Tap **+** to add wallet (name, emoji icon, saldo awal)
3. Long-press wallet → Edit / Set default / Delete (default wallet cannot be deleted)
4. Tap wallet → see balance and transactions

### Search transactions
1. Tap search icon on Home or History AppBar
2. Type category name, notes, or amount
3. Results update in real-time (300ms debounce)

### Settings
- Theme: Sistem / Terang / Gelap
- Daily reminder notification
- Export CSV / Clear all data

---

## Assets

```
assets/
├── app_icons/       # App launcher icons (all platforms)
├── fonts/           # Inter font family (bundled)
├── icons/           # app_icon.png
├── images/
└── lottie/          # Splash animation (Loading.json)
```

Declared in `pubspec.yaml` under `flutter: assets:` and `fonts:`.

---

## Android notes

- **NDK version** pinned to `27.0.12077973` in `android/app/build.gradle.kts`
- **Core library desugaring** enabled for `flutter_local_notifications`
- **Product flavors** on `env` dimension: `development`, `production`

---

## Quality gates

```bash
flutter analyze    # Should pass with 0 errors
flutter test       # Unit tests (currency formatter, etc.)
```

---

## Phase 2 roadmap

| Feature | Status |
| ------- | ------ |
| Multiple Wallets | ✅ Done |
| Search Transaction | ✅ Done |
| Transfer Between Wallets | ✅ Done |
| Recurring Transaction | 🔲 Planned (typeId: 2) |
| Budget Planner | 🔲 Planned (typeId: 3) |

Rule files for each feature live in `.cursor/rules/`.

---

## Changelog

**2026-06-02 — Transfer Between Wallets**
- Added `WalletTransfer` entity + Hive model (typeId: 4)
- Transfer sheet, history page, History tab filter
- FAB long-press speed dial (Add Transaction / Transfer)
- Wallet balance formula updated to include transfers
- Comprehensive README rewrite

**2026-06-01 — Search + Wallets (Phase 2)**
- Multiple wallets with computed balance
- Search page with debounced full-text filter
- Wallet chips on Home, wallet picker on Add Transaction
- Default "Kas" wallet seeded on first launch

**2026-05-23 — Phase 1 bootstrap**
- Clean Architecture scaffold, Hive CE, Riverpod, go_router
- Splash, Home, Add, History, Report, Settings
- Flavor system (development / production)
- Inter font bundled, HugeIcons, Lottie splash
- Indonesian UI strings

---

> *"Keuangan sehat dimulai dari catatan yang rapi."* 🪙
