part of '{{feature_name}}_bloc.dart';

@freezed
abstract class {{feature_name.pascalCase()}}Event with _${{feature_name.pascalCase()}}Event {
  const factory {{feature_name.pascalCase()}}Event.started() = _Started;
  const factory {{feature_name.pascalCase()}}Event.refreshed() = _Refreshed;
}
