import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/{{feature_name}}.dart';

part '{{feature_name}}_model.freezed.dart';
part '{{feature_name}}_model.g.dart';

@freezed
abstract class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  const factory {{feature_name.pascalCase()}}Model({
{{{model_params}}}
  }) = _{{feature_name.pascalCase()}}Model;

  factory {{feature_name.pascalCase()}}Model.fromJson(Map<String, dynamic> json) => _${{feature_name.pascalCase()}}ModelFromJson(json);
}

extension {{feature_name.pascalCase()}}ModelX on {{feature_name.pascalCase()}}Model {
  {{feature_name.pascalCase()}} toDomain() => {{feature_name.pascalCase()}}(
{{{model_to_entity}}}
  );
}
