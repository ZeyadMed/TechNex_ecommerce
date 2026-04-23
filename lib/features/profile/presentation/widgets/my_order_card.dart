import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/profile/presentation/widgets/order_status_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyOrderCard extends StatelessWidget {
  final String orderId;
  final int itemCount;
  final String dateText;
  final String amount;
  final String imageAsset;
  final OrderStatus status;
  final VoidCallback onTrackTap;

  const MyOrderCard({
    super.key,
    required this.orderId,
    required this.itemCount,
    required this.dateText,
    required this.amount,
    required this.imageAsset,
    required this.status,
    required this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF21283B) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: 0.14) : const Color(0x120F172A),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: dark ? const Color(0xFF2C3550) : const Color(0xFFF1F4FA),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
            ),
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
                    OrderStatusChip(status: status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount ${'items'.tr()} · $dateText',
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      amount,
                      style: TextStyles.blackBold20.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: onTrackTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF3B46F6),
                        side: const BorderSide(color: Color(0xFF3B46F6), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      child: Text(
                        'trackOrder'.tr(),
                        style: TextStyles.blackBold14.copyWith(
                          color: const Color(0xFF3B46F6),
                          fontWeight: FontWeight.w700,
                        ),
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