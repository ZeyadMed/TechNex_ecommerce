import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final categories = <HomeCategoryData>[
      const HomeCategoryData(titleKey: 'electronics', icon: Icons.headphones_rounded),
      const HomeCategoryData(titleKey: 'fashion', icon: Icons.checkroom_rounded),
      const HomeCategoryData(titleKey: 'watches', icon: Icons.watch_rounded),
      const HomeCategoryData(titleKey: 'bags', icon: Icons.backpack_rounded),
      const HomeCategoryData(titleKey: 'accessories', icon: Icons.diamond_outlined),
      const HomeCategoryData(titleKey: 'sports', icon: Icons.sports_soccer_rounded),
      const HomeCategoryData(titleKey: 'phones', icon: Icons.smartphone_rounded),
      const HomeCategoryData(titleKey: 'gaming', icon: Icons.sports_esports_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'categories'.tr(),
          style: TextStyles.blackBold20.copyWith(
            color: dark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 14.0)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < (categories.length / 2).ceil(); index++)
                  Padding(
                    padding: EdgeInsets.only(
                      right: index == (categories.length / 2).ceil() - 0
                          ? 0
                          : context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 14.0),
                    ),
                    child: Builder(
                      builder: (context) {
                        final first = categories[index * 2];
                        final secondIndex = index * 2 + 1;
                        final second = secondIndex < categories.length ? categories[secondIndex] : null;
                        final double tileWidth = context.responsiveValue<double>(
                          mobile: context.screenWidth * 0.20,
                          smallMobile: context.screenWidth * 0.33,
                          tablet: context.screenWidth * 0.18,
                        );

                        return Container(
                          width: tileWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HomeCategoryCard(data: first),
                              if (second != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: context.responsiveValue(mobile: 8.0, smallMobile: 6.0, tablet: 10.0),
                                  ),
                                  child: HomeCategoryCard(data: second),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeCategoryCard extends StatelessWidget {
  final HomeCategoryData data;

  const HomeCategoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final double iconSize = context.responsiveValue(mobile: 24.0, smallMobile: 20.0, tablet: 26.0);
    final double innerPadding = context.responsiveValue(mobile: 10.0, smallMobile: 8.0, tablet: 12.0);
    final double textSpacing = context.responsiveValue(mobile: 6.0, smallMobile: 4.0, tablet: 8.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: innerPadding, vertical: innerPadding),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: 0.14) : const Color(0x0F0F172A),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: iconSize * 2,
            width: iconSize * 2,
            decoration: BoxDecoration(
              color: const Color(0xFFDEE7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              data.icon,
              size: iconSize,
              color: const Color(0xFF3B46F6),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: textSpacing),
            child: Text(
              data.titleKey.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.blackRegular14.copyWith(
                fontSize: context.responsiveValue(mobile: 11.5, smallMobile: 11.0, tablet: 13.0),
                color: dark ? Colors.white : const Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCategoryData {
  final String titleKey;
  final IconData icon;

  const HomeCategoryData({required this.titleKey, required this.icon});
}
