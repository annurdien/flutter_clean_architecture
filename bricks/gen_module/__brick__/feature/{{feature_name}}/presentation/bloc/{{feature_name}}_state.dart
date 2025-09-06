part of '{{feature_name}}_bloc.dart';

@freezed
abstract class {{feature_name.pascalCase()}}State with _${{feature_name.pascalCase()}}State {
  const factory {{feature_name.pascalCase()}}State({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    Failure? failure,
    {{feature_name.pascalCase()}}? entity,
  }) = _{{feature_name.pascalCase()}}State;
}

extension {{feature_name.pascalCase()}}StateX on {{feature_name.pascalCase()}}State {
  bool get hasError => failure != null;
}
