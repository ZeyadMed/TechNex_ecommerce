import 'package:flutter/material.dart';
import 'package:e_commerce/core/extensions/extensions.dart';

BoxDecoration customBoxDecoration({required BuildContext context}) {
  return BoxDecoration(
    color: context.isDarkMode ? HexColor.darkBackgroundColor : HexColor.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: context.isDarkMode ? HexColor.white : Colors.black,
      width: 0.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 2),
        blurRadius: 4,
      ),
    ],
  );
}
