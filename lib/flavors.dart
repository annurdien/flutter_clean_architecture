enum Flavor {
  dev,
  staging,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Flutter Clean Architecture Dev';
      case Flavor.staging:
        return 'Flutter Clean Architecture Staging';
      case Flavor.prod:
        return 'Flutter Clean Architecture Prod';
    }
  }

}
