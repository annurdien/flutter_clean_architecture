import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/entity/error/failure_message_mapper.dart';
import '../bloc/random_fact_bloc.dart';

class RandomFactPage extends StatelessWidget {
  const RandomFactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RandomFactBloc(GetIt.instance())
            ..add(const RandomFactEvent.started()),
      child: BlocBuilder<RandomFactBloc, RandomFactState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Random Fact')),
            body: RefreshIndicator(
              onRefresh: () async => context.read<RandomFactBloc>().add(
                const RandomFactEvent.refreshed(),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.isLoading || state.isRefreshing) ...[
                    const Center(child: CircularProgressIndicator()),
                  ],
                  if (state.fact != null &&
                      !state.isLoading &&
                      !state.isRefreshing) ...[
                    Text(
                      state.fact!.text,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text('Source: ${state.fact!.source}'),
                    Text('Language: ${state.fact!.language}'),
                  ],
                  if (state.hasError) _ErrorSection(state: state),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () => context.read<RandomFactBloc>().add(
                            const RandomFactEvent.started(),
                          ),
                    icon: const Icon(Icons.casino),
                    label: const Text('New Fact'),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<RandomFactBloc>().add(
                const RandomFactEvent.refreshed(),
              ),
              child: const Icon(Icons.refresh),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({required this.state});

  final RandomFactState state;

  @override
  Widget build(BuildContext context) {
    final message = mapFailureToMessage(state.failure!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        if (state.failure?.message != null)
          Text(
            state.failure!.message!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}
