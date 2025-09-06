import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/failures.dart';
import '../entities/random_fact.dart';
import '../repositories/random_facts_repository.dart';

class GetRandomFactUseCase {
  const GetRandomFactUseCase(this._repository);

  final RandomFactsRepository _repository;

  Future<Either<Failure, RandomFact>> call({String language = 'en'}) =>
      _repository.getRandomFact(language: language);
}
