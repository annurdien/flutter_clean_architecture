import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/dependency/app_dependency.dart';
import '../data/api/random_facts_api.dart';
import '../data/data_sources/remote/random_facts_remote_data_source.dart';
import '../data/repositories/random_facts_repository_impl.dart';
import '../domain/repositories/random_facts_repository.dart';
import '../domain/usecases/get_random_fact.dart';

class RandomFactModule extends FeatureDiModule {
  @override
  void register(GetIt getIt) {
    getIt
      ..registerFactory<RandomFactsApi>(() => RandomFactsApi(getIt<Dio>()))
      ..registerFactory<RandomFactsRemoteDataSource>(
        () => RandomFactsRemoteDataSourceImpl(getIt<RandomFactsApi>()),
      )
      ..registerFactory<RandomFactsRepository>(
        () => RandomFactsRepositoryImpl(
          remote: getIt<RandomFactsRemoteDataSource>(),
        ),
      )
      ..registerFactory<GetRandomFactUseCase>(
        () => GetRandomFactUseCase(getIt<RandomFactsRepository>()),
      );
  }
}
