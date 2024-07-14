class LikeCommentApiResponse {
  // Response model for likes and comments on the post
  final int? id;
  final int? postId;
  final int? createdUserId;
  final String? likeType;
  final String? createdDate;
  final String? comment;

  LikeCommentApiResponse({
    this.id,
    this.postId,
    this.createdUserId,
    this.createdDate,
    this.likeType,
    this.comment,
  });

  factory LikeCommentApiResponse.fromJson(Map<String, dynamic> json) {
    return LikeCommentApiResponse(
      createdDate: json['createdDate'] ?? '',
      createdUserId: json['createdUserId'],
      id: json['id'],
      likeType: json['likeType'] ?? '',
      postId: json['postId'],
      comment: json['comment'] ?? '',
    );
  }
}

class PostApiResponse {
  PostApiResponse({
    this.id,
    this.description,
    this.createdDate,
    this.createdUser,
    this.medias,
    this.postComments,
    this.postLikes,
  });

  final String? description;
  final int? id;
  final CreatedUser? createdUser;
  final String? createdDate;
  final List<Post>? postLikes;
  final List<Post>? postComments;
  final List<Media>? medias;

  factory PostApiResponse.fromJson(Map<String, dynamic> json) {
    return PostApiResponse(
      id: json["id"],
      description: json["description"] ?? '',
      createdDate: json['createdDate'] ?? '',
      createdUser: CreatedUser.fromJson(json['createdUser']),
      medias: json["medias"] == null ? [] : List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
      postLikes: json["postLikes"] == null ? [] : List<Post>.from(json["postLikes"].map((x) => Post.fromJson(x))),
      postComments: json["postComments"] == null ? [] : List<Post>.from(json["postComments"].map((x) => Post.fromJson(x))),
    );
  }
}

class CreatedUser {
  final int id;
  final String name;
  final String type;
  // final Profile profile;

  CreatedUser({
    required this.id,
    required this.name,
    required this.type,
  });

  factory CreatedUser.fromJson(Map<String, dynamic> json) {
    return CreatedUser(
      id: json['id'],
      name: json['name'],
      type: json['type'] ?? '',
      // profile: Profile.fromJson(json['profile']),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}

/* class Profile {
  final String filename;

  Profile({
    required this.filename,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      filename: json['filename'],
    );
  }
} */

class Media {
  final String filename;

  Media({
    required this.filename,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      filename: json['filename'],
    );
  }
}

class Post {
  final String? comment;
  final int? id;
  final CreatedUser? createdUser;
  final String? createdDate;
  final String? likeType;

  Post({
    this.comment,
    this.id,
    this.createdUser,
    this.createdDate,
    this.likeType,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        comment: json["comment"],
        id: json["id"],
        createdUser: CreatedUser.fromJson(json['createdUser']),
        createdDate: json["createdDate"] ?? '',
        likeType: json["likeType"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "id": id,
        "createdUser": createdUser?.toJson(),
        "createdDate": createdDate?.toString(),
        "likeType": likeType,
      };
}
