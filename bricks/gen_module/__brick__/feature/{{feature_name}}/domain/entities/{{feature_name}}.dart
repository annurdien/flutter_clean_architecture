import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name}}.freezed.dart';
part '{{feature_name}}.g.dart';

@freezed
abstract class {{feature_name.pascalCase()}} with _${{feature_name.pascalCase()}} {
  const factory {{feature_name.pascalCase()}}({
{{{entity_params}}}
  }) = _{{feature_name.pascalCase()}};

  factory {{feature_name.pascalCase()}}.fromJson(Map<String, dynamic> json) => _${{feature_name.pascalCase()}}FromJson(json);
}
