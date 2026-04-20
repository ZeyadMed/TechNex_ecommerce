import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddressCardTile extends StatelessWidget {
  final String label;
  final String address;
  final String phone;
  final bool isDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCardTile({
    super.key,
    required this.label,
    required this.address,
    required this.phone,
    required this.isDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

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
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dark ? const Color(0xFF2C3550) : const Color(0xFFEEF2FF),
            ),
            child: Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.blackBold20.copyWith(
                    fontSize: context.responsiveValue(mobile: 20.0, smallMobile: 18.0, tablet: 22.0),
                    color: dark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isDefault) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'defaultAddress'.tr(),
                      style: TextStyles.blackRegular12.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  address,
                  style: TextStyles.blackRegular16.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF475467),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyles.blackRegular16.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF475467),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Text(
                        'edit'.tr(),
                        style: TextStyles.blackRegular16.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28),
                    GestureDetector(
                      onTap: onDelete,
                      child: Text(
                        'delete'.tr(),
                        style: TextStyles.blackRegular16.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
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
