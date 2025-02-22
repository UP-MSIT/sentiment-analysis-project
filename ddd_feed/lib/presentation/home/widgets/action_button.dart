import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';

import '../../res/colors/colors.dart';
import '../../res/constants/app_sizes.dart';
import '../../res/theme/theme.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.label,
    required this.heroIcons,
    required this.heroIconStyle,
    this.color,
    this.onTap,
  }) : super(key: key);

  final String? label;
  final HeroIcons heroIcons;
  final HeroIconStyle heroIconStyle;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.xsm),
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              heroIcons,
              style: heroIconStyle,
              color: color ?? AppColors.greyDark,
              size: AppSizes.lg,
            ),
            if (label != null) ...[
              Space.vXSM(context),
              Text(
                label!,
                style: themeData.textTheme.bodySmall,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
