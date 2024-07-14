import 'package:ddd_feed/presentation/home/posts/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../res/constants/app_sizes.dart';
import '../../res/theme/theme.dart';
import 'app_buttons.dart';

class EmptyFeed extends StatelessWidget {
  const EmptyFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Posts Yet",
            style: themeData.textTheme.displaySmall,
          ),
          Space.hXSM(context),
          AppButton(
            child: Text(
              "Create Posts",
              style: themeData.textTheme.displaySmall,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePostPage())).then((value) {
                // context.read<PostsBloc>().add(GetPosts());
              });
              // context.read<PostsBloc>().add(GenerateInitPosts());
            },
          ),
        ],
      ),
    );
  }
}
