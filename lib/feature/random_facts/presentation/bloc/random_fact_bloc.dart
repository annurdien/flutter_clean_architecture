import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/random_fact.dart';
import '../../domain/usecases/get_random_fact.dart';

part 'random_fact_event.dart';
part 'random_fact_state.dart';
part 'random_fact_bloc.freezed.dart';

class RandomFactBloc extends Bloc<RandomFactEvent, RandomFactState> {
  RandomFactBloc(this._useCase) : super(const RandomFactState()) {
    on<RandomFactEvent>(_onEvent);
  }

  final GetRandomFactUseCase _useCase;

  Future<void> _onEvent(
    RandomFactEvent event,
    Emitter<RandomFactState> emit,
  ) async {
    await event.map(
      started: (e) => _load(emit, isRefresh: false, language: e.language),
      refreshed: (e) => _load(emit, isRefresh: true, language: e.language),
    );
  }

  Future<void> _load(
    Emitter<RandomFactState> emit, {
    required bool isRefresh,
    required String? language,
  }) async {
    final busy = isRefresh ? state.isRefreshing : state.isLoading;
    if (busy) return;

    emit(
      state.copyWith(
        isLoading: isRefresh ? state.isLoading : true,
        isRefreshing: isRefresh ? true : state.isRefreshing,
        failure: null,
      ),
    );

    final result = await _useCase(language: language ?? 'en');

    result.fold(
      (f) => emit(
        state.copyWith(
          isLoading: isRefresh ? state.isLoading : false,
          isRefreshing: isRefresh ? false : state.isRefreshing,
          failure: f,
        ),
      ),
      (fact) => emit(
        state.copyWith(
          isLoading: isRefresh ? state.isLoading : false,
          isRefreshing: isRefresh ? false : state.isRefreshing,
          fact: fact,
        ),
      ),
    );
  }
}
