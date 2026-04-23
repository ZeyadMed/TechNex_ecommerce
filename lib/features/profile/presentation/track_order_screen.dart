import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:e_commerce/features/profile/presentation/widgets/track_order_address_card.dart';
import 'package:e_commerce/features/profile/presentation/widgets/track_order_items_card.dart';
import 'package:e_commerce/features/profile/presentation/widgets/track_order_summary_card.dart';
import 'package:e_commerce/features/profile/presentation/widgets/track_order_timeline_card.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatelessWidget {
  final TrackOrderArgs args;

  const TrackOrderScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color backgroundColor = dark ? const Color(0xFF0F172A) : const Color(0xFFF3F5F9);
    final double maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      smallMobile: double.infinity,
      tablet: 720,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'trackOrderPageTitle',
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
                    TrackOrderSummaryCard(args: args),
                    const SizedBox(height: 18),
                    TrackOrderTimelineCard(steps: args.steps),
                    const SizedBox(height: 18),
                    TrackOrderAddressCard(
                      line1: args.deliveryAddressLine1,
                      line2: args.deliveryAddressLine2,
                      phone: args.deliveryPhone,
                    ),
                    const SizedBox(height: 18),
                    TrackOrderItemsCard(items: args.items),
                    const SizedBox(height: 12),
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
