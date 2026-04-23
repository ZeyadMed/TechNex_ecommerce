import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/widgets/common_widget/carousel_slider_widget.dart';
import 'package:flutter/material.dart';

class HomeBannerCarousel extends StatelessWidget {
  final List<String> banners;

  const HomeBannerCarousel({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    final double height = context.responsiveValue(mobile: 180.0, smallMobile: 160.0, tablet: 220.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: CarouselSliderWidget(
        height: height,
        autoPlay: true,
        widgets: banners
            .map(
              (assetPath) => ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
