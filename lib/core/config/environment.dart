enum EnvironmentType { dev, staging, prod }

class Environment {
  final EnvironmentType type;
  final String name;
  final String apiBaseUrl;

  Environment({
    required this.type,
    required this.name,
    required this.apiBaseUrl,
  });

  bool get isDev => type == EnvironmentType.dev;
  bool get isStaging => type == EnvironmentType.staging;
  bool get isProd => type == EnvironmentType.prod;
}
