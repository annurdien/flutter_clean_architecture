import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entity/error/failures.dart';
import '../../domain/entities/{{feature_name}}.dart';
import '../../domain/usecases/get_{{feature_name}}.dart';

part '{{feature_name}}_event.dart';
part '{{feature_name}}_state.dart';
part '{{feature_name}}_bloc.freezed.dart';

class {{feature_name.pascalCase()}}Bloc extends Bloc<{{feature_name.pascalCase()}}Event, {{feature_name.pascalCase()}}State> {
  {{feature_name.pascalCase()}}Bloc(this._useCase) : super(const {{feature_name.pascalCase()}}State()) {
    on<{{feature_name.pascalCase()}}Event>(_onEvent);
  }

  final Get{{feature_name.pascalCase()}}UseCase _useCase;

  Future<void> _onEvent(
    {{feature_name.pascalCase()}}Event event,
    Emitter<{{feature_name.pascalCase()}}State> emit,
  ) async {
    await event.map(
      started: (_) => _load(emit),
      refreshed: (_) => _load(emit, isRefresh: true),
    );
  }

  Future<void> _load(
    Emitter<{{feature_name.pascalCase()}}State> emit, {bool isRefresh = false}) async {
    final busy = isRefresh ? state.isRefreshing : state.isLoading;
    if (busy) return;

    emit(
      state.copyWith(
        isLoading: isRefresh ? state.isLoading : true,
        isRefreshing: isRefresh ? true : state.isRefreshing,
        failure: null,
      ),
    );

    final result = await _useCase();

    result.fold(
      (f) => emit(
        state.copyWith(
          isLoading: isRefresh ? state.isLoading : false,
          isRefreshing: isRefresh ? false : state.isRefreshing,
          failure: f,
        ),
      ),
      (entity) => emit(
        state.copyWith(
          isLoading: isRefresh ? state.isLoading : false,
          isRefreshing: isRefresh ? false : state.isRefreshing,
          entity: entity,
        ),
      ),
    );
  }
}
