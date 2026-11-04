import 'package:flutter_test/flutter_test.dart';

// Flutter's default test binding removes blur from BoxShadow. Keep it enabled
// in card goldens so they verify the soft shadow users actually see.
class SoftShadowTestBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get disableShadows => false;
}
