import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_fact.freezed.dart';
part 'random_fact.g.dart';

/// Domain entity representing a random fact fetched from the API.
@freezed
abstract class RandomFact with _$RandomFact {
  const factory RandomFact({
    required String id,
    required String text,
    required String source,
    required String sourceUrl,
    required String language,
    required String permalink,
  }) = _RandomFact;

  factory RandomFact.fromJson(Map<String, dynamic> json) =>
      _$RandomFactFromJson(json);
}
