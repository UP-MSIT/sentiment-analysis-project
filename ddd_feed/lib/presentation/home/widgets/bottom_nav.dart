import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

import '../../res/constants/app_sizes.dart';
import '../posts/create_post_page.dart';
import 'action_button.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentIndex, required this.onPressed});

  final int currentIndex;
  final void Function(int index)? onPressed;

  @override
  Widget build(BuildContext context) {
    List bottomNavBarItems = [
      {
        'index': 0,
        'label': 'Home',
        'icon': HeroIcons.rectangleStack,
      },
      {
        'index': 1,
        'label': 'Post',
        'icon': HeroIcons.pencilSquare,
      }
    ];

    return Container(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      // color: Colors.red,
      alignment: Alignment.center,
      height: 90,
      child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: bottomNavBarItems
              .map(
                (item) => Expanded(
                  child: ActionButton(
                    onTap: () {
                      item['index'] == 1
                          ? Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) => CreatePostPage(),
                            ))
                              .then((value) {
                              // get all posts
                              BlocProvider.of<PostsCubit>(context).getAllPosts();
                            })
                          : onPressed?.call(item['index']);
                    },
                    heroIcons: item['icon'],
                    label: item['label'],
                    heroIconStyle: currentIndex == bottomNavBarItems.indexOf(item) ? HeroIconStyle.solid : HeroIconStyle.outline,
                  ),
                ),
              )
              .toList()),
    );
  }
}
