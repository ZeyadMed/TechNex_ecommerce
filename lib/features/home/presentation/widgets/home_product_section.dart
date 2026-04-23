import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeProductSection extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final List<HomeProductData> products;

  const HomeProductSection({
    super.key,
    required this.titleKey,
    required this.icon,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFF4B400), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titleKey.tr(),
                style: TextStyles.blackBold16.copyWith(
                  color: dark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.w800,
                  fontSize: context.responsiveValue(mobile: 18.0, smallMobile: 14.0, tablet: 18.0),
                ),
              ),
            ),
            Text(
              'seeAll'.tr(),
              style: TextStyles.blueRegular15.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: context.responsiveValue(mobile: 14.0, smallMobile: 12.0, tablet: 14.0),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(products.length, (index) {
              return Padding(
                padding: EdgeInsets.all(
                  context.responsiveValue(mobile: 10.0, smallMobile: 10.0, tablet: 14.0),
                ),
                child: ProductCard(
                  data: products[index],
                  onFavoriteTap: () {},
                  onTap: () {},
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
