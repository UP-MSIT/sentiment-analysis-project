// To parse this JSON data, do
//
//     final profileUploadResponse = profileUploadResponseFromJson(jsonString);

import 'dart:convert';

ProfileUploadResponse profileUploadResponseFromJson(String str) => ProfileUploadResponse.fromJson(json.decode(str));

String profileUploadResponseToJson(ProfileUploadResponse data) => json.encode(data.toJson());

class ProfileUploadResponse {
  final int? entityId;
  final String? entityType;
  final int? id;
  final String? filename;

  ProfileUploadResponse({
    this.entityId,
    this.entityType,
    this.id,
    this.filename,
  });

  factory ProfileUploadResponse.fromJson(Map<String, dynamic> json) => ProfileUploadResponse(
        entityId: json["entityId"],
        entityType: json["entityType"],
        id: json["id"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "entityType": entityType,
        "id": id,
        "filename": filename,
      };
}
