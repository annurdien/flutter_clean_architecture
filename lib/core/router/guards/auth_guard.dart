import 'package:auto_route/auto_route.dart';

/// Example route guard for authentication
/// This is an example implementation that you can extend based on your app's needs
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // For this example app, we'll always allow navigation
    // In a real app, you would check authentication status here

    // Example implementation:
    // if (isAuthenticated) {
    //   resolver.next();
    // } else {
    //   router.push(const LoginRoute());
    // }

    // For now, always allow navigation
    resolver.next();
  }
}
