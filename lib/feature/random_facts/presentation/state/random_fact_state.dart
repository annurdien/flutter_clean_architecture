import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/random_fact.dart';

part 'random_fact_state.freezed.dart';

@freezed
abstract class RandomFactState with _$RandomFactState {
  const RandomFactState._();

  const factory RandomFactState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    RandomFact? fact,
    Failure? failure,
  }) = _RandomFactState;

  factory RandomFactState.initial() => const RandomFactState();

  bool get hasError => failure != null;
}
