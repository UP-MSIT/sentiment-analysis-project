import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_client.dart';
import 'package:dio/dio.dart' as dio;

class AuthProviders {
  ApiClient api = ApiClient();

  Future getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      Response response = await api.dio.get(
        "/api/users/current",
        options: Options(
          validateStatus: _validateStatus,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log("getCurrentUser --> response : $response");
      return response.data;
    } on DioException catch (e) {
      debugPrint("getCurrentUser ERROR : $e");
    }
  }

  Future<bool> login({String? email, String? password}) async {
    final formData = FormData.fromMap({'username': email?.trim(), 'password': password});
    Response? response;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Response response = await api.dio.post(
        "/api/token",
        data: formData,
        options: Options(validateStatus: _validateStatus),
      );
      debugPrint("login --> response = ${response.data}");
      await prefs.setString('token', response.data['access_token'].toString());

      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
    return response!.statusCode != 200;
  }

  Future<bool> register({Map<String, dynamic>? data}) async {
    debugPrint("register --> : ${data.toString()}");
    Response? response;
    try {
      response = await api.dio.post(
        "/api/users",
        data: data,
        options: Options(validateStatus: _validateStatus),
      );
      debugPrint("response register --> : $response");
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("register ERROR : $e");
      return response!.statusCode != 200;
    }
  }

  Future uploadFile(String path) async {
    var formData = dio.FormData.fromMap({"file": dio.MultipartFile.fromFileSync(path)});
    Response? response;
    try {
      response = await api.dio.post(
        "/api/media/post/0",
        data: formData,
        options: Options(validateStatus: _validateStatus),
      );
      debugPrint("uploadProfile: --> $response");
      return response;
    } on DioException catch (e) {
      debugPrint("uploadProfile: ERROR : $e");
      return response;
    }
  }

  bool _validateStatus(int? statusCode) {
    if (statusCode == null) {
      return false;
    }
    if (statusCode == 400) {
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
