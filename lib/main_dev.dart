import 'package:fliplearnai/bootstrap.dart';
import 'package:fliplearnai/core/config/environment.dart';

void main() {
  bootstrap(
    Environment(
      type: EnvironmentType.dev,
      name: 'Development',
      apiBaseUrl: 'https://api.dev.fliplearnai.com', // Example
    ),
  );
}
