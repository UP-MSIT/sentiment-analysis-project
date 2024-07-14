part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostApiResponse> posts;

  PostsLoaded({required this.posts});
}

class PostsDetailLoading extends PostsState {}

class GetPostInsightLoading extends PostsState {}

class PostDetailLoaded extends PostsState {
  final PostApiResponse posts;

  PostDetailLoaded({required this.posts});
}

class GetPostInsightLoaded extends PostsState {
  final InsightModel insightModel;

  GetPostInsightLoaded({required this.insightModel});
}

class LikePostSuccess extends PostsState {
  final bool? isSuccess;

  LikePostSuccess({this.isSuccess});
}

class LikePostError extends PostsState {
  final String? message;

  LikePostError({this.message});
}

class CommentPostSuccess extends PostsState {
  final bool? isSuccess;

  CommentPostSuccess({this.isSuccess});
}

class CommentPostError extends PostsState {
  final String? message;

  CommentPostError({this.message});
}

class LikePostLoading extends PostsState {}

class DeletePostLoading extends PostsState {}

class CommentPostLoading extends PostsState {}

class CreatePostLoading extends PostsState {}

class UploadMediaPostLoading extends PostsState {}

class CreatePostSuccess extends PostsState {
  final bool? isSuccess;

  CreatePostSuccess({this.isSuccess});
}

class CreatePostError extends PostsState {
  final String? message;

  CreatePostError({this.message});
}

class UploadMediaPostSuccess extends PostsState {
  final ProfileUploadResponse? profileUploadResponse;

  UploadMediaPostSuccess({this.profileUploadResponse});
}

class UploadMediaPostError extends PostsState {
  final String? message;

  UploadMediaPostError({this.message});
}

class DeletePostSuccess extends PostsState {
  final bool? isSuccess;

  DeletePostSuccess({this.isSuccess});
}

class DeletePostError extends PostsState {
  final String? message;

  DeletePostError({this.message});
}
