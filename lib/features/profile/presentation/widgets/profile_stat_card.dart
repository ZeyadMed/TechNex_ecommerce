import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: context.responsiveValue(mobile: 14.0, smallMobile: 10.0, tablet: 18.0),
      ),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF21283B) : const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyles.blackBold20.copyWith(
              fontSize: context.responsiveValue(mobile: 25.0, smallMobile: 18.0, tablet: 32.0),
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: TextStyles.blackRegular14.copyWith(
              color: dark ? Colors.white70 : const Color(0xFF4A5568),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
