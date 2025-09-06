import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/network/network_service.dart';
import 'feature/random_facts/presentation/widgets/random_fact_page.dart';
import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = NetworkService.instance.aliceNavigatorKey;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _flavorBanner(child: const RandomFactPage()),
      builder: (context, child) => AliceDebugOverlay(child: child),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        )
      : Container(child: child);
}

class AliceDebugOverlay extends StatelessWidget {
  final Widget? child;
  const AliceDebugOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || child == null) return child ?? const SizedBox.shrink();
    return Stack(
      children: [
        child!,
        Positioned(
          left: 16,
          bottom: 16,
          child: SafeArea(
            child: FloatingActionButton(
              heroTag: 'alice_fab',
              mini: true,
              onPressed: () {
                try {
                  NetworkService.instance.alice.showInspector();
                } catch (_) {}
              },
              child: const Icon(Icons.network_check),
            ),
          ),
        ),
      ],
    );
  }
}
