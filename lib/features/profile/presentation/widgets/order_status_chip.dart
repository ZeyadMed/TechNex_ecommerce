import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum OrderStatus { delivered, processing, shipped, inTransit }

class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color backgroundColor, Color textColor, String text) = switch (status) {
      OrderStatus.delivered => (
          const Color(0xFFD8F5E6),
          const Color(0xFF0E9F6E),
          'delivered'.tr(),
        ),
      OrderStatus.processing => (
          const Color(0xFFFFEDCC),
          const Color(0xFFD18A00),
          'processing'.tr(),
        ),
      OrderStatus.shipped => (
          const Color(0xFFDCE8FF),
          const Color(0xFF246BFD),
          'shipped'.tr(),
        ),
      OrderStatus.inTransit => (
          const Color(0xFFDCE8FF),
          const Color(0xFF3B46F6),
          'inTransit'.tr(),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyles.blackRegular12.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}