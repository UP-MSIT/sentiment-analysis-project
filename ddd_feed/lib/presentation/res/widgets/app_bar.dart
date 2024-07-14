import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../home/widgets/action_button.dart';
import '../colors/colors.dart';
import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.leading,
    this.onActionIconTap,
    this.title,
    this.actions,
    this.backgroundColor,
  }) : super(key: key);
  final Widget? leading;
  final void Function()? onActionIconTap;
  final String? title;
  final Widget? actions;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: leading ??
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
      actions: [
        actions ??
            ActionButton(
              heroIcons: HeroIcons.user,
              onTap: onActionIconTap,
              heroIconStyle: HeroIconStyle.outline,
            ),
      ],
      title: Text(title ?? 'CIRCLE', style: themeData.textTheme.titleLarge),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
