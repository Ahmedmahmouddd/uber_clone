import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

abstract class AppStyles {
  static TextStyle pageHeader25(bool darkTheme) {
    return TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: darkTheme ? DarkColors.primary : LightColors.background,
    );
  }

  static TextStyle styleSemiBold16(bool darkTheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: darkTheme ? DarkColors.accent : LightColors.accent,
    );
  }
}

// // sacleFactor
// // responsive font size
// // (min , max) fontsize
// double getResponsiveFontSize(context, {required double fontSize}) {
//   double scaleFactor = getScaleFactor(context);
//   double responsiveFontSize = fontSize * scaleFactor;

//   double lowerLimit = fontSize * .8;
//   double upperLimit = fontSize * 1.2;

//   return responsiveFontSize.clamp(lowerLimit, upperLimit);
// }

// double getScaleFactor(context) {
//   // var dispatcher = PlatformDispatcher.instance;
//   // var physicalWidth = dispatcher.views.first.physicalSize.width;
//   // var devicePixelRatio = dispatcher.views.first.devicePixelRatio;
//   // double width = physicalWidth / devicePixelRatio;

//   double width = MediaQuery.sizeOf(context).width;
//   if (width < SizeConfig.tablet) {
//     return width / 550;
//   } else if (width < SizeConfig.desktop) {
//     return width / 1000;
//   } else {
//     return width / 1920;
//   }
// }
