import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrackOrderItemsCard extends StatelessWidget {
  final List<TrackOrderItem> items;

  const TrackOrderItemsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: 0.16) : const Color(0x100F172A),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orderItems'.tr(),
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          for (int index = 0; index < items.length; index++) ...[
            _OrderItemRow(item: items[index]),
            if (index != items.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final TrackOrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: dark ? const Color(0xFF2C3550) : const Color(0xFFF1F4FA),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(item.imageAsset, fit: BoxFit.cover),
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
                      item.title,
                      style: TextStyles.blackBold16.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.price,
                    style: TextStyles.blackBold16.copyWith(
                      color: dark ? Colors.white : const Color(0xFF111827),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.quantity,
                style: TextStyles.blackRegular14.copyWith(
                  color: dark ? Colors.white60 : const Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
