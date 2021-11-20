import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/services/is_phone_or_tablet.service.dart';
import 'package:flutter/material.dart';

/// This class is used to determine the theme. There is one theme used for mobile device, another for tablet device.
class AppThemeData {
  /// This method return the correct theme depending on the device [deviceType].
  static ThemeData getTheme(DeviceType deviceType) {

    if (deviceType == DeviceType.tablet) {
      return ThemeData(
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(
                size: 32.0,
                color: Colors.white
            ),
            actionsIconTheme: IconThemeData(
                size: 32.0,
                color: Colors.white
            ),
          ),
          iconTheme: const IconThemeData(
              size: 32.0,
              color: Colors.black
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            filled: true,
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 40.0,
              letterSpacing: -0.5,
              fontWeight: FontWeight.w400,
            ),
            headline2: TextStyle(
              fontSize: 36.0,
              letterSpacing: -0.25,
              fontWeight: FontWeight.w400,
            ),
            headline3: TextStyle(
              fontSize: 32.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
            bodyText1: TextStyle(
              fontSize: 24.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
            bodyText2: TextStyle(
              fontSize: 20.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
            button: TextStyle(
              fontSize: 18.0,
              letterSpacing: 0.75,
              fontWeight: FontWeight.w700,
            ),
          )
      );
    } else {
      return ThemeData(
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(
                size: 24.0,
                color: Colors.white
            ),
            actionsIconTheme: IconThemeData(
                size: 24.0,
                color: Colors.white
            ),
          ),
          iconTheme: const IconThemeData(
              size: 24.0,
              color: Colors.black
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            filled: true,
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 24.0,
              letterSpacing: -0.25,
              fontWeight: FontWeight.w400,
            ),
            headline2: TextStyle(
              fontSize: 20.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
            headline3: TextStyle(
              fontSize: 18.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
            bodyText1: TextStyle(
              fontSize: 16.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
            bodyText2: TextStyle(
              fontSize: 14.0,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
            button: TextStyle(
              fontSize: 14.0,
              letterSpacing: 0.75,
              fontWeight: FontWeight.w700,
            ),
          )
      );
    }
  }
}