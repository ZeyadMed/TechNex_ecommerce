
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/style/assets.dart';
import 'package:e_commerce/core/widgets/stateless/flexiable_image.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String image;
  const LogoWidget({
    super.key,
    this.image = Assets.assetsImagesLogtaDarkPng,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.responsiveValue(
          mobile: 54.0, smallMobile: 46.0, tablet: 60.0),
      width: context.responsiveValue(
          mobile: 54.0, smallMobile: 46.0, tablet: 60.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4C67FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: FlexibleImage(
          source: image,
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}