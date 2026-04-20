import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badgeText;
  final VoidCallback? onTap;
  final bool showDivider;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.badgeText,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dark ? const Color(0xFF2C3550) : const Color(0xFFEEF2FF),
                    ),
                    child: Icon(icon, color: AppColors.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyles.blackBold16.copyWith(
                        color: dark ? Colors.white : const Color(0xFF1A202C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (badgeText != null)
                    Container(
                      height: 28,
                      width: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dark ? const Color.fromARGB(255, 179, 181, 190) : const Color(0xFFE5E8FB),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyles.blackRegular12.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: dark ? Colors.white54 : const Color(0xFF98A2B3),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: dark ? Colors.white12 : const Color(0xFFE8ECF3),
          ),
      ],
    );
  }
}
