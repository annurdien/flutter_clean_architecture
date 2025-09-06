import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/dependency/app_dependency.dart';
{{#with_remote}}
import '../data/api/{{feature_name}}_api.dart';
import '../data/data_sources/remote/{{feature_name}}_remote_data_source.dart';
{{/with_remote}}
import '../data/repositories/{{feature_name}}_repository_impl.dart';
import '../domain/repositories/{{feature_name}}_repository.dart';
import '../domain/usecases/get_{{feature_name}}.dart';

class {{pascal_feature_name}}Module extends FeatureDiModule {
  @override
  void register(GetIt getIt) {
    getIt
      {{#with_remote}}
      ..registerFactory<{{pascal_feature_name}}Api>(() => {{pascal_feature_name}}Api(getIt<Dio>()))
      ..registerFactory<{{pascal_feature_name}}RemoteDataSource>(
        () => {{pascal_feature_name}}RemoteDataSourceImpl(getIt<{{pascal_feature_name}}Api>()),
      )
      {{/with_remote}}
      ..registerFactory<{{pascal_feature_name}}Repository>(
        () => {{pascal_feature_name}}RepositoryImpl(
          remote: getIt<{{pascal_feature_name}}RemoteDataSource>(),
        ),
      )
      ..registerFactory<Get{{pascal_feature_name}}UseCase>(
        () => Get{{pascal_feature_name}}UseCase(getIt<{{pascal_feature_name}}Repository>()),
      );
  }
}
