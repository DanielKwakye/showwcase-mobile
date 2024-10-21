enum Flavor {
  beta
}


class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? 'Showwcase';

  static String get title {
    switch (appFlavor) {
      case Flavor.beta:
        return  'Beta';
      default:
        return 'Showwcase';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.beta:
        return 'https://beta-cache.showwcase.com';
      default:
        return 'https://cache.showwcase.com';
    }
  }

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.beta:
        return "https://beta-api.showwcase.com";
      default:
        return 'https://api.showwcase.com';
    }
  }

}
