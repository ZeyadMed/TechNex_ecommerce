import 'package:flutter/material.dart';
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:e_commerce/features/profile/presentation/widgets/profile_option_tile.dart';
import 'package:e_commerce/features/profile/presentation/widgets/profile_stat_card.dart';
import 'package:e_commerce/features/profile/presentation/widgets/recent_order_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _toggleLanguageAndGoRoot(BuildContext context) async {
    final nextLocale = context.locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    await context.setLocale(nextLocale);
    if (!context.mounted) return;
    context.go(AppRouter.root);
  }

  void _toggleTheme(BuildContext context) {
    final dark = context.isDarkMode;
    context
        .read<ThemeBloc>()
        .add(ThemeChanged(dark ? ThemeMode.light : ThemeMode.dark));
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogDark = dialogContext.isDarkMode;
        return AlertDialog(
          backgroundColor: dialogDark ? const Color(0xFF1F2937) : Colors.white,
          title: LocalizedLabel(
            text: 'logoutConfirmTitle'.tr(),
            style: TextStyles.blackBold20.copyWith(
              color: dialogDark ? Colors.white : const Color(0xFF111827),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: LocalizedLabel(
            text: 'logoutConfirmMessage'.tr(),
            style: TextStyles.blackRegular16.copyWith(
              color: dialogDark ? Colors.white70 : const Color(0xFF4B5563),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: LocalizedLabel(
                text: 'cancel',
                style: TextStyles.blackRegular16.copyWith(
                  color: dialogDark ? Colors.white70 : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor2,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: LocalizedLabel(
                text: 'yes',
                style: TextStyles.blackRegular16.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return SafeArea(
      child: Container(
        color: dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(dark: dark),
              Gap(context.responsiveValue(
                  mobile: 20.0, smallMobile: 14.0, tablet: 24.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ProfileStatCard(
                            value: '12',
                            label: 'orders'.tr(),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: ProfileStatCard(
                            value: '8',
                            label: 'wishlist'.tr(),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: ProfileStatCard(
                            value: '5',
                            label: 'reviews'.tr(),
                          ),
                        ),
                      ],
                    ),
                    const Gap(22),
                    Row(
                      children: [
                        Text(
                          'recentOrders'.tr(),
                          style: TextStyles.blackBold20.copyWith(
                            color:
                                dark ? Colors.white : const Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.push(AppRouter.myOrdersScreen),
                          child: Text(
                            'viewAll'.tr(),
                            style: TextStyles.blackRegular14.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    const Gap(12),
                    RecentOrderCard(
                      orderId: 'ORD123456',
                      itemCount: 2,
                      dateText: 'Apr 10, 2026',
                      amount: r'$527.04',
                      delivered: true,
                      icon: Icons.headphones_rounded,
                    ),
                    const Gap(10),
                    RecentOrderCard(
                      orderId: 'ORD123455',
                      itemCount: 1,
                      dateText: 'Apr 8, 2026',
                      amount: r'$299.00',
                      delivered: false,
                      icon: Icons.watch_rounded,
                    ),
                    const Gap(14),
                    Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF21283B)
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ProfileOptionTile(
                            icon: Icons.inventory_2_outlined,
                            titleKey: 'myOrders',
                            badgeText: '3',
                            onTap: () => context.push(AppRouter.myOrdersScreen),
                          ),
                          ProfileOptionTile(
                            icon: Icons.location_on_outlined,
                            titleKey: 'addresses',
                            onTap: () =>
                                context.push(AppRouter.addressesScreen),
                          ),
                          ProfileOptionTile(
                            icon: Icons.notifications_none_rounded,
                            titleKey: 'notifications',
                            onTap: () => context.push(AppRouter.notificationScreen),
                          ),
                          ProfileOptionTile(
                            icon: Icons.language,
                            titleKey: 'changeLanguage',
                            onTap: () => _toggleLanguageAndGoRoot(context),
                          ),
                          ProfileOptionTile(
                            icon: dark ? Icons.light_mode : Icons.dark_mode,
                            titleKey:
                                dark ? 'lightThemeMode' : 'darkThemeMode',
                            onTap: () => _toggleTheme(context),
                          ),
                          ProfileOptionTile(
                            icon: Icons.privacy_tip_outlined,
                            titleKey: 'privacyAndSecurity',
                            onTap: () => context
                                .push(AppRouter.privacyAndSecurityScreen),
                          ),
                          ProfileOptionTile(
                            icon: Icons.contact_support_outlined,
                            titleKey: 'helpAndSupport',
                            onTap: () =>
                                context.push(AppRouter.customerServiceScreen),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _showLogoutDialog(context),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFF6B6B), Color(0xFFE63946)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE63946)
                                    .withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: AppColors.whiteColor,
                                  size: 24,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: LocalizedLabel(
                                  text: 'logout',
                                  style: TextStyles.blackBold16.copyWith(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool dark;

  const _ProfileHeader({required this.dark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: context.responsiveValue(
            mobile: 50.0, smallMobile: 16.0, tablet: 30.0),
        bottom: context.responsiveValue(
            mobile: 34.0, smallMobile: 26.0, tablet: 42.0),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xFF3E4CC6), Color(0xFF2E63F6)]
              : const [Color(0xFF4653DE), Color(0xFF2E63F6)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zeyad Medhat'.tr(),
                  style: TextStyles.blackBold20.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                Text(
                  'zyadmedhat@gmail.com'.tr(),
                  style: TextStyles.blackRegular16.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
