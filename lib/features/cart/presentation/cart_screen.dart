import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<_CartItem> _items = [
    const _CartItem(
      id: '1',
      titleKey: 'wirelessHeadphones',
      variantKey: 'blackColor',
      price: 179.99,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
    ),
    const _CartItem(
      id: '2',
      titleKey: 'smartWatch',
      variantKey: 'silverColor',
      price: 129.00,
      quantity: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
    ),
    const _CartItem(
      id: '3',
      titleKey: 'phoneCase',
      variantKey: 'clearCase',
      price: 18.50,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  double get _subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get _shipping => 0;
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _shipping + _tax;

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  void _updateQuantity(String id, int delta) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final current = _items[index];
    final nextQuantity = (current.quantity + delta).clamp(1, 99);
    setState(() {
      _items[index] = current.copyWith(quantity: nextQuantity);
    });
  }

  void _proceedToCheckout() {
    context.push(
      AppRouter.checkoutFlowScreen,
      extra: _items
          .map(
            (item) => {
              'id': item.id,
              'nameKey': item.titleKey,
              'price': item.price,
              'quantity': item.quantity,
            },
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bg = dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9);
    final cardBg = dark ? const Color(0xFF1D2434) : Colors.white;
    final maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 760,
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: CustomAppBar(
        title: 'cart',
        centerTitle: true,
        backgroundColor: bg,
      ),
      body: Column(
        children: [
          Divider(height: 1, color: dark ? Colors.white12 : const Color(0xFFE8ECF3)),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveValue(
                      mobile: 14.0,
                      smallMobile: 12.0,
                      tablet: 20.0,
                    ),
                    vertical: 14,
                  ),
                  children: [
                    _CartHeaderCard(
                      itemCount: _items.length,
                      subtotal: _money(_subtotal),
                    ),
                    const Gap(16),
                    ..._items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CartItemCard(
                          item: item,
                          dark: dark,
                          onIncrease: () => _updateQuantity(item.id, 1),
                          onDecrease: () => _updateQuantity(item.id, -1),
                          moneyFormatter: _money,
                        ),
                      ),
                    ),
                    const Gap(6),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocalizedLabel(
                            text: 'orderSummary',
                            style: TextStyles.blackBold20.copyWith(
                              color: dark ? Colors.white : const Color(0xFF111827),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(14),
                          _SummaryRow(titleKey: 'subtotal', value: _money(_subtotal), dark: dark),
                          _SummaryRow(
                            titleKey: 'shipping',
                            value: _shipping == 0 ? 'free' : _money(_shipping),
                            dark: dark,
                            valueColor: _shipping == 0 ? AppColors.greenColor : null,
                          ),
                          _SummaryRow(titleKey: 'tax', value: _money(_tax), dark: dark),
                          const Gap(8),
                          Divider(color: dark ? Colors.white12 : const Color(0xFFD0D5DD)),
                          Row(
                            children: [
                              Expanded(
                                child: LocalizedLabel(
                                  text: 'total',
                                  style: TextStyles.blackBold20.copyWith(
                                    color: dark ? Colors.white : const Color(0xFF111827),
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.responsiveValue(mobile: 18.0, smallMobile: 14.0, tablet: 20.0),
                                  ),
                                ),
                              ),
                              Text(
                                _money(_total),
                                style: TextStyles.blackBold20.copyWith(
                                  color: dark ? Colors.white : const Color(0xFF111827),
                                  fontWeight: FontWeight.w800,
                                  fontSize: context.responsiveValue(mobile: 18.0, smallMobile: 14.0, tablet: 20.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    CustomButton(
                      title: 'proceedToCheckout',
                      onPressed: _proceedToCheckout,
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E63F6).withValues(alpha: 0.20),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      textColor: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartHeaderCard extends StatelessWidget {
  final int itemCount;
  final String subtotal;

  const _CartHeaderCard({
    required this.itemCount,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocalizedLabel(
                  text: 'cartItemsCount',
                  style: TextStyles.whiteBold15.copyWith(fontWeight: FontWeight.w700),
                ),
                const Gap(4),
                LocalizedLabel(
                  text: 'readyToCheckout',
                  style: TextStyles.whiteBold14.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$itemCount',
                style: TextStyles.whiteBold15.copyWith(fontWeight: FontWeight.w700),
              ),
              LocalizedLabel(
                text: 'subtotal',
                style: TextStyles.whiteBold14.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const Gap(4),
              Text(
                subtotal,
                style: TextStyles.whiteBold15.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final _CartItem item;
  final bool dark;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final String Function(double value) moneyFormatter;

  const _CartItemCard({
    required this.item,
    required this.dark,
    required this.onIncrease,
    required this.onDecrease,
    required this.moneyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = dark ? const Color(0xFF1D2434) : Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item.imageUrl,
              width: context.responsiveValue(mobile: 84, smallMobile: 72, tablet: 104),
              height: context.responsiveValue(mobile: 84, smallMobile: 72, tablet: 104),
              fit: BoxFit.cover,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocalizedLabel(
                  text: item.titleKey,
                  style: TextStyles.blackBold16.copyWith(
                    color: dark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                LocalizedLabel(
                  text: item.variantKey,
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                Row(
                  children: [
                    _QtyButton(icon: Icons.remove, onTap: onDecrease, dark: dark),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyles.blackBold16.copyWith(
                          color: dark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _QtyButton(icon: Icons.add, onTap: onIncrease, dark: dark),
                    const Spacer(),
                    Text(
                      moneyFormatter(item.totalPrice),
                      style: TextStyles.blackBold20.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
                        fontSize: 18
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF26314A) : const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: dark ? Colors.white : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String titleKey;
  final String value;
  final bool dark;
  final Color? valueColor;

  const _SummaryRow({
    required this.titleKey,
    required this.value,
    required this.dark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: LocalizedLabel(
              text: titleKey,
              style: TextStyles.blackRegular14.copyWith(
                color: dark ? Colors.white70 : const Color(0xFF475467),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (value == 'free')
            LocalizedLabel(
              text: 'free',
              style: TextStyles.blackBold16.copyWith(
                color: valueColor ?? AppColors.greenColor,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            Text(
              value,
              style: TextStyles.blackBold16.copyWith(
                color: valueColor ?? (dark ? Colors.white : const Color(0xFF344054)),
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _CartItem {
  final String id;
  final String titleKey;
  final String variantKey;
  final double price;
  final int quantity;
  final String imageUrl;

  const _CartItem({
    required this.id,
    required this.titleKey,
    required this.variantKey,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  _CartItem copyWith({
    String? id,
    String? titleKey,
    String? variantKey,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return _CartItem(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      variantKey: variantKey ?? this.variantKey,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
