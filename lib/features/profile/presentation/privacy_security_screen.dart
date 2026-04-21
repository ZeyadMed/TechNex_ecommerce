import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _biometric = true;
  bool _twoFactor = false;
  bool _personalizedAds = false;
  bool _activityStatus = true;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bg = dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9);
    final cardBg = dark ? const Color(0xFF1D2434) : AppColors.whiteColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: CustomAppBar(
        title: 'privacyAndSecurity',
        showBackButton: true,
        backgroundColor: bg,
      ),
      body: Column(
        children: [
          Divider(height: 1, color: dark ? Colors.white12 : const Color(0xFFE8ECF3)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield_rounded, color: Colors.white),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'accountProtection'.tr(),
                              style: TextStyles.blackBold16.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'accountProtectionSub'.tr(),
                              style: TextStyles.blackRegular14.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(14),
                _SectionTitle(title: 'securityOptions'.tr()),
                const Gap(8),
                _SwitchTile(
                  icon: Icons.fingerprint,
                  title: 'biometricLogin'.tr(),
                  subtitle: 'biometricLoginSub'.tr(),
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                ),
                const Gap(10),
                _SwitchTile(
                  icon: Icons.verified_user_outlined,
                  title: 'twoFactorAuth'.tr(),
                  subtitle: 'twoFactorAuthSub'.tr(),
                  value: _twoFactor,
                  onChanged: (v) => setState(() => _twoFactor = v),
                ),
                const Gap(10),
                _ActionTile(
                  icon: Icons.lock_reset_rounded,
                  title: 'changePassword'.tr(),
                  subtitle: 'changePasswordQuick'.tr(),
                  onTap: () {},
                ),
                const Gap(14),
                _SectionTitle(title: 'privacyControls'.tr()),
                const Gap(8),
                _SwitchTile(
                  icon: Icons.ads_click_outlined,
                  title: 'personalizedAds'.tr(),
                  subtitle: 'personalizedAdsSub'.tr(),
                  value: _personalizedAds,
                  onChanged: (v) => setState(() => _personalizedAds = v),
                ),
                const Gap(10),
                _SwitchTile(
                  icon: Icons.visibility_outlined,
                  title: 'showActivityStatus'.tr(),
                  subtitle: 'showActivityStatusSub'.tr(),
                  value: _activityStatus,
                  onChanged: (v) => setState(() => _activityStatus = v),
                ),
                const Gap(10),
                _ActionTile(
                  icon: Icons.description_outlined,
                  title: 'privacyPolicyTitle'.tr(),
                  subtitle: 'viewLearnHowDataUsed'.tr(),
                  onTap: () {},
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'activeSessions'.tr(),
                        style: TextStyles.blackBold16.copyWith(
                          color: dark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        'activeSessionsSub'.tr(),
                        style: TextStyles.blackRegular14.copyWith(
                          color: dark ? Colors.white70 : const Color(0xFF667085),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(12),
                      CustomButton(
                        title: 'logoutAllDevices',
                        onPressed: () {},
                        borderRadius: 12,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor:
                            dark ? const Color(0xFF332B2B) : const Color(0xFFFFF1F1),
                        textColor: const Color(0xFFD92D20),
                        borderColor: const Color(0xFFFDA29B),
                      ),
                    ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Text(
      title,
      style: TextStyles.blackBold16.copyWith(
        color: dark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1D2434) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF2C3550) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.blackBold16.copyWith(
                    color: dark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1D2434) : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF2C3550) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.blackBold16.copyWith(
                        color: dark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: TextStyles.blackRegular14.copyWith(
                        color: dark ? Colors.white70 : const Color(0xFF667085),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: dark ? Colors.white54 : const Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
