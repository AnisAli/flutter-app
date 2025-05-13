enum FlavorType {
  development,
  production,
}

class Flavor {
  Flavor._();

  static FlavorType get environment {
    const flavor = String.fromEnvironment('FLAVOR');
    if (flavor == 'dev') {
      return FlavorType.development;
    } else if (flavor == 'prod') {
      return FlavorType.production;
    }
    return FlavorType.development;
  }
}
