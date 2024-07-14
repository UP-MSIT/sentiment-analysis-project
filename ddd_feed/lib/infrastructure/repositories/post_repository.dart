import 'package:ddd_feed/domain/services/providers/auth_providers.dart';
import 'package:ddd_feed/domain/services/providers/post_providers.dart';
import 'package:ddd_feed/infrastructure/model/insight_model.dart';

import '../model/post_model_response.dart';

class PostRepository {
  final PostProviders providers;
  AuthProviders? authProviders;

  PostRepository(this.providers);

  Future<List<PostApiResponse>> getAllPosts() async {
    final posts = await providers.getAllPosts();
    return posts.map((post) => PostApiResponse.fromJson(post)).toList();
  }

  Future getPostDetail(String? postId) async {
    final posts = await providers.getPostDetail(postId);
    return PostApiResponse.fromJson(posts);
  }

  Future<bool> likePost(String? postId, {String? likeType}) async {
    return await providers.likePost(postId: postId, likeType: likeType);
  }

  Future<bool> createPost({String? description, String? mediaId}) async {
    return await providers.createPost(description: description, mediaId: mediaId);
  }

  Future<bool> commentPost({String? postId, String? comment}) async {
    return await providers.commentPost(postId: postId, comment: comment);
  }

  Future<bool> deletePost(String? postId) async {
    return await providers.deletePost(postId: postId);
  }

  Future getPostInsight({String? postId, String? chartType}) async {
    final data = await providers.getPostInsight(postId: postId, chartType: chartType);
    return InsightModel.fromJson(data);
  }
}
