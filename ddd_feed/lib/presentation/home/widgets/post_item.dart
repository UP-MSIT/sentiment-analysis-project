import 'package:cached_network_image/cached_network_image.dart';
import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:ddd_feed/infrastructure/model/post_model_response.dart';
import 'package:ddd_feed/domain/services/api_client.dart';
import 'package:ddd_feed/infrastructure/model/user_info.dart';
import 'package:ddd_feed/presentation/home/insight_page.dart';
import 'package:ddd_feed/presentation/home/user_profile_page.dart';
import 'package:ddd_feed/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';

import '../../res/colors/colors.dart';
import '../../res/constants/app_sizes.dart';
import '../../res/theme/theme.dart';
import 'action_button.dart';

import 'package:dio/dio.dart' as dio;

class PostItem extends StatelessWidget {
  PostItem({
    Key? key,
    this.post,
    this.onLikeTap,
    this.onCommentTap,
    this.userType,
  }) : super(key: key);

  final PostApiResponse? post;
  final void Function()? onLikeTap;
  final void Function()? onCommentTap;
  final String? userType;
  ApiClient api = ApiClient();

  @override
  Widget build(BuildContext context) {
    print('userType: $userType');
    return Container(
      width: width(context),
      margin: const EdgeInsets.only(bottom: AppSizes.xsm),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
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
                  size: AppSizes.md,
                ),
                Space.vXSM(context),
                Text(
                  '${post?.createdUser?.name}',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(Utils.parseDateToLocal(post?.createdDate), style: themeData.textTheme.bodySmall),

                /// If login as USER can't delete POST, but PAGE can
                (userType == 'USER')
                    ? const SizedBox()
                    : IconButton(
                        alignment: Alignment.centerLeft,
                        iconSize: 28,
                        icon: const Icon(Icons.delete),
                        color: AppColors.red,
                        onPressed: () {
                          BlocProvider.of<PostsCubit>(context).deletePost(post?.id.toString());
                        },
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: Text(
              '${post?.description}',
              style: themeData.textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: post?.medias?.length ?? 0,
              itemBuilder: (context, index) {
                final media = post!.medias![index];
                final imageUrl = BASE_URL + media.filename;
                return FutureBuilder(
                  future: _isValidImageUrl(imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.data as bool) {
                      return _buildImageWidget(imageUrl, context);
                    } else {
                      return const SizedBox(width: 0, height: 0);
                    }
                  },
                );
              },
            ),
          ),

          // if (post?.medias != null && post!.medias!.isNotEmpty) ...post!.medias!.map((e) => _buildImageWidget(BASE_URL + e.filename, context)),
          Space.hXSM(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  label: 'Comments (${post?.postComments?.length.toString()})',
                  heroIcons: HeroIcons.chatBubbleLeft,
                  heroIconStyle: HeroIconStyle.outline,
                  onTap: onCommentTap,
                ),
                ActionButton(
                  label: "Like (${post?.postLikes?.length.toString()})",
                  heroIcons: HeroIcons.heart,
                  heroIconStyle: /*post.liked ? HeroIconStyle.solid : */ HeroIconStyle.outline,
                  // color: post.liked ? AppColors.red : null,
                  onTap: onLikeTap,
                ),
                userType == 'PAGE'
                    ? ActionButton(
                        label: 'Insight',
                        heroIcons: HeroIcons.chartBar,
                        heroIconStyle: /*post.bookmarked ? HeroIconStyle.solid : */ HeroIconStyle.outline,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InsightPage(postId: post?.id.toString()),
                            ),
                          );
                        }, // TODO, Navigation to InsightsPage
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Space.hXSM(context),
        ],
      ),
    );
  }

  _isValidImageUrl(String? url) async {
    Response response = await api.dio.get(url ?? '');
    if (url == null) return false;
    return response.statusCode == 200 || url.toLowerCase().startsWith('http://') || url.toLowerCase().startsWith('https://');
  }

  _buildImageWidget(filename, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: CachedNetworkImage(
        imageUrl: filename,
        placeholder: (context, url) => Center(child: Icon(Icons.image, size: 50, color: Colors.grey[600])),
        errorWidget: (context, url, error) => _errorWidget(),
        height: 220,
        width: width(context),
        fit: BoxFit.cover,
      ),
    );
  }

  _errorWidget() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.image, size: 50, color: Colors.grey[600]),
          const SizedBox(height: 10),
          Text(
            'No available image',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
