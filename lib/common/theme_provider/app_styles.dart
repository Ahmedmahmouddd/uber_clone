import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

abstract class AppStyles {
  static TextStyle styleBold24(bool darkTheme) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: DarkColors.primary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle styleSemiBold16(bool darkTheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
    );
  }

   static TextStyle styleSnackbar() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: LightColors.background,
    );
  }

  static TextStyle styleError12Red() {
    return TextStyle(
      color: Colors.red,
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle style18Bold(bool darkTheme) {
    return TextStyle(
      fontSize: 18,
      color: darkTheme ? DarkColors.textPrimary : LightColors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleBold16(bool darkTheme) {
    return TextStyle(
        color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        fontSize: 16);
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
