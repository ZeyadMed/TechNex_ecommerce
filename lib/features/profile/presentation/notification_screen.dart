import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/profile/presentation/widgets/notification_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final Color surfaceColor = dark ? const Color(0xFF1F2937) : AppColors.whiteColor;
    final Color mutedSurfaceColor = dark ? const Color(0xFF111827) : const Color(0xFFF8FAFC);
    final Color primaryTextColor = dark ? Colors.white : const Color(0xFF111827);
    final Color secondaryTextColor = dark ? Colors.white70 : const Color(0xFF6B7280);
    final double maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 720,
    );

    final notifications = <_NotificationEntry>[
      _NotificationEntry(
        accentColor: const Color(0xFF2E63F6),
        icon: Icons.local_shipping_outlined,
        title: 'orderDeliveredTitle'.tr(),
        body: 'orderDeliveredBody'.tr(args: ['#ORD123456']),
        time: '2h',
        unread: true,
      ),
      _NotificationEntry(
        accentColor: const Color(0xFF635BFF),
        icon: Icons.route_outlined,
        title: 'orderShippedTitle'.tr(),
        body: 'orderShippedBody'.tr(args: ['#ORD123455']),
        time: '2d',
        unread: false,
      ),
      _NotificationEntry(
        accentColor: const Color(0xFF8B5CF6),
        icon: Icons.local_offer_outlined,
        title: 'flashSaleTitle'.tr(),
        body: 'flashSaleBody'.tr(),
        time: '5h',
        unread: true,
      ),
      _NotificationEntry(
        accentColor: const Color(0xFFE63946),
        icon: Icons.percent_rounded,
        title: 'priceDropTitle'.tr(),
        body: 'priceDropBody'.tr(),
        time: '1d',
        unread: false,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'notifications',
        showBackButton: true,
        backgroundColor: dark ? const Color(0xFF111827) : AppColors.whiteColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 24.0),
                  vertical: context.responsiveValue(mobile: 16.0, smallMobile: 14.0, tablet: 20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...notifications.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Padding(
                        padding: EdgeInsets.only(bottom: index == notifications.length - 1 ? 0 : 10),
                        child: NotificationCard(
                          dark: dark,
                          surfaceColor: surfaceColor,
                          mutedSurfaceColor: mutedSurfaceColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                          accentColor: item.accentColor,
                          icon: item.icon,
                          title: item.title,
                          body: item.body,
                          time: item.time,
                          unread: item.unread,
                          onTap: () {},
                        ),
                      );
                    }),
                    const Gap(14),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationEntry {
  final Color accentColor;
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool unread;

  const _NotificationEntry({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });
}