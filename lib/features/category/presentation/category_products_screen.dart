import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/category/presentation/widgets/category_filter_drawer.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryKey;

  const CategoryProductsScreen({super.key, required this.categoryKey});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedSortKey = CategoryFilterDrawer.sortFeatured;
  String _selectedSubCategory = _allSubCategories;
  late RangeValues _selectedPriceRange;
  late RangeValues _priceBounds;

  static const String _allSubCategories = 'All Sub Categories';

  late final List<_CategoryProductItem> _categoryProducts;

  @override
  void initState() {
    super.initState();
    _categoryProducts = _allProducts
        .where((item) => item.categoryKey == widget.categoryKey)
        .toList(growable: false);

    final double minPrice = _categoryProducts.isEmpty
        ? 0
        : _categoryProducts
            .map((item) => item.price)
            .reduce((value, element) => value < element ? value : element);
    final double maxPrice = _categoryProducts.isEmpty
        ? 1000
        : _categoryProducts
            .map((item) => item.price)
            .reduce((value, element) => value > element ? value : element);

    _priceBounds = RangeValues(minPrice.floorToDouble(), maxPrice.ceilToDouble());
    _selectedPriceRange = _priceBounds;
  }

  List<String> get _subCategories {
    final Set<String> values = _categoryProducts.map((e) => e.subCategory).toSet();
    return <String>[_allSubCategories, ...values];
  }

  List<_CategoryProductItem> get _filteredProducts {
    final List<_CategoryProductItem> filtered = _categoryProducts.where((item) {
      final bool subCategoryMatch = _selectedSubCategory == _allSubCategories || item.subCategory == _selectedSubCategory;
      final bool priceMatch = item.price >= _selectedPriceRange.start && item.price <= _selectedPriceRange.end;
      return subCategoryMatch && priceMatch;
    }).toList();

    switch (_selectedSortKey) {
      case CategoryFilterDrawer.sortPriceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case CategoryFilterDrawer.sortPriceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case CategoryFilterDrawer.sortHighestRating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case CategoryFilterDrawer.sortLowestRating:
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case CategoryFilterDrawer.sortFeatured:
      default:
        filtered.sort((a, b) => a.featuredRank.compareTo(b.featuredRank));
    }

    return filtered;
  }

  void _resetFilters() {
    setState(() {
      _selectedSortKey = CategoryFilterDrawer.sortFeatured;
      _selectedSubCategory = _allSubCategories;
      _selectedPriceRange = _priceBounds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final Color mutedColor = dark ? Colors.white70 : const Color(0xFF475467);

    final List<_CategoryProductItem> products = _filteredProducts;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: widget.categoryKey.tr(),
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
      endDrawer: CategoryFilterDrawer(
        selectedSortKey: _selectedSortKey,
        onSortChanged: (value) => setState(() => _selectedSortKey = value),
        selectedSubCategory: _selectedSubCategory,
        subCategories: _subCategories,
        onSubCategoryChanged: (value) => setState(() => _selectedSubCategory = value),
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
              maxWidth: context.responsiveValue<double>(mobile: double.infinity, smallMobile: double.infinity, tablet: 1000),
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
                      final double spacing = context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 16.0);
                      final double minCardWidth = context.responsiveValue(mobile: 154.0, smallMobile: 148.0, tablet: 200.0);
                      final int crossAxisCount = (width / (minCardWidth + spacing)).floor().clamp(2, 4);
                      final double itemWidth = (width - (crossAxisCount - 1) * spacing) / crossAxisCount;
                      final double imageHeight = itemWidth * 0.74;
                      final double cardExtraHeight = context.responsiveValue(mobile: 132.0, smallMobile: 126.0, tablet: 144.0);

                      if (products.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                            decoration: BoxDecoration(
                              color: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'No products match your filters',
                              textAlign: TextAlign.center,
                              style: TextStyles.blackRegular16.copyWith(
                                color: mutedColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = products[index];
                            return ProductCard(
                              data: item.product,
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
                          mainAxisExtent: imageHeight + cardExtraHeight,
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

class _CategoryProductItem {
  final String categoryKey;
  final String subCategory;
  final double price;
  final double rating;
  final int featuredRank;
  final HomeProductData product;

  const _CategoryProductItem({
    required this.categoryKey,
    required this.subCategory,
    required this.price,
    required this.rating,
    required this.featuredRank,
    required this.product,
  });
}

const List<_CategoryProductItem> _allProducts = [
  _CategoryProductItem(
    categoryKey: 'electronics',
    subCategory: 'Headphones',
    price: 299,
    rating: 4.8,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/guest.png',
      badgeText: 'Bestseller',
      title: 'Premium Wireless Headphones',
      rating: '4.8',
      reviews: '1247',
      currentPrice: r'$299',
      oldPrice: r'$399',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'electronics',
    subCategory: 'Earbuds',
    price: 179,
    rating: 4.5,
    featuredRank: 2,
    product: HomeProductData(
      imageAsset: 'assets/images/Logta.jpeg',
      badgeText: 'Trending',
      title: 'Wireless Earbuds Pro',
      rating: '4.5',
      reviews: '1089',
      currentPrice: r'$179',
      oldPrice: r'$219',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'electronics',
    subCategory: 'Headphones',
    price: 249,
    rating: 4.9,
    featuredRank: 3,
    product: HomeProductData(
      imageAsset: 'assets/images/fastShare.png',
      badgeText: 'Bestseller',
      title: 'Studio Headphones',
      rating: '4.9',
      reviews: '891',
      currentPrice: r'$249',
      oldPrice: r'$299',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'fashion',
    subCategory: 'Sneakers',
    price: 189,
    rating: 4.6,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/buy_sell.jpg',
      badgeText: 'New',
      title: 'Designer Sneakers',
      rating: '4.6',
      reviews: '892',
      currentPrice: r'$189',
      oldPrice: r'$249',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'fashion',
    subCategory: 'Jackets',
    price: 159,
    rating: 4.4,
    featuredRank: 2,
    product: HomeProductData(
      imageAsset: 'assets/images/upload.png',
      badgeText: 'Deal',
      title: 'Urban Street Jacket',
      rating: '4.4',
      reviews: '312',
      currentPrice: r'$159',
      oldPrice: r'$219',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'watches',
    subCategory: 'Luxury',
    price: 499,
    rating: 4.9,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/upload.png',
      badgeText: 'Premium',
      title: 'Luxury Automatic Watch',
      rating: '4.9',
      reviews: '610',
      currentPrice: r'$499',
      oldPrice: r'$629',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'watches',
    subCategory: 'Fitness',
    price: 159,
    rating: 4.5,
    featuredRank: 2,
    product: HomeProductData(
      imageAsset: 'assets/images/fastShare.png',
      badgeText: 'Deal',
      title: 'Smart Fitness Watch',
      rating: '4.5',
      reviews: '315',
      currentPrice: r'$159',
      oldPrice: r'$199',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'bags',
    subCategory: 'Backpacks',
    price: 219,
    rating: 4.7,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/Logta_logo_light.jpeg',
      badgeText: 'Trending',
      title: 'Premium Leather Backpack',
      rating: '4.7',
      reviews: '520',
      currentPrice: r'$219',
      oldPrice: r'$289',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'accessories',
    subCategory: 'Wallets',
    price: 109,
    rating: 4.3,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/guest.png',
      badgeText: 'New',
      title: 'Minimal Leather Wallet',
      rating: '4.3',
      reviews: '208',
      currentPrice: r'$109',
      oldPrice: r'$139',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'sports',
    subCategory: 'Training',
    price: 129,
    rating: 4.2,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/fastShare.png',
      badgeText: 'Sport',
      title: 'Training Shoes',
      rating: '4.2',
      reviews: '162',
      currentPrice: r'$129',
      oldPrice: r'$169',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'phones',
    subCategory: 'Smartphones',
    price: 899,
    rating: 4.8,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/buy_sell.jpg',
      badgeText: 'Flagship',
      title: 'Smartphone Pro Max',
      rating: '4.8',
      reviews: '743',
      currentPrice: r'$899',
      oldPrice: r'$999',
    ),
  ),
  _CategoryProductItem(
    categoryKey: 'gaming',
    subCategory: 'Consoles',
    price: 499,
    rating: 4.7,
    featuredRank: 1,
    product: HomeProductData(
      imageAsset: 'assets/images/Logta.jpeg',
      badgeText: 'Hot',
      title: 'Next-Gen Gaming Console',
      rating: '4.7',
      reviews: '501',
      currentPrice: r'$499',
      oldPrice: r'$549',
    ),
  ),
];
