import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/random_fact_model.dart';

part 'random_facts_api.g.dart';

@RestApi(baseUrl: 'https://uselessfacts.jsph.pl')
abstract class RandomFactsApi {
  factory RandomFactsApi(Dio dio, {String baseUrl}) = _RandomFactsApi;

  @GET('/api/v2/facts/random')
  Future<RandomFactModel> getRandomFact({
    @Query('language') String language = 'en',
  });
}
