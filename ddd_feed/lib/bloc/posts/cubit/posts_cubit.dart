import 'package:bloc/bloc.dart';
import 'package:ddd_feed/infrastructure/model/insight_model.dart';
import 'package:ddd_feed/infrastructure/model/post_model_response.dart';
import 'package:ddd_feed/infrastructure/model/profile_upload_response.dart';
import 'package:ddd_feed/infrastructure/repositories/auth_repository.dart';
import 'package:ddd_feed/infrastructure/repositories/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostRepository postRepository;
  final AuthRepository authRepository;

  PostsCubit({required this.postRepository, required this.authRepository}) : super(PostsInitial());

  void getAllPosts() {
    emit(PostsLoading());
    postRepository.getAllPosts().then((posts) {
      emit(PostsLoaded(posts: posts));
    });
  }

  void getPostDetail(postId) {
    emit(PostsDetailLoading());
    postRepository.getPostDetail(postId).then((posts) {
      emit(PostDetailLoaded(posts: posts));
    });
  }

  void likePost(postId, {String? likeType}) {
    emit(LikePostLoading());
    postRepository.likePost(postId, likeType: likeType).then((result) {
      if (result) {
        emit(LikePostSuccess(isSuccess: result));
      } else {
        emit(LikePostError(message: 'LikePostError'));
      }
    });
  }

  void commentPost({String? postId, String? comment}) {
    emit(CommentPostLoading());
    postRepository.commentPost(postId: postId, comment: comment).then((result) {
      if (result) {
        emit(CommentPostSuccess(isSuccess: result));
      } else {
        emit(CommentPostError(message: 'CommentPostError'));
      }
    });
  }

  void createPost({String? description, String? mediaId}) {
    emit(CreatePostLoading());
    postRepository.createPost(description: description, mediaId: mediaId).then((result) {
      if (result) {
        emit(CreatePostSuccess(isSuccess: result));
      } else {
        emit(CreatePostError(message: 'CommentPostError'));
      }
    });
  }

  void uploadMediaPost({String? filePath}) {
    emit(UploadMediaPostLoading());
    authRepository.uploadFile(filePath: filePath).then((result) {
      if (result != null && result['statusCode'] == 200) {
        emit(UploadMediaPostSuccess(profileUploadResponse: result['data']));
      } else {
        emit(UploadMediaPostError(message: result?['message']));
      }
    });
  }

  void deletePost(postId) {
    emit(DeletePostLoading());
    postRepository.deletePost(postId).then((result) {
      if (result) {
        emit(DeletePostSuccess(isSuccess: result));
      } else {
        emit(DeletePostError(message: 'DeletePostError'));
      }
    });
  }

  void getPostInsight({String? postId, String? chartType}) {
    emit(GetPostInsightLoading());
    postRepository.getPostInsight(postId: postId, chartType: chartType).then((result) {
      emit(GetPostInsightLoaded(insightModel: result));
    });
  }
}
