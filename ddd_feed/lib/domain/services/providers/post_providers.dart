import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_client.dart';

class PostProviders {
  ApiClient client = ApiClient();

  Future<List<dynamic>> getAllPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      Response response = await client.dio.get(
        "/api/post",
        options: Options(
          validateStatus: _validateStatus,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      // log("getAllPosts --> response : $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
      return [];
    }
  }

  Future getPostDetail(String? postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      Response response = await client.dio.get(
        "/api/post/$postId",
        options: Options(
          validateStatus: _validateStatus,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("getPostDetail --> response : $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
  }

  Future<bool> createPost({String? description, String? mediaId}) async {
    final data = {'description': description, 'mediaId': mediaId};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Response? response;
    try {
      Response response = await client.dio.post(
        "/api/post",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: _validateStatus,
        ),
      );
      // log("createPost --> response = ${response.data}");
      return response.statusCode == 200;
    } on DioException catch (e) {
      log("ERROR : $e");
    }
    return response!.statusCode != 200;
  }

  Future<bool> likePost({String? likeType, String? postId}) async {
    final data = {'likeType': likeType};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Response? response;
    try {
      Response response = await client.dio.put(
        "/api/post/$postId/like",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: _validateStatus,
        ),
      );
      // debugPrint("likePost --> response = ${response.data}");
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
    return response!.statusCode != 200;
  }

  Future<bool> commentPost({String? comment, String? postId}) async {
    final data = {'comment': comment};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Response? response;
    try {
      Response response = await client.dio.post(
        "/api/post/$postId/comment",
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: _validateStatus,
        ),
      );
      // debugPrint("createPost --> response = ${response.data}");
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
    return response!.statusCode != 200;
  }

  Future<bool> deletePost({String? postId}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Response? response;
    try {
      Response response = await client.dio.delete(
        "/api/post/$postId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: _validateStatus,
        ),
      );
      // debugPrint("createPost --> response = ${response.data}");
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
    return response!.statusCode != 200;
  }

  Future getPostInsight({String? postId, String? chartType}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      Response response = await client.dio.get(
        "/api/post/$postId/comment/insight/$chartType",
        options: Options(
          validateStatus: _validateStatus,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("getPostInsight --> response : $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
  }

  //api/media/post/0
  bool _validateStatus(int? statusCode) {
    if (statusCode == null) {
      return false;
    }
    if (statusCode == 403) {
      return true;
    }
    if (statusCode == 401) {
      return true;
    }
    if (statusCode == 422) {
      return true;
    } else {
      return statusCode >= 200 && statusCode < 300;
    }
  }
}
