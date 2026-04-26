import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/wishlist/presentation/wishlist_store.dart';
import 'package:flutter/material.dart';

class HomeProductData {
  final String? productId;
  final String imageAsset;
  final List<String> galleryImages;
  final String badgeText;
  final String title;
  final String description;
  final String rating;
  final String reviews;
  final String currentPrice;
  final String? oldPrice;
  final int? stockCount;
  final List<String> availableColors;
  final List<String> availableSizes;
  final List<String> unavailableColors;
  final List<String> unavailableSizes;
  final String deliveryLabel;
  final String warrantyLabel;
  final String refundLabel;

  const HomeProductData({
    this.productId,
    required this.imageAsset,
    this.galleryImages = const [],
    required this.badgeText,
    required this.title,
    this.description = '',
    required this.rating,
    required this.reviews,
    required this.currentPrice,
    this.oldPrice,
    this.stockCount,
    this.availableColors = const [],
    this.availableSizes = const [],
    this.unavailableColors = const [],
    this.unavailableSizes = const [],
    this.deliveryLabel = 'Free Shipping',
    this.warrantyLabel = '2 Year Warranty',
    this.refundLabel = '30 Day Returns',
  });

  String get id {
    if (productId != null && productId!.isNotEmpty) return productId!;
    final normalized = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return normalized.isEmpty ? title.hashCode.toString() : normalized;
  }

  List<String> get allImages => galleryImages.isEmpty ? [imageAsset] : galleryImages;
}

class ProductCard extends StatelessWidget {
  final HomeProductData data;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final double? width;
  final double? imageHeight;

  const ProductCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.onFavoriteTap,
    this.width,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final double cardWidth = width ?? context.responsiveValue<double>(
      mobile: context.screenWidth * 0.42,
      smallMobile: context.screenWidth * 0.62,
      tablet: 220.0,
    );
    final double cardImageHeight = imageHeight ?? context.responsiveValue(
      mobile: 150.0,
      smallMobile: 126.0,
      tablet: 152.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: dark ? Colors.black.withValues(alpha: 0.14) : const Color(0x120F172A),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: cardWidth,
                  height: cardImageHeight,
                  child: Image.asset(
                    data.imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      data.badgeText,
                      style: TextStyles.whiteBold14.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: ValueListenableBuilder<Map<String, HomeProductData>>(
                    valueListenable: WishlistStore.favoritesListenable,
                    builder: (context, favorites, _) {
                      final bool isFavorite = favorites.containsKey(data.id);
                      return GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          height: 34,
                          width: 34,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: isFavorite
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(context.responsiveValue(mobile: 12.0, smallMobile: 10.0, tablet: 14.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.blackBold14.copyWith(
                      color: dark ? Colors.white : const Color(0xFF111827),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        data.rating,
                        style: TextStyles.blackBold12.copyWith(
                          color: dark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${data.reviews})',
                        style: TextStyles.blackRegular12.copyWith(
                          color: dark ? Colors.white54 : const Color(0xFF98A2B3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        data.currentPrice,
                        style: TextStyles.blackBold20.copyWith(
                          color: dark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          fontSize: 18,
                        ),
                      ),
                      if ((data.oldPrice ?? '').isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          data.oldPrice!,
                          style: TextStyles.blackRegular14.copyWith(
                            color: dark ? Colors.white54 : const Color(0xFF98A2B3),
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
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
