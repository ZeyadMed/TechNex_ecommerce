import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/widgets.dart';
import 'package:e_commerce/features/profile/presentation/models/track_order_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TrackOrderTimelineCard extends StatelessWidget {
  final List<TrackOrderTimelineStep> steps;

  const TrackOrderTimelineCard({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: 0.16) : const Color(0x100F172A),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'trackingHistory'.tr(),
            style: TextStyles.blackBold20.copyWith(
              color: dark ? Colors.white : const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          for (int index = 0; index < steps.length; index++)
            _TimelineRow(
              step: steps[index],
              isLast: index == steps.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TrackOrderTimelineStep step;
  final bool isLast;

  const _TimelineRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDarkMode;
    final Color activeColor = const Color(0xFF3B46F6);
    final Color inactiveColor = dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB);
    final Color textColor = step.active
        ? (dark ? Colors.white : const Color(0xFF111827))
        : (dark ? Colors.white60 : const Color(0xFF98A2B3));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.active ? activeColor : inactiveColor.withValues(alpha: dark ? 0.2 : 0.35),
                ),
                child: Icon(
                  step.icon,
                  color: step.active ? Colors.white : (dark ? Colors.white54 : const Color(0xFF98A2B3)),
                  size: 22,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 34,
                  color: step.active ? activeColor : inactiveColor,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title.tr(),
                  style: TextStyles.blackBold16.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                LocalizedLabel(
                text:   step.subtitle,
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : const Color(0xFF475467),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step.timeText,
                  style: TextStyles.blackRegular12.copyWith(
                    color: dark ? Colors.white54 : const Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
