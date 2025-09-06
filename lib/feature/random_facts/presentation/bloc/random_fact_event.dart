part of 'random_fact_bloc.dart';

@freezed
abstract class RandomFactEvent with _$RandomFactEvent {
  const factory RandomFactEvent.started({String? language}) = _Started;
  const factory RandomFactEvent.refreshed({String? language}) = _Refreshed;
}
