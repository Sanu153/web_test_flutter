import 'package:syncfusion_flutter_core/core.dart';

class Syncfusion {
  static final String _key =
      "NT8mJyc2IWhia31hfWN9Z2doYmF8YGJ8ampqanNiYmlmamlmanMDHmg9PCU9NjYnYGdlOjonOxM0PjI6P30wPD4=";

  static void init() {
    SyncfusionLicense.registerLicense(_key);
  }
}
