import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/features/home/presentation/widgets/home_banner_carousel.dart';
import 'package:e_commerce/features/home/presentation/widgets/home_categories_section.dart';
import 'package:e_commerce/features/home/presentation/widgets/home_header.dart';
import 'package:e_commerce/features/home/presentation/widgets/home_product_section.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:e_commerce/features/category/presentation/category_products_screen.dart';
import 'package:e_commerce/features/home/presentation/home_section_products_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC);
    final double maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 720,
    );

    final List<HomeProductData> flashDealsProducts = const [
      HomeProductData(
        imageAsset: 'assets/images/guest.png',
        galleryImages: [
          'assets/images/guest.png',
          'assets/images/buy_sell.jpg',
          'assets/images/Logta.jpeg',
        ],
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
        imageAsset: 'assets/images/buy_sell.jpg',
        badgeText: 'New',
        title: 'Designer Sneakers',
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
        reviews: '610',
        currentPrice: r'$499',
        oldPrice: r'$629',
      ),
      HomeProductData(
        imageAsset: 'assets/images/Logta.jpeg',
        badgeText: 'Trending',
        title: 'Wireless Earbuds Pro',
        rating: '4.7',
        reviews: '782',
        currentPrice: r'$149',
        oldPrice: null,
        stockCount: 31,
      ),
    ];

    final List<HomeProductData> trendingProducts = const [
      HomeProductData(
        imageAsset: 'assets/images/fastShare.png',
        galleryImages: [
          'assets/images/fastShare.png',
          'assets/images/guest.png',
          'assets/images/upload.png',
        ],
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
        imageAsset: 'assets/images/buy_sell.jpg',
        badgeText: 'New',
        title: 'Designer Sneakers',
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
        reviews: '610',
        currentPrice: r'$499',
        oldPrice: r'$629',
      ),
      HomeProductData(
        imageAsset: 'assets/images/Logta_logo_light.jpeg',
        badgeText: 'Trending',
        title: 'Premium Leather Backpack',
        rating: '4.7',
        reviews: '520',
        currentPrice: r'$219',
        oldPrice: r'$289',
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                HomeHeader(
                  dark: dark,
                  onNotificationTap: () {},
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
                        vertical: context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeBannerCarousel(
                            banners: const [
                              'assets/images/sellandbuy.png',
                              'assets/images/buy_sell.jpg',
                              'assets/images/fastShare.png',
                            ],
                          ),
                          const SizedBox(height: 18),
                          HomeCategoriesSection(
                            onCategoryTap: (category) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CategoryProductsScreen(
                                    categoryKey: category.titleKey,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          HomeProductSection(
                            titleKey: 'flashDeals',
                            icon: Icons.flash_on_rounded,
                            products: flashDealsProducts,
                            onSeeAllTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HomeSectionProductsScreen(
                                    titleKey: 'flashDeals',
                                    products: flashDealsProducts,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          HomeProductSection(
                            titleKey: 'trendingNow',
                            icon: Icons.trending_up_rounded,
                            products: trendingProducts,
                            onSeeAllTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HomeSectionProductsScreen(
                                    titleKey: 'trendingNow',
                                    products: trendingProducts,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
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
