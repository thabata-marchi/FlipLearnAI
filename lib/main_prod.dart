import 'package:fliplearnai/bootstrap.dart';
import 'package:fliplearnai/core/config/environment.dart';

void main() {
  bootstrap(
    Environment(
      type: EnvironmentType.prod,
      name: 'Production',
      apiBaseUrl: 'https://api.fliplearnai.com', // Example
    ),
  );
}
