import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.title,
      this.bottom,
      this.actions,
      this.leading,
      this.backgroundColor,
      this.titleStyle,
      this.iconColor,
      this.centerTitle = false,
      this.translateTitle = true,
      this.showBackButton = false,
      this.onBackPressed,
      this.elevation = 0,
      this.surfaceTintColor = Colors.transparent});
  final String? title;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool translateTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double elevation;
  final Color surfaceTintColor;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget? resolvedLeading = leading ??
        (showBackButton && Navigator.canPop(context)
            ? IconButton(
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: iconColor ??
                      (isDark ? AppColors.whiteColor : const Color(0xFF111827)),
                ),
              )
            : null);

    return AppBar(
      title: Text(
        translateTitle ? (title ?? 'notFound').tr() : (title ?? ''),
        style: titleStyle ??
            TextStyles.blackBold20.copyWith(
              color: isDark ? AppColors.whiteColor : const Color(0xFF111827),
              fontWeight: FontWeight.w700,
            ),
      ),
      backgroundColor:
          backgroundColor ?? (isDark ? const Color(0xFF111827) : AppColors.whiteColor),
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      centerTitle: centerTitle,
      bottom: bottom,
      actions: actions,
      leading: resolvedLeading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
