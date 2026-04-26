import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/features/home/presentation/widgets/product_card.dart';
import 'package:e_commerce/features/wishlist/presentation/wishlist_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsScreen extends StatefulWidget {
  final HomeProductData product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedImage;
  String? _selectedColor;
  String? _selectedSize;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.product.allImages.first;
    _selectedColor = widget.product.availableColors.isNotEmpty
        ? widget.product.availableColors.first
        : null;
    _selectedSize = widget.product.availableSizes.isNotEmpty
        ? widget.product.availableSizes.first
        : null;
  }

  double _extractPrice(String? value) {
    if (value == null) return 0;
    final String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  int? get _discountPercent {
    final double current = _extractPrice(widget.product.currentPrice);
    final double old = _extractPrice(widget.product.oldPrice);
    if (old <= 0 || current <= 0 || old <= current) return null;
    final discount = ((old - current) / old) * 100;
    return discount.round();
  }

  String get _deepLink {
    return Uri(
      scheme: 'https',
      host: 'technex.app',
      path: '/product/${widget.product.id}',
      queryParameters: {
        'title': widget.product.title,
      },
    ).toString();
  }

  Future<void> _shareProduct() async {
    final text = '${widget.product.title}\n${widget.product.currentPrice}\n$_deepLink';
    await Share.share(text, subject: widget.product.title);
  }

  String _localizedFeatureLabel(String label) {
    switch (label) {
      case 'Free Shipping':
        return 'freeShipping'.tr();
      case '2 Year Warranty':
        return 'twoYearWarranty'.tr();
      case '30 Day Returns':
        return 'dayReturns30'.tr();
      default:
        return label;
    }
  }

  Widget _variantChip({
    required String label,
    required bool selected,
    required bool disabled,
    required VoidCallback onTap,
    required bool dark,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: disabled
              ? (dark ? Colors.white10 : const Color(0xFFF3F4F6))
              : selected
              ? AppColors.primaryColor.withValues(alpha: dark ? 0.24 : 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: disabled
                ? (dark ? Colors.white24 : const Color(0xFFD1D5DB))
                : selected
                ? AppColors.primaryColor
                : (dark ? Colors.white24 : const Color(0xFFD0D5DD)),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.blackBold16.copyWith(
            color: disabled
                ? (dark ? Colors.white38 : const Color(0xFF9CA3AF))
                : selected
                ? AppColors.primaryColor
                : (dark ? Colors.white : const Color(0xFF111827)),
            fontWeight: FontWeight.w700,
            decoration: disabled ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final Color titleColor = dark ? Colors.white : const Color(0xFF111827);
    final Color mutedColor = dark ? Colors.white70 : const Color(0xFF6B7280);
    final List<String> colorOptions = [
      ...widget.product.availableColors,
      ...widget.product.unavailableColors.where((e) => !widget.product.availableColors.contains(e)),
    ];
    final List<String> sizeOptions = [
      ...widget.product.availableSizes,
      ...widget.product.unavailableSizes.where((e) => !widget.product.availableSizes.contains(e)),
    ];
    final bool outOfStock = (widget.product.stockCount ?? 1) <= 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.responsiveValue<double>(mobile: double.infinity, smallMobile: double.infinity, tablet: 760),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      context.responsiveValue(mobile: 8.0, smallMobile: 8.0, tablet: 10.0),
                      context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                      18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon: Icon(Icons.arrow_back_ios_new_rounded, color: titleColor),
                            ),
                            const Spacer(),
                            ValueListenableBuilder<Map<String, HomeProductData>>(
                              valueListenable: WishlistStore.favoritesListenable,
                              builder: (context, favorites, _) {
                                final bool isFavorite = favorites.containsKey(widget.product.id);
                                return IconButton(
                                  onPressed: () => WishlistStore.toggle(widget.product),
                                  icon: Icon(
                                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: isFavorite ? const Color(0xFFEF4444) : titleColor,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: _shareProduct,
                              icon: Icon(Icons.share_outlined, color: titleColor),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset(
                              _selectedImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 88,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final String image = widget.product.allImages[index];
                              final bool selected = image == _selectedImage;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedImage = image),
                                child: Container(
                                  width: 88,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selected ? AppColors.primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(image, fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemCount: widget.product.allImages.length,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.product.badgeText,
                            style: TextStyles.whiteBold14.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.product.title,
                          style: TextStyles.blackBold32.copyWith(
                            color: titleColor,
                            fontSize: context.responsiveValue(mobile: 44 * 0.84, smallMobile: 28.0, tablet: 40.0),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 22),
                                const SizedBox(width: 4),
                                Text(
                                  widget.product.rating,
                                  style: TextStyles.blackBold16.copyWith(
                                    color: titleColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(width: 1, height: 18, color: dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                            Text(
                              '${widget.product.reviews} ${'reviews'.tr()}',
                              style: TextStyles.blackRegular16.copyWith(color: mutedColor, fontWeight: FontWeight.w600),
                            ),
                            Container(width: 1, height: 18, color: dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                            Text(
                              outOfStock ? 'outOfStock'.tr() : 'inStock'.tr(),
                              style: TextStyles.blackRegular16.copyWith(
                                color: outOfStock ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              widget.product.currentPrice,
                              style: TextStyles.blackBold32.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if ((widget.product.oldPrice ?? '').isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Text(
                                widget.product.oldPrice!,
                                style: TextStyles.blackBold20.copyWith(
                                  color: mutedColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                            if (_discountPercent != null) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '-${_discountPercent!}%',
                                  style: TextStyles.blackBold14.copyWith(
                                    color: const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.product.description.isEmpty
                              ? 'productDetailsDefaultDescription'.tr()
                              : widget.product.description,
                          style: TextStyles.blackRegular16.copyWith(
                            color: mutedColor,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (colorOptions.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'color'.tr(),
                            style: TextStyles.blackBold20.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: colorOptions.map((color) {
                              final bool disabled = widget.product.unavailableColors.contains(color);
                              return _variantChip(
                                label: color,
                                selected: _selectedColor == color,
                                disabled: disabled,
                                onTap: () => setState(() => _selectedColor = color),
                                dark: dark,
                              );
                            }).toList(),
                          ),
                        ],
                        if (sizeOptions.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'size'.tr(),
                            style: TextStyles.blackBold20.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: sizeOptions.map((size) {
                              final bool disabled = widget.product.unavailableSizes.contains(size);
                              return _variantChip(
                                label: size,
                                selected: _selectedSize == size,
                                disabled: disabled,
                                onTap: () => setState(() => _selectedSize = size),
                                dark: dark,
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          'quantity'.tr(),
                          style: TextStyles.blackBold20.copyWith(
                            color: titleColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove,
                              onTap: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                              dark: dark,
                            ),
                            SizedBox(
                              width: 56,
                              child: Center(
                                child: Text(
                                  '$_quantity',
                                  style: TextStyles.blackBold20.copyWith(
                                    color: titleColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add,
                              onTap: () {
                                final maxQty = widget.product.stockCount;
                                if (maxQty != null && _quantity >= maxQty) return;
                                setState(() => _quantity++);
                              },
                              dark: dark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: outOfStock ? null : () {},
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: Text(
                              outOfStock ? 'outOfStock'.tr() : 'addToCart'.tr(),
                              style: TextStyles.whiteBold15.copyWith(fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: dark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _FeatureItem(
                                icon: Icons.local_shipping_outlined,
                                label: _localizedFeatureLabel(widget.product.deliveryLabel),
                                dark: dark,
                              ),
                              _FeatureItem(
                                icon: Icons.verified_user_outlined,
                                label: _localizedFeatureLabel(widget.product.warrantyLabel),
                                dark: dark,
                              ),
                              _FeatureItem(
                                icon: Icons.replay_outlined,
                                label: _localizedFeatureLabel(widget.product.refundLabel),
                                dark: dark,
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
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;

  const _QtyButton({required this.icon, required this.onTap, required this.dark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: dark ? Colors.white24 : const Color(0xFFD0D5DD)),
        ),
        child: Icon(icon, color: dark ? Colors.white : const Color(0xFF111827), size: 20),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;

  const _FeatureItem({required this.icon, required this.label, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.blackRegular14.copyWith(
              color: dark ? Colors.white70 : const Color(0xFF475467),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
