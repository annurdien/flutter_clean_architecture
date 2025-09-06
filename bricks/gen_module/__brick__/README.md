# {{feature_name.pascalCase()}} Feature

Generated via gen_module brick.

Includes:
- Data layer (API, remote data source, repository impl)
- Domain layer (entity, repository abstraction, use case)
- Presentation layer (Bloc + page)
- DI module + bootstrap registration (inserted via hook)

Run build_runner after generation if using freezed/json_serializable:
```
flutter pub run build_runner build --delete-conflicting-outputs
```
