import 'package:fpdart/fpdart.dart';

import '../../../../core/entity/error/failures.dart';
import '../entities/random_fact.dart';

abstract class RandomFactsRepository {
  Future<Either<Failure, RandomFact>> getRandomFact({String language = 'en'});
}
