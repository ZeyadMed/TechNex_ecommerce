import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrackOrderAddressCard extends StatelessWidget {
  final String line1;
  final String line2;
  final String phone;

  const TrackOrderAddressCard({
    super.key,
    required this.line1,
    required this.line2,
    required this.phone,
  });

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
            'deliveryAddress'.tr(),
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF3B46F6),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line1,
                      style: TextStyles.blackBold16.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      line2,
                      style: TextStyles.blackRegular14.copyWith(
                        color: dark ? Colors.white70 : const Color(0xFF475467),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phone,
                      style: TextStyles.blackRegular14.copyWith(
                        color: dark ? Colors.white70 : const Color(0xFF475467),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
