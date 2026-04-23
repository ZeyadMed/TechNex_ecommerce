import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:e_commerce/features/profile/presentation/widgets/my_order_card.dart';
import 'package:e_commerce/features/profile/presentation/widgets/order_status_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final double maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 720,
    );

    final orders = <_OrderData>[
      const _OrderData(
        orderId: 'ORD123456',
        itemCount: 2,
        dateText: 'Apr 10, 2026',
        amount: r'$527.04',
        status: OrderStatus.delivered,
        imageAsset: 'assets/images/guest.png',
      ),
      const _OrderData(
        orderId: 'ORD123455',
        itemCount: 1,
        dateText: 'Apr 8, 2026',
        amount: r'$299.00',
        status: OrderStatus.processing,
        imageAsset: 'assets/images/upload.png',
      ),
      const _OrderData(
        orderId: 'ORD123454',
        itemCount: 1,
        dateText: 'Apr 5, 2026',
        amount: r'$189.00',
        status: OrderStatus.shipped,
        imageAsset: 'assets/images/buy_sell.jpg',
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'myOrders'.tr(),
        showBackButton: true,
        backgroundColor: dark ? const Color(0xFF111827) : AppColors.whiteColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
                context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
                24,
              ),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return MyOrderCard(
                  orderId: order.orderId,
                  itemCount: order.itemCount,
                  dateText: order.dateText,
                  amount: order.amount,
                  imageAsset: order.imageAsset,
                  status: order.status,
                  onTrackTap: () => context.push(
                    AppRouter.trackOrderScreen,
                    extra: TrackOrderArgs.sample(
                      orderId: order.orderId,
                      amount: order.amount,
                      imageAsset: order.imageAsset,
                      status: order.status,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderData {
  final String orderId;
  final int itemCount;
  final String dateText;
  final String amount;
  final OrderStatus status;
  final String imageAsset;

  const _OrderData({
    required this.orderId,
    required this.itemCount,
    required this.dateText,
    required this.amount,
    required this.status,
    required this.imageAsset,
  });
}