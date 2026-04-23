import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final bool dark;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.dark,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color headerColor = dark ? const Color(0xFF111827) : Colors.white;
    final Color titleColor = dark ? Colors.white : const Color(0xFF1F2937);
    final Color subtitleColor = dark ? Colors.white70 : const Color(0xFF4B5563);

    return Container(
      width: double.infinity,
      color: headerColor,
      padding: EdgeInsets.fromLTRB(
        context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
        context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 14.0),
        context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
        context.responsiveValue(mobile: 14.0, smallMobile: 12.0, tablet: 16.0),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TechNex',
                style: TextStyles.blackBold20.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Premium Shopping',
                style: TextStyles.blackRegular14.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onNotificationTap,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFFC59A00),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
