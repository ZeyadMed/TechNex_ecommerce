import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/core/widgets/common_widget/default_exption_tile.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<({String qKey, String aKey})> _faqItems = const [
    (qKey: 'faqTrackOrderQ', aKey: 'faqTrackOrderA'),
    (qKey: 'faqReturnPolicyQ', aKey: 'faqReturnPolicyA'),
    (qKey: 'faqShippingTimeQ', aKey: 'faqShippingTimeA'),
    (qKey: 'faqChangePasswordQ', aKey: 'faqChangePasswordA'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@shoplux.com',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openPhoneDialer() async {
    final uri = Uri.parse('tel:18007467589');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final bg = dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9);
    final cardBg = dark ? const Color(0xFF1D2434) : AppColors.whiteColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: CustomAppBar(
        title: 'helpAndSupport',
        showBackButton: true,
        backgroundColor: bg,
      ),
      body: Column(
        children: [
          Divider(
              height: 1,
              color: dark ? Colors.white12 : const Color(0xFFE8ECF3)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _ContactCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'liveChat'.tr(),
                  subtitle: 'liveChatSub'.tr(),
                  iconColor: Colors.purple,
                  onTap: () {},
                ),
                const Gap(10),
                _ContactCard(
                  icon: Icons.email_outlined,
                  title: 'email'.tr(),
                  subtitle: 'support@shoplux.com',
                  onTap: _openEmail,
                  iconColor: AppColors.primaryColor,
                ),
                const Gap(10),
                _ContactCard(
                  icon: Icons.phone_outlined,
                  title: 'phone'.tr(),
                  subtitle: '1-800-SHOPLUX',
                  onTap: _openPhoneDialer,
                  iconColor: AppColors.lightGreenColor,
                ),
                const Gap(22),
                Text(
                  'frequentlyAskedQuestions'.tr(),
                  style: TextStyles.blackBold20.copyWith(
                    color: dark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(12),
                ..._faqItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DefaultExpansionTile(
                      name: item.qKey.tr(),
                      radius: 14,
                      backgroundColor: cardBg,
                      expandedBodyColor:
                          dark ? const Color(0xFF1D2434) : Colors.white,
                      textColor: dark ? Colors.white : const Color(0xFF111827),
                      iconColor:
                          dark ? Colors.white54 : const Color(0xFF98A2B3),
                      optionsWidget: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                          child: Text(
                            item.aKey.tr(),
                            style: TextStyles.blackRegular14.copyWith(
                              color: dark ? Colors.white : const Color(0xFF667085),
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(14),
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
                        'sendUsMessage'.tr(),
                        style: TextStyles.blackBold20.copyWith(
                          color: dark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(14),
                      _MessageField(
                        controller: _nameController,
                        hint: 'yourName'.tr(),
                      ),
                      const Gap(10),
                      _MessageField(
                        controller: _emailController,
                        hint: 'emailAddress'.tr(),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Gap(10),
                      _MessageField(
                        controller: _messageController,
                        hint: 'howCanHelpYou'.tr(),
                        maxLines: 4,
                      ),
                      const Gap(14),
                      CustomButton(
                        title: 'sendMessage',
                        onPressed: () {},
                        borderRadius: 14,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                        ),
                        textColor: Colors.white,
                        fontWeight: FontWeight.w700,
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1D2434) : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor ?? AppColors.primaryColor),
              ),
              const Gap(12),
              Text(
                title,
                style: TextStyles.blackBold20.copyWith(
                  color: dark ? Colors.white : const Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(4),
              Text(
                subtitle,
                style: TextStyles.blackRegular16.copyWith(
                  color: dark ? Colors.white70 : const Color(0xFF667085),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyles.blackRegular16.copyWith(
        color: dark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.blackRegular16.copyWith(
          color: dark ? Colors.white54 : const Color(0xFF98A2B3),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: dark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 14 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: dark ? Colors.white24 : const Color(0xFFD0D5DD),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: dark ? Colors.white24 : const Color(0xFFD0D5DD),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
