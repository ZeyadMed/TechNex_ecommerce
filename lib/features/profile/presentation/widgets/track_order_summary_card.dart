import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:e_commerce/features/profile/presentation/widgets/order_status_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrackOrderSummaryCard extends StatelessWidget {
  final TrackOrderArgs args;

  const TrackOrderSummaryCard({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A54F7), Color(0xFF2E63F6)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E63F6).withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'orderId'.tr(),
                      style: TextStyles.blackRegular14.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const OrderStatusChip(status: OrderStatus.inTransit),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  args.orderId,
                  style: TextStyles.blackBold32.copyWith(
                    color: Colors.white,
                    fontSize: context.responsiveValue(mobile: 26.0, smallMobile: 22.0, tablet: 32.0),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _InfoBlock(
                        label: 'estimatedDelivery'.tr(),
                        value: args.estimatedDeliveryValue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoBlock(
                        label: 'totalAmount'.tr(),
                        value: args.amount,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              args.imageAsset,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.blackRegular12.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.blackBold20.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: context.responsiveValue(mobile: 16.0, smallMobile: 15.0, tablet: 20.0),
          ),
        ),
      ],
    );
  }
}
