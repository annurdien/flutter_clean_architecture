import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/error_mapper.dart';
import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/random_fact.dart';
import '../../domain/repositories/random_facts_repository.dart';
import '../data_sources/remote/random_facts_remote_data_source.dart';
import '../models/random_fact_model.dart';

class RandomFactsRepositoryImpl implements RandomFactsRepository {
  RandomFactsRepositoryImpl({required RandomFactsRemoteDataSource remote})
    : _remote = remote;

  final RandomFactsRemoteDataSource _remote;

  @override
  Future<Either<Failure, RandomFact>> getRandomFact({
    String language = 'en',
  }) async {
    try {
      final RandomFactModel fact = await _remote.getRandomFact(language);
      return Right<Failure, RandomFact>(fact.toDomain());
    } catch (e, st) {
      return Left<Failure, RandomFact>(ErrorMapper.map(e, st));
    }
  }
}
