import 'package:fliplearnai/bootstrap.dart';
import 'package:fliplearnai/core/config/environment.dart';

void main() {
  bootstrap(
    Environment(
      type: EnvironmentType.staging,
      name: 'Staging',
      apiBaseUrl: 'https://api.stg.fliplearnai.com', // Example
    ),
  );
}
