<div align="center">

## Flutter Clean Architecture Boilerplate

Opinionated template featuring layered architecture, code generation, flavors, localization, and robust DX tooling.

---

| Stack | Highlights |
|-------|------------|
| Architecture | Clean Architecture (Presentation / Domain / Data) |
| State Mgmt | `flutter_bloc` + immutable states (`freezed`) |
| Networking | `dio` + `alice` inspector + smart retry |
| Data Layer | Repositories + Hive local storage + Retrofit codegen |
| Error Handling | Functional `Either` via `fpdart` + failure mapping |
| DI | `get_it` with modular feature registration |
| Codegen | `freezed`, `json_serializable`, `retrofit`, Hive adapters |
| Environments | Flavors: `dev`, `staging`, `prod` (with `--dart-define-from-file`) |
| Localization | `easy_localization` with runtime language switching |
| Scaffolding | Mason bricks (`gen_module`) |

</div>

---

## 1. Project Structure

```
flutter_clean_architecture/
├── assets
│   ├── images/
│   └── translations/              # i18n JSON files (en.json, es.json, ...)
├── config
│   ├── config.dev.json
│   ├── config.staging.json
│   └── config.prod.json
├── lib
│   ├── app.dart                   # Root MaterialApp setup
│   ├── bootstrap.dart             # Startup & guarded zone
│   ├── flavors.dart               # Flavor enum + helpers
│   ├── core
│   │   ├── dependency/            # DI setup & service locators
│   │   ├── entity/                # Base errors / failure mapping
│   │   ├── storage/               # Hive storage wrapper
│   │   ├── network/               # Dio client, interceptors, alice
│   │   └── utils/                 # Logger & helpers
│   ├── feature
│   │   └── random_facts           # Example feature (data/domain/presentation)
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── gen/                       # flutter_gen outputs
│   ├── main_dev.dart              # Entry per flavor
│   ├── main_staging.dart
│   └── main_prod.dart
├── pubspec.yaml
└── README.md
```

---

## 2. Clean Architecture Layers

Presentation (Widgets + Bloc): Feature UI, reacts to domain outputs.
Domain (Entities, UseCases, Repository contracts, Failures): Pure logic; platform-agnostic.
Data (DTOs, Retrofit services, DataSources, Repository implementations): Talks to network/storage and maps to domain entities.

Error flow: Data layer converts exceptions -> Failures -> Presented via mapper (`mapFailureToMessage`).

---

## 3. Dependency Injection

`get_it` registers core + dynamically injected feature modules in `bootstrap.dart` via `configureDependencies`. New features add their own module file (see Mason generation) and are appended automatically between the mason markers.

---

## 4. Flavors & Environment Config

Three flavors: `dev`, `staging`, `prod`.

Dart defines are sourced from JSON files using `--dart-define-from-file=config/config.<flavor>.json`.

Run examples:

```bash
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/config.dev.json
flutter run --flavor staging -t lib/main_staging.dart --dart-define-from-file=config/config.staging.json
flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/config.prod.json
```

Provided VS Code tasks / build scripts (Android & iOS) already include these flags.

---

## 5. Localization (easy_localization)

Configured in `bootstrap.dart` wrapping `App` with `EasyLocalization`.

Current supported locales: `en`, `es`.

Files live under `assets/translations/` and are declared in `pubspec.yaml`.

Runtime switching UI: Popup language selector in `RandomFactPage` AppBar.

Add a new language:
1. Create `assets/translations/<lang>.json` (copy `en.json` structure). Example key set:
	 ```json
	 {
		 "app_title": "Flutter Clean Architecture",
		 "random_fact": { "title": "Random Fact" }
	 }
	 ```
2. Add new `Locale('<lang>')` to `supportedLocales` in `bootstrap.dart` inside `EasyLocalization`.
3. Re-run the app (hot restart if necessary).
4. Use in code: `'random_fact.title'.tr()`.

Best practice: Keep translation keys nested by feature domain (e.g., `random_fact.new_fact`).

---

## 6. Code Generation

Run all generators:

```bash
dart pub run build_runner build --delete-conflicting-outputs
```

You may also watch:

```bash
dart pub run build_runner watch --delete-conflicting-outputs
```

Generation covers:
* Retrofit API clients
* Freezed data classes / unions
* JSON serialization
* Hive adapters
* (Optionally) any additional builders you add later

---

## 7. Networking

`dio` configured with retry (`dio_smart_retry`) & `alice` inspector. In debug builds, a floating FAB exposes network inspector overlay (see `AliceDebugOverlay`).

---

## 8. Local Storage

`Hive` (community edition) initialized in `bootstrap`. Use `HiveAppStorage` abstraction for consistent access. Create adapters for new entities (Freezed + Hive annotations if needed).

---

## 9. Functional Error Handling

Use `Either<Failure, T>` (via `fpdart`) in domain use cases. Map infrastructure errors to `Failure` types in repositories. Convert `Failure` -> user-facing message with `mapFailureToMessage`.

---

## 10. Adding a New Feature (Mason)

The repo includes bricks:
* `gen_module` – full feature scaffold (data/domain/presentation + DI module)

Example (adjust variables as brick requires):

```bash
mason make gen_module --feature_name random_facts
```

Then run build_runner (if the feature introduced generated classes).

DI Registration markers in `bootstrap.dart` ensure automated insertion between:
```dart
// === mason:feature_imports ===
// === mason:feature_modules ===
```

---

## 11. Testing

`bloc_test` is included for Bloc logic. Recommended patterns:
* Write use case tests at domain layer.
* Use mocktail for repository fakes.
* Test failure mapping separately when adding new Failure types.

Run all tests:
```bash
flutter test
```

---

## 12. Localization Key Hygiene

Prefix keys with feature segment: `featureName.section.action`.
Avoid dynamic sentence construction that leads to grammar issues in other locales.
If you need plurals, enable `plural()` helpers from `easy_localization` (add keys like `item_count`: `{ "zero": "No items", "one": "1 item", "other": "{} items" }`).

---

## 13. Extending / Customizing

Ideas:
* Add CI pipeline (format, analyze, test, build flavors)
* Introduce caching layer for API responses with TTL
* Add authentication feature template
* Integrate code metrics (`dart_code_metrics`) and quality gates
* Add coverage reporting & badges

---

## 14. Common Commands (Cheat Sheet)

```bash
# Fetch dependencies
dart pub get

# Generate code
dart pub run build_runner build --delete-conflicting-outputs

# Run dev flavor
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/config.dev.json

# Build Android APK (dev)
flutter build apk --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/config.dev.json

# Build iOS (staging)
flutter build ios --flavor staging -t lib/main_staging.dart --dart-define-from-file=config/config.staging.json
```

---

## 15. Troubleshooting

| Issue | Fix |
|-------|-----|
| Missing translation key | Ensure JSON key exists & hot restart. Check asset path in `pubspec.yaml`. |
| `Target of URI doesn't exist` for generated file | Re-run build_runner. |
| Network inspector not showing | Ensure debug mode; FAB appears bottom-left. |
| Flavors not switching | Confirm `--flavor` & correct `main_*.dart` entrypoint. |

---

## 16. License

MIT

---

## 17. At a Glance

This boilerplate accelerates production-ready setup: layered separation, resilient networking, runtime localization, flavor-based configuration, and extensible code generation – all while keeping modules isolated and testable.

Happy building! 🚀

