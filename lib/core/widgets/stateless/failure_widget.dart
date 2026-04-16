import 'package:flutter/material.dart';
import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/style/assets.dart';
import 'package:e_commerce/core/theme/theme.dart';
import 'package:e_commerce/core/widgets/widgets.dart';

class FailureWidget<T> extends StatelessWidget {
  final RefreshCallback? onRefresh;
  final Future<void> Function()? onRetry;
  final String errorMessage;

  const FailureWidget({
    super.key,
    this.onRefresh,
    this.onRetry,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return onRefresh == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.assetsSvgFailure,
                  width: 75,
                  height: 75,
                ),
                const SizedBox(height: 16),
                LocalizedLabel(
                  text: errorMessage,
                  style: AppTextTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  Gaps.v(12),
                  ElevatedButton(
                    onPressed: () async => await onRetry!(),
                    child: LocalizedLabel(
                      text: 'Retry',
                      style: AppTextTheme.bodyMedium,
                    ),
                  ),
                ],
              ],
            ),
          )
        : Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Label(
                      text: errorMessage,
                      textAlign: TextAlign.center,
                    ),
                    if (onRetry != null) ...[
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () async => await onRetry!(),
                        child: LocalizedLabel(
                          text: 'Retry',
                          style: AppTextTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: RefreshIndicator(
                  color: context.isDarkMode
                      ? HexColor.darkPrimaryColor
                      : HexColor.primaryColor,
                  displacement: 50,
                  edgeOffset: 50,
                  strokeWidth: 3,
                  onRefresh: onRefresh!,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: context.screenHeight,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
