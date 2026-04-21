import 'package:e_commerce/core/bloc/theme_bloc/theme_bloc.dart';
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/helpers/validators.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/stateful/custom_text_field.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/core/widgets/stateless/logo_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
	const ChangePasswordScreen({super.key});

	@override
	State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
	final TextEditingController passwordController = TextEditingController();
	final TextEditingController confirmPasswordController =
			TextEditingController();
	bool obscurePassword = true;
	bool obscureConfirmPassword = true;
	late final _formKey = GlobalKey<FormState>();

	@override
	void dispose() {
		passwordController.dispose();
		confirmPasswordController.dispose();
		super.dispose();
	}

	Future<void> _toggleLanguage(BuildContext context) async {
		final nextLocale = context.locale.languageCode == 'ar'
				? const Locale('en')
				: const Locale('ar');
		await context.setLocale(nextLocale);
	}

	void _toggleTheme(BuildContext context, {required bool isDark}) {
		context
				.read<ThemeBloc>()
				.add(ThemeChanged(isDark ? ThemeMode.light : ThemeMode.dark));
	}

	@override
	Widget build(BuildContext context) {
		final bool dark = context.isDarkMode;
		final EdgeInsets scrollPadding = EdgeInsets.symmetric(
			horizontal: context.responsiveValue(
					mobile: 20.0, smallMobile: 14.0, tablet: 28.0),
			vertical: context.responsiveValue(
					mobile: 16.0, smallMobile: 10.0, tablet: 24.0),
		);

		final double cardWidth = context.responsiveValue(
			mobile: double.infinity,
			tablet: 460.0,
		);

		return Scaffold(
			body: Container(
				decoration: const BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topCenter,
						end: Alignment.bottomCenter,
						colors: [Color(0xFF5F2BFF), Color(0xFF9A10F2), Color(0xFF2D6CFF)],
					),
				),
				child: SafeArea(
					child: Center(
						child: SingleChildScrollView(
							padding: scrollPadding,
							child: Form(
								key: _formKey,
								child: Container(
									width: cardWidth,
									padding: EdgeInsets.symmetric(
										horizontal: context.responsiveValue(
												mobile: 22.0, smallMobile: 14.0, tablet: 26.0),
										vertical: context.responsiveValue(
												mobile: 24.0, smallMobile: 16.0, tablet: 28.0),
									),
									decoration: BoxDecoration(
										color:
												dark ? AppColors.darkTextColor : AppColors.whiteColor,
										borderRadius: BorderRadius.circular(22),
									),
									child: Column(
										mainAxisSize: MainAxisSize.min,
										children: [
											// toggleThemeAndLanguage(context, dark),
											const Gap(14),
											const LogoWidget(),
											const Gap(16),
											Text(
												'changePassword'.tr(),
												style: TextStyles.blackBold32.copyWith(
													color: dark ? Colors.white : AppColors.blackColor,
													fontSize: context.responsiveValue(
															mobile: 34.0, smallMobile: 28.0, tablet: 38.0),
													fontWeight: FontWeight.w700,
												),
											),
											const Gap(8),
											Text(
												'setYourNewPassword'.tr(),
												textAlign: TextAlign.center,
												style: TextStyles.blackRegular14.copyWith(
													color: dark ? Colors.white70 : AppColors.greyColor,
													fontWeight: FontWeight.w400,
												),
											),
											const Gap(24),
											Customtextfield(
												hintText: 'newPassword',
												textEditingController: passwordController,
												validator: Validators.passwordValidator,
												prefix: Icon(
													Icons.lock_outline,
													color: dark ? Colors.white70 : AppColors.greyColor3,
													size: 20,
												),
												obscureText: obscurePassword,
												suffix: IconButton(
													onPressed: () {
														setState(() {
															obscurePassword = !obscurePassword;
														});
													},
													icon: Icon(
														obscurePassword
																? Icons.visibility_off_outlined
																: Icons.visibility_outlined,
														color: dark ? Colors.white70 : AppColors.greyColor3,
														size: 20,
													),
												),
											),
											const Gap(14),
											Customtextfield(
												hintText: 'confirmPassword',
												textEditingController: confirmPasswordController,
												validator: (value) => Validators.repeatPasswordValidator(
													value: value,
													Password: passwordController.text,
												),
												prefix: Icon(
													Icons.lock_outline,
													color: dark ? Colors.white70 : AppColors.greyColor3,
													size: 20,
												),
												obscureText: obscureConfirmPassword,
												suffix: IconButton(
													onPressed: () {
														setState(() {
															obscureConfirmPassword = !obscureConfirmPassword;
														});
													},
													icon: Icon(
														obscureConfirmPassword
																? Icons.visibility_off_outlined
																: Icons.visibility_outlined,
														color: dark ? Colors.white70 : AppColors.greyColor3,
														size: 20,
													),
												),
											),
											const Gap(14),
											CustomButton(
												title: 'changePassword',
												onPressed: () {
													if (_formKey.currentState?.validate() != true) return;
													context.go(AppRouter.login);
												},
												borderRadius: 14,
												padding: const EdgeInsets.symmetric(vertical: 14),
												gradient: const LinearGradient(
													begin: Alignment.centerLeft,
													end: Alignment.centerRight,
													colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
												),
												boxShadow: const [
													BoxShadow(
														color: Color(0x2E2D6CFF),
														blurRadius: 14,
														offset: Offset(0, 6),
													),
												],
												fontSize: context.responsiveValue(
													mobile: 20.0,
													smallMobile: 16.0,
													tablet: 22.0,
												),
												fontWeight: FontWeight.w700,
												trailingIcon: Icon(
													Icons.arrow_forward,
													color: AppColors.whiteColor,
													size: context.responsiveValue(
														mobile: 20.0,
														smallMobile: 16.0,
														tablet: 22.0,
													),
												),
												iconSpacing: 8,
											),
										],
									),
								),
							),
						),
					),
				),
			),
		);
	}

	Row toggleThemeAndLanguage(BuildContext context, bool dark) {
		return Row(
			children: [
				Expanded(
					child: OutlinedButton.icon(
						onPressed: () => _toggleLanguage(context),
						icon: Icon(
							Icons.language,
							size: 18,
							color: dark ? Colors.white70 : AppColors.darkTextColor,
						),
						label: Text(
							context.locale.languageCode == 'ar' ? 'AR' : 'EN',
							style: TextStyles.blackRegular14.copyWith(
								color: dark ? Colors.white : AppColors.darkTextColor,
								fontWeight: FontWeight.w600,
							),
						),
						style: OutlinedButton.styleFrom(
							side: BorderSide(
								color: dark ? Colors.white24 : Colors.grey.shade300,
							),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
					),
				),
				const Gap(10),
				Expanded(
					child: OutlinedButton.icon(
						onPressed: () => _toggleTheme(context, isDark: dark),
						icon: Icon(
							dark ? Icons.light_mode : Icons.dark_mode,
							size: 18,
							color: dark ? Colors.white70 : AppColors.darkTextColor,
						),
						label: Text(
							(dark ? 'lightMode' : 'darkMode').tr(),
							style: TextStyles.blackRegular14.copyWith(
								color: dark ? Colors.white : AppColors.darkTextColor,
								fontWeight: FontWeight.w600,
							),
						),
						style: OutlinedButton.styleFrom(
							side: BorderSide(
								color: dark ? Colors.white24 : Colors.grey.shade300,
							),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
					),
				),
			],
		);
	}
}
