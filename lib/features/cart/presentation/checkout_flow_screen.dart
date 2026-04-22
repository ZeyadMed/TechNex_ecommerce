import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CheckoutFlowScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutFlowScreen({super.key, required this.cartItems});

  @override
  State<CheckoutFlowScreen> createState() => _CheckoutFlowScreenState();
}

class _CheckoutFlowScreenState extends State<CheckoutFlowScreen> {
  int _currentStep = 0;
  int _selectedAddressIndex = 0;
  String _selectedPaymentId = 'cod';

  late final List<_CheckoutItem> _items;

  final List<_AddressOption> _addresses = const [
    _AddressOption(
      labelKey: 'homeAddressLabel',
      fullAddress: '123 Main St, New York, NY 10001',
      phone: '+1 234-567-8900',
    ),
    _AddressOption(
      labelKey: 'workAddressLabel',
      fullAddress: '456 Office Blvd, New York, NY 10002',
      phone: '+1 234-567-8901',
    ),
  ];

  final List<_PaymentMethod> _paymentMethods = const [
    _PaymentMethod(
      id: 'card',
      titleKey: 'creditDebitCard',
      subtitleKey: 'creditDebitCardSub',
      icon: Icons.credit_card_outlined,
    ),
    _PaymentMethod(
      id: 'wallet',
      titleKey: 'digitalWallet',
      subtitleKey: 'digitalWalletSub',
      icon: Icons.account_balance_wallet_outlined,
    ),
    _PaymentMethod(
      id: 'cod',
      titleKey: 'cashOnDelivery',
      subtitleKey: 'cashOnDeliverySub',
      icon: Icons.payments_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _items = widget.cartItems
        .map((e) => _CheckoutItem.fromMap(e))
        .where((item) => item.quantity > 0)
        .toList();
  }

  double get _subtotal =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get _shipping => _subtotal >= 500 ? 0 : 24;

  double get _tax => _subtotal * 0.08;

  double get _total => _subtotal + _shipping + _tax;

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  void _goNextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  void _goPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      return;
    }
    context.pop();
  }

  Future<void> _handleAddNewAddress() async {
    await context.push(AppRouter.addressesScreen);
    if (!mounted) return;
    setState(() => _currentStep = 1);
  }

  Future<void> _placeOrder() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final dark = dialogContext.isDarkMode;
        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF1F2937) : Colors.white,
          title: LocalizedLabel(
            text: 'orderPlacedTitle',
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          content: LocalizedLabel(
            text: 'orderPlacedMessage',
            style: TextStyles.blackRegular16.copyWith(
              color: dark ? Colors.white70 : const Color(0xFF667085),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: LocalizedLabel(
                text: 'close',
                style: TextStyles.blackBold14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    context.go(AppRouter.initialRoot);
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bg = dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9);
    final maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 760,
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: CustomAppBar(
        title: 'checkout',
        showBackButton: true,
        centerTitle: true,
        backgroundColor: bg,
        onBackPressed: _goPreviousStep,
      ),
      body: Column(
        children: [
          Divider(
            height: 1,
            color: dark ? Colors.white12 : const Color(0xFFE8ECF3),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsiveValue(
                      mobile: 14.0,
                      smallMobile: 12.0,
                      tablet: 20.0,
                    ),
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CheckoutStepper(currentStep: _currentStep),
                      const Gap(20),
                      if (_currentStep == 0) _buildAddressStep(context),
                      if (_currentStep == 1) _buildPaymentStep(context),
                      if (_currentStep == 2) _buildReviewStep(context),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep(BuildContext context) {
    final dark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedLabel(
          text: 'selectDeliveryAddress',
          style: TextStyles.blackBold32.copyWith(
            fontSize: context.responsiveValue(
              mobile: 34,
              smallMobile: 30,
              tablet: 38,
            ),
            color: dark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(14),
        ...List.generate(_addresses.length, (index) {
          final address = _addresses[index];
          final selected = _selectedAddressIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedAddressIndex = index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? (dark
                            ? const Color(0xFF26314A)
                            : const Color(0xFFEEF2FF))
                        : (dark ? const Color(0xFF1D2434) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryColor
                          : (dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocalizedLabel(
                              text: address.labelKey,
                              style: TextStyles.blackBold20.copyWith(
                                color:
                                    dark ? Colors.white : const Color(0xFF111827),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              address.fullAddress,
                              style: TextStyles.blackRegular16.copyWith(
                                color: dark
                                    ? Colors.white70
                                    : const Color(0xFF475467),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              address.phone,
                              style: TextStyles.blackRegular16.copyWith(
                                color: dark
                                    ? Colors.white70
                                    : const Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const Gap(8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _handleAddNewAddress,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dark ? Colors.white24 : const Color(0xFFD0D5DD),
                ),
              ),
              child: LocalizedLabel(
                text: 'addNewAddress',
                style: TextStyles.blackBold20.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: context.responsiveValue(
                    mobile: 18,
                    smallMobile: 16,
                    tablet: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(16),
        CustomButton(
          title: 'continueToPayment',
          onPressed: _goNextStep,
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
    );
  }

  Widget _buildPaymentStep(BuildContext context) {
    final dark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedLabel(
          text: 'paymentMethod',
          style: TextStyles.blackBold32.copyWith(
            fontSize: context.responsiveValue(
              mobile: 34,
              smallMobile: 30,
              tablet: 38,
            ),
            color: dark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(14),
        ..._paymentMethods.map((method) {
          final selected = method.id == _selectedPaymentId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedPaymentId = method.id),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: selected
                        ? (dark
                            ? const Color(0xFF26314A)
                            : const Color(0xFFEEF2FF))
                        : (dark ? const Color(0xFF1D2434) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryColor
                          : (dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        method.icon,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LocalizedLabel(
                              text: method.titleKey,
                              style: TextStyles.blackBold20.copyWith(
                                color:
                                    dark ? Colors.white : const Color(0xFF111827),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(2),
                            LocalizedLabel(
                              text: method.subtitleKey,
                              style: TextStyles.blackRegular16.copyWith(
                                color: dark
                                    ? Colors.white70
                                    : const Color(0xFF667085),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: 'back',
                onPressed: _goPreviousStep,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.transparent,
                borderColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(12),
            Expanded(
              flex: 2,
              child: CustomButton(
                title: 'reviewOrder',
                onPressed: _goNextStep,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                ),
                textColor: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep(BuildContext context) {
    final dark = context.isDarkMode;
    final selectedAddress = _addresses[_selectedAddressIndex];
    final selectedPayment =
        _paymentMethods.firstWhere((element) => element.id == _selectedPaymentId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedLabel(
          text: 'reviewYourOrder',
          style: TextStyles.blackBold32.copyWith(
            fontSize: context.responsiveValue(
              mobile: 34,
              smallMobile: 30,
              tablet: 38,
            ),
            color: dark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(14),
        _ReviewInfoCard(
          titleKey: 'deliveringTo',
          value: selectedAddress.fullAddress,
        ),
        const Gap(12),
        _ReviewInfoCard(
          titleKey: 'paymentMethod',
          valueKey: selectedPayment.titleKey,
        ),
        const Gap(12),
        _OrderSummaryCard(
          subtotal: _subtotal,
          shipping: _shipping,
          tax: _tax,
          total: _total,
          moneyFormatter: _money,
        ),
        const Gap(12),
        _ProductsReviewCard(
          items: _items,
          moneyFormatter: _money,
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: 'back',
                onPressed: _goPreviousStep,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.transparent,
                borderColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(12),
            Expanded(
              flex: 2,
              child: CustomButton(
                title: 'placeOrder',
                onPressed: _placeOrder,
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                ),
                textColor: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckoutStepper extends StatelessWidget {
  final int currentStep;

  const _CheckoutStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    final titles = ['addressStep', 'paymentStep', 'reviewStep'];

    return Row(
      children: List.generate(titles.length * 2 - 1, (index) {
        if (index.isOdd) {
          final beforeStep = index ~/ 2;
          final activeLine = currentStep > beforeStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 22),
              height: 3,
              decoration: BoxDecoration(
                color: activeLine
                    ? AppColors.primaryColor
                    : (dark ? Colors.white24 : const Color(0xFFD0D5DD)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        }

        final step = index ~/ 2;
        final completed = currentStep > step;
        final active = currentStep == step;

        return Column(
          children: [
            Container(
              width: context.responsiveValue(
                mobile: 38.0,
                smallMobile: 34.0,
                tablet: 42.0,
              ),
              height: context.responsiveValue(
                mobile: 38.0,
                smallMobile: 34.0,
                tablet: 42.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed || active
                    ? AppColors.primaryColor
                    : (dark ? const Color(0xFF293042) : const Color(0xFFE4E7EC)),
              ),
              child: Center(
                child: completed
                    ? const Icon(Icons.check_rounded, color: Colors.white)
                    : Text(
                        '${step + 1}',
                        style: TextStyles.blackBold16.copyWith(
                          color:
                              completed || active ? Colors.white : const Color(0xFF98A2B3),
                        ),
                      ),
              ),
            ),
            const Gap(8),
            LocalizedLabel(
              text: titles[step],
              style: TextStyles.blackRegular16.copyWith(
                color: completed || active
                    ? AppColors.primaryColor
                    : (dark ? Colors.white60 : const Color(0xFF98A2B3)),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ReviewInfoCard extends StatelessWidget {
  final String titleKey;
  final String? value;
  final String? valueKey;

  const _ReviewInfoCard({
    required this.titleKey,
    this.value,
    this.valueKey,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1D2434) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedLabel(
            text: titleKey,
            style: TextStyles.blackBold16.copyWith(
              color: dark ? Colors.white70 : const Color(0xFF667085),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          if (value != null)
            Text(
              value!,
              style: TextStyles.blackBold20.copyWith(
                color: dark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
          if (valueKey != null)
            LocalizedLabel(
              text: valueKey!,
              style: TextStyles.blackBold20.copyWith(
                color: dark ? Colors.white : const Color(0xFF111827),
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String Function(double value) moneyFormatter;

  const _OrderSummaryCard({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.moneyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    Widget row({required String titleKey, required String value, Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: LocalizedLabel(
                text: titleKey,
                style: TextStyles.blackRegular16.copyWith(
                  color: dark ? Colors.white70 : const Color(0xFF475467),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1D2434) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedLabel(
            text: 'orderSummary',
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const Gap(14),
          row(titleKey: 'subtotal', value: moneyFormatter(subtotal)),
          row(
            titleKey: 'shipping',
            value: shipping == 0 ? 'free'.tr() : moneyFormatter(shipping),
            valueColor: shipping == 0 ? AppColors.greenColor : null,
          ),
          row(titleKey: 'tax', value: moneyFormatter(tax)),
          Divider(color: dark ? Colors.white12 : const Color(0xFFD0D5DD)),
          Row(
            children: [
              Expanded(
                child: LocalizedLabel(
                  text: 'total',
                  style: TextStyles.blackBold20.copyWith(
                    color: dark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                moneyFormatter(total),
                style: TextStyles.blackBold20.copyWith(
                  color: dark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductsReviewCard extends StatelessWidget {
  final List<_CheckoutItem> items;
  final String Function(double value) moneyFormatter;

  const _ProductsReviewCard({
    required this.items,
    required this.moneyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1D2434) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedLabel(
            text: 'products',
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const Gap(10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: LocalizedLabel(
                      text: item.nameKey,
                      style: TextStyles.blackRegular16.copyWith(
                        color: dark ? Colors.white70 : const Color(0xFF475467),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: TextStyles.blackRegular16.copyWith(
                      color: dark ? Colors.white70 : const Color(0xFF667085),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    moneyFormatter(item.price * item.quantity),
                    style: TextStyles.blackBold16.copyWith(
                      color: dark ? Colors.white : const Color(0xFF111827),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressOption {
  final String labelKey;
  final String fullAddress;
  final String phone;

  const _AddressOption({
    required this.labelKey,
    required this.fullAddress,
    required this.phone,
  });
}

class _PaymentMethod {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  const _PaymentMethod({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });
}

class _CheckoutItem {
  final String id;
  final String nameKey;
  final double price;
  final int quantity;

  const _CheckoutItem({
    required this.id,
    required this.nameKey,
    required this.price,
    required this.quantity,
  });

  factory _CheckoutItem.fromMap(Map<String, dynamic> map) {
    return _CheckoutItem(
      id: (map['id'] ?? '').toString(),
      nameKey: (map['nameKey'] ?? 'products').toString(),
      price: (map['price'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
