enum Flavor { development, production }

class FlavorConfig {
  final Flavor flavor;
  final String appTitle;
  final String hiveBoxSuffix;

  const FlavorConfig._({
    required this.flavor,
    required this.appTitle,
    required this.hiveBoxSuffix,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance ??= const FlavorConfig._(
      flavor: Flavor.development,
      appTitle: 'Saku (Dev)',
      hiveBoxSuffix: '_dev',
    );
  }

  static void initialize(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        _instance = const FlavorConfig._(
          flavor: Flavor.development,
          appTitle: 'Saku (Dev)',
          hiveBoxSuffix: '_dev',
        );
        break;
      case Flavor.production:
        _instance = const FlavorConfig._(
          flavor: Flavor.production,
          appTitle: 'Saku',
          hiveBoxSuffix: '',
        );
        break;
    }
  }

  bool get isProduction => flavor == Flavor.production;
  bool get isDevelopment => flavor == Flavor.development;
}
