import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

class PositionedIcon extends StatelessWidget {
  const PositionedIcon(
      {super.key,
      required this.darkTheme,
      required this.onPressed,
      this.top,
      this.bottom,
      this.right,
      this.left,
      required this.iconData});

  final bool darkTheme;
  final void Function()? onPressed;
  final double? top, bottom, right, left;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      left: left,
      top: top,
      child: FloatingActionButton.small(
        heroTag: null,
        backgroundColor:
            darkTheme ? DarkColors.background.withAlpha(200) : LightColors.background.withAlpha(200),
        onPressed: onPressed, // Dark mode color
        child: Icon(iconData, color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary),
      ),
    );
  }
}
