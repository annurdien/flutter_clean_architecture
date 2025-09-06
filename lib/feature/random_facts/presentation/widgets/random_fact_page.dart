import 'package:easy_localization/easy_localization.dart';
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
            appBar: AppBar(
              title: Text('random_fact.title'.tr()),
              actions: const [_LocaleSwitcherButton()],
            ),
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
                    Text('${'random_fact.source'.tr()}: ${state.fact!.source}'),
                    Text(
                      '${'random_fact.language'.tr()}: ${state.fact!.language}',
                    ),
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
                    label: Text('random_fact.new_fact'.tr()),
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

class _LocaleSwitcherButton extends StatelessWidget {
  const _LocaleSwitcherButton();

  String _displayName(Locale locale) {
    final code = locale.languageCode;
    switch (code) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = context.locale;
    final supported = context.supportedLocales;

    if (supported.length <= 1) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Change language',
      onSelected: (loc) async {
        if (loc != current) {
          await context.setLocale(loc);
        }
      },
      itemBuilder: (ctx) => supported
          .map(
            (l) => PopupMenuItem<Locale>(
              value: l,
              child: Row(
                children: [
                  if (l == current)
                    Icon(
                      Icons.check,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 8),
                  Text(_displayName(l)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
