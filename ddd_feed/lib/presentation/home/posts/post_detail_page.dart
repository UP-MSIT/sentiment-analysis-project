import 'dart:developer';

import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:ddd_feed/infrastructure/model/post_model_response.dart';
import 'package:ddd_feed/presentation/auth/login/login.dart';
import 'package:ddd_feed/presentation/components/text_form_builder.dart';
import 'package:ddd_feed/presentation/res/constants/app_sizes.dart';
import 'package:ddd_feed/presentation/res/theme/theme.dart';
import 'package:ddd_feed/presentation/res/widgets/app_bar.dart';
import 'package:ddd_feed/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:heroicons/heroicons.dart';
import 'package:ionicons/ionicons.dart';

import '../../res/colors/colors.dart';
import '../widgets/post_item.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key, this.postId, this.userType}) : super(key: key);
  final String? postId;
  final String? userType;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final commentCtl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<PostsCubit>(context).getPostDetail(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(child: _buildPostWidget()),
            const SizedBox(height: 20),
            _textInputField(),
          ],
        ),
      ),
      appBar: const CustomAppBar(),
      // bottomNavigationBar: _textInputField(),
    );
  }

  _buildPostWidget() {
    PostApiResponse? post;
    return BlocConsumer<PostsCubit, PostsState>(
      listener: (_, __) {},
      builder: (BuildContext context, state) {
        if (state is PostsDetailLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is PostDetailLoaded) {
          post = (state).posts;
          _buildBody(post: post);
          EasyLoading.dismiss();
        } else if (state is LikePostLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is LikePostSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            EasyLoading.dismiss();
            BlocProvider.of<PostsCubit>(context).getPostDetail(widget.postId);
          });
        } else if (state is LikePostError) {
          EasyLoading.dismiss();
          SnackBarUtil.showInSnackBar('${state.message}');
        } else if (state is CommentPostLoading) {
          // LoadingUtil.showLoading(context);
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is CommentPostSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            EasyLoading.dismiss();
            commentCtl.clear();
            FocusScope.of(context).unfocus();
            BlocProvider.of<PostsCubit>(context).getPostDetail(widget.postId);
          });
        } else if (state is CommentPostError) {
          EasyLoading.dismiss();
          SnackBarUtil.showInSnackBar('${state.message}');
        } else if (state is DeletePostLoading) {
          EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
        } else if (state is DeletePostSuccess) {
          EasyLoading.dismiss();
          BlocProvider.of<PostsCubit>(context).getPostDetail(widget.postId);
        } else if (state is DeletePostError) {
          EasyLoading.dismiss();
          SnackBarUtil.showInSnackBar('${state.message}');
        }

        return _buildBody(post: post);
      },
    );
  }

  _buildBody({PostApiResponse? post}) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<PostsCubit>(context).getPostDetail(widget.postId);
      },
      backgroundColor: AppColors.greyDark,
      color: AppColors.white,
      child: (post != null && post.postComments != null)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  PostItem(
                    userType: widget.userType,
                    post: post,
                    onLikeTap: () {
                      BlocProvider.of<PostsCubit>(context).likePost(widget.postId, likeType: 'LIKE');
                    },
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      // log('message${post?.postComments?[index]}');
                      return CommentList(postComments: post.postComments?[index]);
                    },
                    itemCount: post.postComments?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  _textInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.transparent,
      height: 70,
      child: TextFormBuilder(
        hintText: 'Type a comment',
        controller: commentCtl,
        suffix: IconButton(
          icon: const Icon(Ionicons.send),
          onPressed: () {
            if (commentCtl.text.isEmpty) {
              SnackBarUtil.showInSnackBar('Type a comment', context: context);
            } else {
              BlocProvider.of<PostsCubit>(context).commentPost(
                postId: widget.postId,
                comment: commentCtl.text,
              );
            }
          },
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  const CommentList({super.key, this.postComments});

  final Post? postComments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xsm,
          ),
          child: Row(
            children: [
              HeroIcon(
                HeroIcons.userCircle,
                style: HeroIconStyle.solid,
                color: AppColors.greyDark,
                size: AppSizes.xlg,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${postComments?.createdUser?.name}',
                    style: themeData.textTheme.bodyMedium,
                  ),
                  Text(
                    Utils.parseDateToLocal('${postComments?.createdDate}'),
                    style: themeData.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.xlg),
          child: Text(
            '${postComments?.comment}',
            style: themeData.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
