import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:ui' as ui;
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class CustomPhoneField extends StatelessWidget {
  final void Function(PhoneNumber)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomPhoneField({
    super.key,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color fieldFillColor = dark ? const Color(0xFF21283B) : Colors.white;
    final Color hintColor = dark ? Colors.white54 : Colors.grey;
    final Color enabledBorderColor =
        dark ? Colors.white12 : Colors.grey.shade300;
    final Color textColor = dark ? Colors.white : AppColors.darkTextColor;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: IntlPhoneField(
        controller: controller,
        initialCountryCode: 'EG',
        style: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
        dropdownTextStyle: TextStyle(
          fontSize: 18,
          color: textColor,
        ),
        dropdownDecoration: BoxDecoration(),
        disableLengthCheck: false,
        disableAutoFillHints: false,
        keyboardType: TextInputType.phone,
        languageCode: 'ar',
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: dark ? const Color(0xFF111827) : Colors.white,
          countryNameStyle: TextStyles.blackBold16.copyWith(
            color: dark ? Colors.white : AppColors.darkTextColor,
          ),
          countryCodeStyle: TextStyles.blackBold14.copyWith(
            color: dark ? Colors.white70 : AppColors.darkTextColor,
          ),
          searchFieldInputDecoration: InputDecoration(
            hintText: 'search'.tr(),
            hintStyle: TextStyles.greyColor2Regular14.copyWith(
              color: hintColor,
            ),
            filled: true,
            fillColor: fieldFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: enabledBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: enabledBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
          ),
          searchFieldPadding: EdgeInsets.all(5),
        ),
        invalidNumberMessage: "invalidPhoneNumber".tr(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          hintText: "XXXXXXXXXXX",
          fillColor: fieldFillColor,
          filled: true,
          hintStyle: TextStyles.greyColor2Regular14.copyWith(
            color: hintColor,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: enabledBorderColor,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: enabledBorderColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 0.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 1.0,
            ),
          ),
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
