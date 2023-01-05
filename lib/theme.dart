import 'package:flutter/material.dart';

class TTBTheme {
  static String name = "Tame the Beast";

  static Color secondary = const Color.fromRGBO(7, 59, 76, 1);
  static Color primaryColor = const Color.fromRGBO(17, 138, 178, 1);

  static MaterialColor primary = MaterialColor(primaryColor.value, {
    50: primaryColor.withOpacity(0.1),
    100: primaryColor.withOpacity(0.2),
    200: primaryColor.withOpacity(0.3),
    300: primaryColor.withOpacity(0.4),
    400: primaryColor.withOpacity(0.5),
    500: primaryColor.withOpacity(0.6),
    600: primaryColor.withOpacity(0.7),
    700: primaryColor.withOpacity(0.8),
    800: primaryColor.withOpacity(0.9),
    900: primaryColor.withOpacity(1),
  });

  static TextTheme textTheme = Typography.blackCupertino;

  static Color background = const Color.fromRGBO(53, 56, 57, 1);
  static Color transparentWhite = Colors.white.withOpacity(0.5);

  static Color frequentTaskColor = const Color.fromRGBO(6, 214, 160, 1);
  static Color singleTaskColor = const Color.fromRGBO(255, 209, 102, 1);
  static Color bonusTaskColor = const Color.fromRGBO(239, 71, 111, 1);
}
