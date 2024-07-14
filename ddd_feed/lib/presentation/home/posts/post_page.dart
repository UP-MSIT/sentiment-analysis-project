import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:ddd_feed/domain/services/providers/auth_providers.dart';
import 'package:ddd_feed/infrastructure/model/post_model_response.dart';
import 'package:ddd_feed/infrastructure/model/user_info.dart';
import 'package:ddd_feed/presentation/auth/login/login.dart';
import 'package:ddd_feed/presentation/home/user_profile_page.dart';
import 'package:ddd_feed/presentation/res/colors/colors.dart';
import 'package:ddd_feed/presentation/res/widgets/app_bar.dart';
import 'package:ddd_feed/presentation/home/posts/post_detail_page.dart';
import 'package:ddd_feed/presentation/home/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  UserInfo? userInfo;
  final AuthProviders providers = AuthProviders();

  @override
  void initState() {
    BlocProvider.of<PostsCubit>(context).getAllPosts();
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const SizedBox(),
        onActionIconTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UserProfilePage(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(child: _postList()),
    );
  }

  Widget _postList() {
    List<PostApiResponse>? posts = [];
    return BlocConsumer<PostsCubit, PostsState>(
      listener: (_, __) {},
      builder: (context, state) {
        if (state is PostsLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is PostsLoaded) {
          posts = (state).posts;
          EasyLoading.dismiss();
          return (posts!.isEmpty) ? _buildEmptyData() : _buildBody(posts: posts);
        } else if (state is LikePostLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is LikePostSuccess) {
          EasyLoading.dismiss();
          BlocProvider.of<PostsCubit>(context).getAllPosts();
        } else if (state is LikePostError) {
          EasyLoading.dismiss();
          SnackBarUtil.showInSnackBar('${state.message}');
        } else if (state is DeletePostLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is DeletePostSuccess) {
          EasyLoading.dismiss();
          BlocProvider.of<PostsCubit>(context).getAllPosts();
        } else if (state is DeletePostError) {
          EasyLoading.dismiss();
          SnackBarUtil.showInSnackBar('${state.message}');
        }

        return (posts!.isEmpty) ? _buildEmptyData() : _buildBody(posts: posts);
      },
    );
  }

  _buildBody({List<PostApiResponse>? posts}) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<PostsCubit>(context).getAllPosts();
      },
      color: AppColors.white,
      child: ListView.builder(
        itemCount: posts?.length,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          final post = posts?[index];
          final postId = posts?[index].id.toString();
          return GestureDetector(
            onTap: () => _pushDetailPage(postId),
            child: PostItem(
              post: post,
              userType: userInfo?.type,
              onLikeTap: () {
                BlocProvider.of<PostsCubit>(context).likePost(postId,likeType: 'LIKE');
              },
              onCommentTap: () => _pushDetailPage(postId),
            ),
          );
        },
      ),
    );
  }

  _pushDetailPage(postId) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PostDetailPage(
                  postId: postId,
                  userType: userInfo?.type,
                )))
        .then((value) {
      BlocProvider.of<PostsCubit>(context).getAllPosts();
    });
  }

  _buildEmptyData() {
    return const Center(child: Text('No data'));
  }

  void _getUser() async {
    providers.getCurrentUser().then((posts) {
      if (posts != null) {
        userInfo = UserInfo.fromJson(posts);
        setState(() {});
      }
    });
    print('object: ${userInfo?.toJson()}');
  }
}
