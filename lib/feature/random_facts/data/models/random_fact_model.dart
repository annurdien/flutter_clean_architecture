import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/random_fact.dart';

part 'random_fact_model.freezed.dart';
part 'random_fact_model.g.dart';

@freezed
abstract class RandomFactModel with _$RandomFactModel {
  const factory RandomFactModel({
    required String id,
    required String text,
    required String source,
    @JsonKey(name: 'source_url') required String sourceUrl,
    required String language,
    required String permalink,
  }) = _RandomFactModel;

  // Pure JSON (de)serialization used by code generation
  factory RandomFactModel.fromJson(Map<String, dynamic> json) =>
      _$RandomFactModelFromJson(json);

  /// Use this when parsing raw API payloads that may have inconsistent keys.
  factory RandomFactModel.fromApi(Map<String, dynamic> json) {
    try {
      final data = Map<String, dynamic>.from(json);

      final dynamic textCandidate = data['text'] ?? data['fact'];
      if (textCandidate is! String || textCandidate.trim().isEmpty) {
        throw const EmptyResponseFailure(message: 'Missing fact text');
      }

      data['text'] = textCandidate;
      data['source_url'] =
          data['source_url'] ?? data['sourceUrl'] ?? data['sourceURL'] ?? '';
      data['id'] = data['id'] ?? data['_id'] ?? '';
      data['language'] = data['language'] ?? 'en';
      data['permalink'] = data['permalink'] ?? '';

      return RandomFactModel.fromJson(data);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ParsingFailure(message: 'Invalid random fact payload', cause: e);
    }
  }

  factory RandomFactModel.fromDomain(RandomFact fact) => RandomFactModel(
    id: fact.id,
    text: fact.text,
    source: fact.source,
    sourceUrl: fact.sourceUrl,
    language: fact.language,
    permalink: fact.permalink,
  );
}

extension RandomFactModelX on RandomFactModel {
  RandomFact toDomain() => RandomFact(
    id: id,
    text: text,
    source: source,
    sourceUrl: sourceUrl,
    language: language,
    permalink: permalink,
  );
}
