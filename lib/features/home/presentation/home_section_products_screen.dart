import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/home/presentation/widgets/home_section_filter_drawer.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeSectionProductsScreen extends StatefulWidget {
  final String titleKey;
  final List<HomeProductData> products;

  const HomeSectionProductsScreen({
    super.key,
    required this.titleKey,
    required this.products,
  });

  @override
  State<HomeSectionProductsScreen> createState() => _HomeSectionProductsScreenState();
}

class _HomeSectionProductsScreenState extends State<HomeSectionProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSortKey = HomeSectionFilterDrawer.sortFeatured;
  late RangeValues _selectedPriceRange;
  late RangeValues _priceBounds;

  @override
  void initState() {
    super.initState();
    final double minPrice = widget.products.isEmpty
        ? 0
        : widget.products
            .map((item) => _extractPrice(item.currentPrice))
            .reduce((value, element) => value < element ? value : element);
    final double maxPrice = widget.products.isEmpty
        ? 1000
        : widget.products
            .map((item) => _extractPrice(item.currentPrice))
            .reduce((value, element) => value > element ? value : element);
    _priceBounds = RangeValues(minPrice.floorToDouble(), maxPrice.ceilToDouble());
    _selectedPriceRange = _priceBounds;
  }

  double _extractPrice(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  double _extractRating(String value) => double.tryParse(value) ?? 0;

  List<HomeProductData> get _filteredProducts {
    final List<HomeProductData> filtered = widget.products.where((item) {
      final double price = _extractPrice(item.currentPrice);
      return price >= _selectedPriceRange.start && price <= _selectedPriceRange.end;
    }).toList();

    switch (_selectedSortKey) {
      case HomeSectionFilterDrawer.sortPriceLowToHigh:
        filtered.sort((a, b) => _extractPrice(a.currentPrice).compareTo(_extractPrice(b.currentPrice)));
        break;
      case HomeSectionFilterDrawer.sortPriceHighToLow:
        filtered.sort((a, b) => _extractPrice(b.currentPrice).compareTo(_extractPrice(a.currentPrice)));
        break;
      case HomeSectionFilterDrawer.sortHighestRating:
        filtered.sort((a, b) => _extractRating(b.rating).compareTo(_extractRating(a.rating)));
        break;
      case HomeSectionFilterDrawer.sortLowestRating:
        filtered.sort((a, b) => _extractRating(a.rating).compareTo(_extractRating(b.rating)));
        break;
      case HomeSectionFilterDrawer.sortFeatured:
      default:
        break;
    }
    return filtered;
  }

  void _resetFilters() {
    setState(() {
      _selectedSortKey = HomeSectionFilterDrawer.sortFeatured;
      _selectedPriceRange = _priceBounds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final Color mutedColor = dark ? Colors.white70 : const Color(0xFF475467);
    final List<HomeProductData> products = _filteredProducts;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: widget.titleKey.tr(),
        translateTitle: false,
        showBackButton: true,
        backgroundColor: dark ? const Color(0xFF111827) : AppColors.whiteColor,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: OutlinedButton.icon(
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              icon: Icon(
                Icons.filter_list_rounded,
                size: 18,
                color: dark ? Colors.white70 : const Color(0xFF344054),
              ),
              label: Text(
                'Filters',
                style: TextStyles.blackBold14.copyWith(
                  color: dark ? Colors.white : const Color(0xFF344054),
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: dark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
              ),
            ),
          ),
        ],
      ),
      endDrawer: HomeSectionFilterDrawer(
        selectedSortKey: _selectedSortKey,
        onSortChanged: (value) => setState(() => _selectedSortKey = value),
        priceRange: _selectedPriceRange,
        minMaxPrice: _priceBounds,
        onPriceChanged: (value) => setState(() => _selectedPriceRange = value),
        onReset: _resetFilters,
        onApply: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.responsiveValue<double>(
                mobile: double.infinity,
                smallMobile: double.infinity,
                tablet: 1000,
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 18.0),
                      context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      context.responsiveValue(mobile: 10.0, smallMobile: 8.0, tablet: 12.0),
                    ),
                    child: Text(
                      '${products.length} products found',
                      style: TextStyles.blackRegular16.copyWith(
                        color: mutedColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                    0,
                    context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                    24,
                  ),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.crossAxisExtent;
                      final double spacing = context.responsiveValue(
                        mobile: 12.0,
                        smallMobile: 10.0,
                        tablet: 16.0,
                      );
                      final double minCardWidth = context.responsiveValue(
                        mobile: 154.0,
                        smallMobile: 148.0,
                        tablet: 200.0,
                      );
                      final int crossAxisCount = (width / (minCardWidth + spacing)).floor().clamp(2, 4);
                      final double itemWidth = (width - (crossAxisCount - 1) * spacing) / crossAxisCount;
                      final double imageHeight = itemWidth * 0.74;

                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = products[index];
                            return ProductCard(
                              data: item,
                              width: itemWidth,
                              imageHeight: imageHeight,
                              onTap: () {},
                              onFavoriteTap: () {},
                            );
                          },
                          childCount: products.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          mainAxisExtent: imageHeight + context.responsiveValue(
                            mobile: 132.0,
                            smallMobile: 126.0,
                            tablet: 144.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
