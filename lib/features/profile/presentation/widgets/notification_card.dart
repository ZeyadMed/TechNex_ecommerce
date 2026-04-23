import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationCard extends StatelessWidget {
  final bool dark;
  final Color surfaceColor;
  final Color mutedSurfaceColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color accentColor;
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.dark,
    required this.surfaceColor,
    required this.mutedSurfaceColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = context.responsiveValue(mobile: 48.0, smallMobile: 44.0, tablet: 52.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: unread
                  ? accentColor.withValues(alpha: dark ? 0.6 : 0.25)
                  : (dark ? Colors.white10 : const Color(0xFFF1F5F9)),
            ),
            boxShadow: [
              BoxShadow(
                color: dark ? Colors.black.withValues(alpha: 0.18) : const Color(0x1A0F172A),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 112,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(
                    context.responsiveValue(mobile: 14.0, smallMobile: 12.0, tablet: 16.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: mutedSurfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: context.responsiveValue(mobile: 22.0, smallMobile: 20.0, tablet: 24.0),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyles.blackBold16.copyWith(
                                      color: primaryTextColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  time,
                                  style: TextStyles.blackRegular12.copyWith(
                                    color: secondaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(8),
                                if (unread)
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const Gap(6),
                            Text(
                              body,
                              style: TextStyles.blackRegular14.copyWith(
                                color: secondaryTextColor,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}