import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/entity/error/failure_message_mapper.dart';
import '../bloc/{{feature_name}}_bloc.dart';

class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => {{feature_name.pascalCase()}}Bloc(GetIt.instance())
        ..add(const {{feature_name.pascalCase()}}Event.started()),
      child: BlocBuilder<{{feature_name.pascalCase()}}Bloc, {{feature_name.pascalCase()}}State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('{{feature_name.titleCase()}}')),
            body: RefreshIndicator(
              onRefresh: () async => context.read<{{feature_name.pascalCase()}}Bloc>().add(
                const {{feature_name.pascalCase()}}Event.refreshed(),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.isLoading || state.isRefreshing) ...[
                    const Center(child: CircularProgressIndicator()),
                  ],
                  if (state.entity != null && !state.isLoading && !state.isRefreshing) ...[
                    Text(
                      state.entity.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                  if (state.hasError) _ErrorSection(state: state),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: state.isLoading
                        ? null
        : () => context.read<{{feature_name.pascalCase()}}Bloc>().add(
          const {{feature_name.pascalCase()}}Event.started(),
                            ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reload'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({required this.state});

  final {{feature_name.pascalCase()}}State state;

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
