import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/service_locator/service_locator.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class BottomNavApp extends StatefulWidget {
  const BottomNavApp({super.key});

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int _selectedIndex = 2;
  DateTime? _lastBackPressed;
  List<Widget> _pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    getIt<Dio>().options.headers['Accept-Language'] = 'ar';
    // AppRouter.router.configuration.navigatorKey.currentContext?.isArabic ??
    //         true
    //     ? 'ar'
    //     : 'en';
    super.initState();
    _initializePages();
  }

  Future<void> _initializePages() async {
    // final prefs = await SharedPreferences.getInstance();
    // bool isGuestMode = prefs.getBool('isGuestMode') ?? true;
    setState(() {
      // Ensure we have one page per bottom nav item (4 items)
      _pages = [];

      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 2) {
      setState(() {
        _selectedIndex = 2;
      });
      return false;
    } else {
      final now = DateTime.now();
      if (_lastBackPressed == null ||
          now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
        _lastBackPressed = now;
        context.showTopSnackBar(
          message: "pressAgain".tr(),
        );
        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Remove the following lines as prefs should not be fetched synchronously in build
    // final prefs = SharedPreferences.getInstance();
    // bool isMerchant = prefs.getBool('isMerchant') ?? false;

    // Instead, use _initializePages to set up _pages and loading state, including isMerchant
    // Use _pages and _isLoading as already handled in the state

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
        // Custom bottom navigation bar to allow an elevated selected icon
        bottomNavigationBar: Container(
          color: context.isDarkMode ? const Color(0xFF171B2C) : Colors.white,
          padding: EdgeInsets.only(bottom: 8.h, left: 12.w, right: 12.w),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                // mapping assets and labels per index
                final selectedAssets = [];
                final unselectedAssets = [];
                final labels = [
                  'myJobs'.tr(),
                  'categories'.tr(),
                  'home'.tr(),
                  'reports'.tr(),
                  'settings'.tr()
                ];

                final isSelected = _selectedIndex == index;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onItemTapped(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated elevated circular icon for selected item
                        Transform.translate(
                          offset: Offset(0, isSelected ? -18.h : 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            width: isSelected ? 50.w : 40.w,
                            height: isSelected ? 50.w : 40.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.22),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              isSelected
                                  ? selectedAssets[index]
                                  : unselectedAssets[index],
                              width: isSelected ? 30.w : 25.w,
                              height: isSelected ? 30.w : 25.w,
                              // colorize selected icon white inside the colored circle
                              color: isSelected
                                  ? Colors.white
                                  : (context.isDarkMode
                                      ? Colors.white70
                                      : AppColors.greyColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: isSelected
                              ? TextStyles.blackBold14.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                )
                              : TextStyles.blackBold14.copyWith(
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                          child: Text(
                            labels[index],
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
