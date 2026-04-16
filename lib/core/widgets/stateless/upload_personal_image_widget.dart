import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/style/assets.dart';

class UploadPersonalImageWidget extends StatelessWidget {
  const UploadPersonalImageWidget({
    super.key,
    this.onTap,
    this.image,
    this.initialImageUrl,
    this.title,
  });

  final void Function()? onTap;
  final File? image;
  final String? initialImageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          color: Color(0xffebedf0),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: image != null
              ? Image.file(
                  image!,
                  fit: BoxFit.cover,
                  width: 100.w,
                  height: 100.h,
                )
              : initialImageUrl != null
                  ? Image.network(
                      initialImageUrl!,
                      fit: BoxFit.cover,
                      width: 100.w,
                      height: 100.h,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Image.asset(
                          Assets.assetsImagesUpload,
                          width: 35.w,
                          height: 35.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset(
                        Assets.assetsImagesUpload,
                        width: 35.w,
                        height: 35.h,
                        fit: BoxFit.contain,
                      ),
                    ),
        ),
      ),
    );
  }
}
