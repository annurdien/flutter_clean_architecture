import 'dart:async';

import 'package:auto_route/auto_route.dart';

/// Custom deep link transformer that can modify incoming deep links
class AppDeepLinkTransformer {
  /// Transform deep links before they are processed by the router
  static FutureOr<Uri> transform(Uri uri) {
    var path = uri.path;
    final query = uri.queryParameters;

    // Handle custom URL schemes or modify paths as needed
    // Example: Transform legacy URLs to new format
    if (path.startsWith('/app/')) {
      path = path.replaceFirst('/app/', '/');
    }

    // Example: Handle query parameters for navigation
    if (query.containsKey('page')) {
      switch (query['page']) {
        case 'home':
          path = '/';
        case 'settings':
          path = '/settings';
      }
    }

    // Return the potentially modified URI
    return uri.replace(
      path: path,
      queryParameters: query.isNotEmpty ? query : null,
    );
  }

  /// Handle deep link validation and redirection
  static DeepLink handleDeepLink(PlatformDeepLink deepLink) {
    final path = deepLink.uri.path;

    // Allow all known paths
    if (_isKnownPath(path)) {
      return deepLink;
    }

    // Redirect unknown paths to home
    return DeepLink.defaultPath;
  }

  static bool _isKnownPath(String path) {
    final knownPaths = ['/', '/settings'];
    return knownPaths.any(
      (knownPath) => path == knownPath || path.startsWith('$knownPath/'),
    );
  }
}
