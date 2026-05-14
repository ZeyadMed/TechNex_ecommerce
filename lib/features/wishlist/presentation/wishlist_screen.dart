import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/home/presentation/product_details_screen.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:e_commerce/features/wishlist/presentation/wishlist_store.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  List<HomeProductData> _mergedProducts(Map<String, HomeProductData> favorites) {
    final ids = _defaultProducts.map((e) => e.id).toSet();
    final merged = [..._defaultProducts];
    for (final item in favorites.values) {
      if (!ids.contains(item.id)) {
        merged.insert(0, item);
      }
    }
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final Color mutedTextColor = dark ? Colors.white70 : const Color(0xFF6B7280);
    final Color titleColor = dark ? Colors.white : const Color(0xFF111827);
    final double horizontalPadding = context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0);
    final double topPadding = context.responsiveValue(mobile: 14.0, smallMobile: 12.0, tablet: 20.0);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'wishlist',
        showBackButton: false,
        backgroundColor: dark ? const Color(0xFF111827) : AppColors.whiteColor,
      ),
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder<Map<String, HomeProductData>>(
        valueListenable: WishlistStore.favoritesListenable,
        builder: (context, favorites, _) {
          final products = _mergedProducts(favorites);
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.responsiveValue<double>(mobile: double.infinity, smallMobile: double.infinity, tablet: 720),
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 24),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${products.length} items saved',
                              style: TextStyle(
                                fontSize: context.responsiveValue(mobile: 17.0, smallMobile: 16.0, tablet: 18.0),
                                fontWeight: FontWeight.w500,
                                color: mutedTextColor,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: context.responsiveValue(mobile: 22.0, smallMobile: 18.0, tablet: 24.0),
                                bottom: context.responsiveValue(mobile: 18.0, smallMobile: 16.0, tablet: 20.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Saved Items',
                                      style: TextStyle(
                                        fontSize: context.responsiveValue(mobile: 20.0, smallMobile: 18.0, tablet: 22.0),
                                        fontWeight: FontWeight.w700,
                                        color: titleColor,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                                    label: const Text('Add All to Cart'),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xFF5B4BFF),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 18.0),
                                        vertical: context.responsiveValue(mobile: 14.0, smallMobile: 12.0, tablet: 14.0),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          final double width = constraints.crossAxisExtent;
                          final double spacing = context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 16.0);
                          final double minCardWidth = context.responsiveValue(mobile: 154.0, smallMobile: 148.0, tablet: 200.0);
                          final int crossAxisCount = (width / (minCardWidth + spacing)).floor().clamp(2, 4);
                          final double itemWidth = (width - (crossAxisCount - 1) * spacing) / crossAxisCount;
                          final double imageHeight = itemWidth * 0.74;

                          return SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  data: product,
                                  width: itemWidth,
                                  imageHeight: imageHeight,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(product: product),
                                      ),
                                    );
                                  },
                                  onFavoriteTap: () => WishlistStore.toggle(product),
                                );
                              },
                              childCount: products.length,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              mainAxisExtent: imageHeight + context.responsiveValue(mobile: 132.0, smallMobile: 126.0, tablet: 144.0),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

const List<HomeProductData> _defaultProducts = [
  HomeProductData(
    imageAsset: 'assets/images/guest.png',
    badgeText: 'Bestseller',
    title: 'Premium Wireless Headphones',
    description:
        'Experience superior sound quality with active noise cancellation and 30-hour battery life. Premium materials and ergonomic design for all-day comfort.',
    rating: '4.8',
    reviews: '1247',
    currentPrice: r'$299',
    oldPrice: r'$399',
    stockCount: 45,
    availableColors: ['White', 'Black', 'Silver'],
    availableSizes: ['M', 'L'],
    unavailableColors: ['Gold'],
    unavailableSizes: ['XL'],
  ),
  HomeProductData(
    imageAsset: 'assets/images/guest.png',
    badgeText: 'New',
    title: 'Designer Sneakers - White',
    rating: '4.6',
    reviews: '892',
    currentPrice: r'$189',
    oldPrice: r'$249',
  ),
  HomeProductData(
    imageAsset: 'assets/images/upload.png',
    badgeText: 'Premium',
    title: 'Luxury Automatic Watch',
    rating: '4.9',
    reviews: '567',
    currentPrice: r'$499',
    oldPrice: r'$629',
  ),
  HomeProductData(
    imageAsset: 'assets/images/Logta_logo_light.jpeg',
    badgeText: 'Trending',
    title: 'Premium Leather Backpack',
    rating: '4.7',
    reviews: '423',
    currentPrice: r'$219',
    oldPrice: r'$289',
  ),
  HomeProductData(
    imageAsset: 'assets/images/guest.png',
    badgeText: 'Deal',
    title: 'Smart Fitness Watch',
    rating: '4.5',
    reviews: '315',
    currentPrice: r'$159',
    oldPrice: r'$199',
  ),
  HomeProductData(
    imageAsset: 'assets/images/guest.png',
    badgeText: 'New',
    title: 'Noise Cancelling Earbuds',
    rating: '4.8',
    reviews: '984',
    currentPrice: r'$139',
    oldPrice: r'$179',
  ),
];
