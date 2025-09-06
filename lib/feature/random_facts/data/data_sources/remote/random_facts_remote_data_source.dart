import '../../api/random_facts_api.dart';
import '../../models/random_fact_model.dart';

abstract class RandomFactsRemoteDataSource {
  Future<RandomFactModel> getRandomFact(String language);
}

class RandomFactsRemoteDataSourceImpl implements RandomFactsRemoteDataSource {
  RandomFactsRemoteDataSourceImpl(this._api);

  final RandomFactsApi _api;

  @override
  Future<RandomFactModel> getRandomFact(String language) {
    return _api.getRandomFact(language: language);
  }
}
