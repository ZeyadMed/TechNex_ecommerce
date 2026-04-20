import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RecentOrderCard extends StatelessWidget {
  final String orderId;
  final int itemCount;
  final String dateText;
  final String amount;
  final bool delivered;
  final IconData icon;

  const RecentOrderCard({
    super.key,
    required this.orderId,
    required this.itemCount,
    required this.dateText,
    required this.amount,
    required this.delivered,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    final statusBg = delivered
        ? const Color(0xFFD8F5E6)
        : const Color(0xFFFFEDCC);
    final statusColor = delivered
        ? const Color(0xFF0E9F6E)
        : const Color(0xFFD18A00);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF21283B) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: dark ? const Color(0xFF2C3550) : const Color(0xFFF1F4FA),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        orderId,
                        style: TextStyles.blackBold16.copyWith(
                          color: dark ? Colors.white : const Color(0xFF1A202C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        delivered ? 'delivered'.tr() : 'processing'.tr(),
                        style: TextStyles.blackRegular12.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$itemCount ${'items'.tr()}',
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      dateText,
                      style: TextStyles.blackRegular14.copyWith(
                        color: dark ? Colors.white60 : const Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      amount,
                      style: TextStyles.blackBold20.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
