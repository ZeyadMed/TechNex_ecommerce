import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeSectionFilterDrawer extends StatelessWidget {
  final String selectedSortKey;
  final ValueChanged<String> onSortChanged;
  final RangeValues priceRange;
  final RangeValues minMaxPrice;
  final ValueChanged<RangeValues> onPriceChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;

  const HomeSectionFilterDrawer({
    super.key,
    required this.selectedSortKey,
    required this.onSortChanged,
    required this.priceRange,
    required this.minMaxPrice,
    required this.onPriceChanged,
    required this.onReset,
    required this.onApply,
  });

  static const String sortFeatured = 'featured';
  static const String sortPriceLowToHigh = 'priceLowToHigh';
  static const String sortPriceHighToLow = 'priceHighToLow';
  static const String sortHighestRating = 'highestRating';
  static const String sortLowestRating = 'lowestRating';

  static const List<_SortOption> _sortOptions = [
    _SortOption(key: sortFeatured, titleKey: 'featured'),
    _SortOption(key: sortPriceLowToHigh, titleKey: 'sortPriceLowToHigh'),
    _SortOption(key: sortPriceHighToLow, titleKey: 'sortPriceHighToLow'),
    _SortOption(key: sortHighestRating, titleKey: 'sortHighestRating'),
    _SortOption(key: sortLowestRating, titleKey: 'sortLowestRating'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color bg = dark ? const Color(0xFF111827) : AppColors.whiteColor;
    final Color titleColor = dark ? Colors.white : const Color(0xFF111827);
    final Color bodyColor = dark ? const Color(0xFFA8B2C5) : const Color(0xFF475467);
    final Color dividerColor = dark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Drawer(
      width: context.responsiveValue<double>(
        mobile: context.screenWidth * 0.86,
        smallMobile: context.screenWidth * 0.9,
        tablet: 420,
      ),
      backgroundColor: bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(26)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'filters'.tr(),
                      style: TextStyles.blackBold20.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.close_rounded, color: titleColor, size: 26),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                children: [
                  Text(
                    'sortBy'.tr(),
                    style: TextStyles.blackBold16.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SortDropdown(
                    selectedKey: selectedSortKey,
                    options: _sortOptions,
                    onChanged: onSortChanged,
                    dark: dark,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'priceRange'.tr(),
                    style: TextStyles.blackBold16.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RangeSlider(
                    values: priceRange,
                    min: minMaxPrice.start,
                    max: minMaxPrice.end,
                    divisions: (minMaxPrice.end - minMaxPrice.start).clamp(1, 200).round(),
                    activeColor: AppColors.primaryColor,
                    inactiveColor: dark ? Colors.white12 : const Color(0xFFE5E7EB),
                    labels: RangeLabels(
                      '\$${priceRange.start.round()}',
                      '\$${priceRange.end.round()}',
                    ),
                    onChanged: onPriceChanged,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${priceRange.start.round()}',
                        style: TextStyles.blackRegular16.copyWith(
                          color: bodyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${priceRange.end.round()}',
                        style: TextStyles.blackRegular16.copyWith(
                          color: bodyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReset,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'reset'.tr(),
                        style: TextStyles.blackBold14.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onApply,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        'apply'.tr(),
                        style: TextStyles.whiteBold14.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final String selectedKey;
  final List<_SortOption> options;
  final ValueChanged<String> onChanged;
  final bool dark;

  const _SortDropdown({
    required this.selectedKey,
    required this.options,
    required this.onChanged,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dark ? Colors.white12 : const Color(0xFFD0D5DD)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedKey,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: dark ? Colors.white70 : const Color(0xFF344054),
          ),
          dropdownColor: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
          style: TextStyles.blackRegular16.copyWith(
            color: dark ? Colors.white : const Color(0xFF101828),
            fontWeight: FontWeight.w600,
          ),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.key,
                  child: Text(option.titleKey.tr()),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SortOption {
  final String key;
  final String titleKey;

  const _SortOption({required this.key, required this.titleKey});
}
