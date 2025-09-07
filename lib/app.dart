import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/config/app_config_provider.dart';
import 'core/network/network_service.dart';
import 'core/router/app_router.dart';
import 'core/router/transformers/deeplink_transformer.dart';
import 'core/widgets/alice_overlay_button.dart';
import 'flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.instance<AppRouter>();

    return MaterialApp.router(
      routerConfig: appRouter.config(
        deepLinkBuilder: AppDeepLinkTransformer.handleDeepLink,
      ),
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => _flavorBanner(
        child: _withAliceOverlay(child ?? const SizedBox.shrink()),
      ),
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
          child: child,
        )
      : Container(child: child);

  Widget _withAliceOverlay(Widget child) {
    if (!kDebugMode || !AppConfigProvider.instance.showNetworkInterceptors) {
      return child;
    }

    return MaterialApp(
      navigatorKey: NetworkService.instance.alice.getNavigatorKey(),
      home: Stack(children: [child, const AliceOverlayButton()]),
    );
  }
}
