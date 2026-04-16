import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:e_commerce/core/cache_manager/cache_manager.dart';
import 'package:e_commerce/core/config/brand/brand_config.dart';
import 'package:e_commerce/core/router/app_router.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/common_widget/segmented_circular_indicator.dart';
import 'package:e_commerce/core/widgets/widgets.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "buy_sell_title".tr(),
      "description": "buy_sell_subtitle".tr(),
      "image": BrandConfig.current.assets.onboardingPrimaryImage,
    },
    {
      "title": "post_fast_title".tr(),
      "description": "post_fast_subtitle".tr(),
      "image": BrandConfig.current.assets.onboardingSecondaryImage,
    },
    {
      "title": "chat_secure_title".tr(),
      "description": "chat_secure_subtitle".tr(),
      "image": BrandConfig.current.assets.onboardingPrimaryImage,
    },
    {
      "title": "trusted_transactions_title".tr(),
      "description": "trusted_transactions_subtitle".tr(),
      "image": BrandConfig.current.assets.onboardingSecondaryImage,
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      CacheManager().saveData(key: "hasSeenOnboarding", value: true);
      AppRouter.router.go(AppRouter.signUp);
    }
  }

  void _skipToEnd() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.animateToPage(
        onboardingData.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      CacheManager().saveData(key: "hasSeenOnboarding", value: true);
      AppRouter.router.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40, top: 50.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                ),
                                child: Image.asset(
                                  onboardingData[index]["image"]!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 40.0, right: 40.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        onboardingData[index]["title"]!.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.darkBold20.copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Gap(10.h),
                                    Flexible(
                                      child: Text(
                                        onboardingData[index]["description"]!
                                            .tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.blackRegular16,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              // segmented circular indicator in a row with skip/login label
              Row(
                children: [
                  SegmentedCircularIndicator(
                    currentIndex: _currentPage,
                    itemCount: onboardingData.length,
                    size: 70.w,
                    strokeWidth: 8.w,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: AppColors.primaryColor.withOpacity(0.15),
                    onTap: _nextPage,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _skipToEnd,
                    child: LocalizedLabel(
                      text: _currentPage == onboardingData.length - 1
                          ? 'login'.tr()
                          : 'skip'.tr(),
                      color: AppColors.blackColor,
                      style: TextStyles.darkRegular14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Gap(40.h),
            ],
          ),
        ),
      ),
    );
  }
}
