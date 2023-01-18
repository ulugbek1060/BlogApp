import 'package:flutter/foundation.dart';

extension IfDebuging on String {
  String? get ifDebuging => kDebugMode ? this : null;
}
