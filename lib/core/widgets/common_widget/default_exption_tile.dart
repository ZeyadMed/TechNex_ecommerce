import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';

class DefaultExpansionTile extends StatefulWidget {
  final String name;
  final String image;
  final List? options;
  final List<Widget>? optionsWidget;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double radius;
  final bool initiallyExpanded;

  const DefaultExpansionTile(
      {super.key,
      required this.name,
      this.image = '',
      this.options,
      this.onTap,
      this.optionsWidget,
      this.backgroundColor,
      this.iconColor,
      this.textColor,
      this.radius = 0,
      this.initiallyExpanded = false});

  @override
  State<DefaultExpansionTile> createState() => _DefaultExpansionTileState();
}

class _DefaultExpansionTileState extends State<DefaultExpansionTile> {
  bool isOpen = false;
  int? isSelected;
  String lastChoice = '';

  bool get _usesDefaultPrimaryHeader => widget.backgroundColor == null;

  Color get _resolvedHeaderTextColor {
    if (_usesDefaultPrimaryHeader) {
      return Colors.white;
    }
    return widget.textColor ?? AppColors.blackColor;
  }

  Color get _resolvedHeaderIconColor {
    if (_usesDefaultPrimaryHeader) {
      return Colors.white;
    }
    return widget.iconColor ?? AppColors.greyColor3;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
        collapsedTextColor: _resolvedHeaderTextColor,
        textColor: _resolvedHeaderTextColor,
        initiallyExpanded: widget.initiallyExpanded,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: !isOpen
                ? const BorderSide(color: Colors.grey, width: 0.5)
                : BorderSide.none),
        backgroundColor: widget.backgroundColor ?? AppColors.primaryColor,
        collapsedBackgroundColor:
            widget.backgroundColor ?? AppColors.primaryColor,
        iconColor: _resolvedHeaderIconColor,
        collapsedIconColor: _resolvedHeaderIconColor,
        onExpansionChanged: (value) {
          setState(() {
            isOpen = value;
          });
        },
        leading: widget.image.isEmpty ? null : _leading(),
        title: _title(),
        // Wrap the expanded body in a white container so children appear on white
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.radius),
                bottomRight: Radius.circular(widget.radius),
              ),
            ),
            child: Column(
              children: widget.optionsWidget ?? options(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _leading() {
    return Image.network(
      widget.image,
      width: 30.w,
      height: 30.h,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: 30.w,
        height: 30.w,
      ),
    );
  }

  Widget _title() {
    return Text(
      widget.name,
      style: TextStyles.blackBold12.copyWith(
        fontSize: 15.sp,
        color: _resolvedHeaderTextColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  options(BuildContext context) => List.generate(
        (widget.options ?? []).length,
        (index) {
          return InkWell(
            onTap: () {
              widget.onTap?.call(index);
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                border: Border.all(color: AppColors.greyColor.withOpacity(.5)),
              ),
              child: Text(
                (widget.options ?? [])[index],
                style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.lightTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      );
}
