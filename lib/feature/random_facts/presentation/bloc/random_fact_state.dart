part of 'random_fact_bloc.dart';

@freezed
abstract class RandomFactState with _$RandomFactState {
  const factory RandomFactState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    RandomFact? fact,
    Failure? failure,
  }) = _RandomFactState;

  const RandomFactState._();

  bool get hasError => failure != null;
}
