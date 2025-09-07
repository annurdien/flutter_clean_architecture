import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RandomFactDetailsPage extends StatelessWidget {
  const RandomFactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get query parameters from the route
    final routeData = RouteData.of(context);
    final factText =
        routeData.queryParams.optString('factText') ?? 'No fact available';
    final source =
        routeData.queryParams.optString('source') ?? 'Unknown source';
    final language =
        routeData.queryParams.optString('language') ?? 'Unknown language';

    return Scaffold(
      appBar: AppBar(title: const Text('Fact Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Random Fact',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      factText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.source, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Source: $source')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.language, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Language: $language')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.router.maybePop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Random Facts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
