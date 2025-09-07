import 'package:auto_route/auto_route.dart';

import '../../feature/random_facts/presentation/widgets/random_fact_details_page.dart';
import '../../feature/random_facts/presentation/widgets/random_fact_page.dart';
import '../../feature/settings/presentation/widgets/settings_page.dart';
import 'pages/unknown_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // Home route (Random Facts)
    AutoRoute(page: RandomFactRoute.page, path: '/', initial: true),

    // Random Fact Details route
    AutoRoute(page: RandomFactDetailsRoute.page, path: '/fact-details'),

    // Settings route
    AutoRoute(page: SettingsRoute.page, path: '/settings'),

    // Wildcard route for unknown paths
    AutoRoute(path: '*', page: UnknownRoute.page),
  ];
}
