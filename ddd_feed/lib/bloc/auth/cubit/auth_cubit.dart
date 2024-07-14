import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:ddd_feed/infrastructure/model/profile_upload_response.dart';
import 'package:ddd_feed/infrastructure/model/user_info.dart';
import 'package:ddd_feed/infrastructure/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  final _isUserController = StreamController<UserInfo>.broadcast();

// Getter to access the observable value
  Stream<UserInfo> get isUserObservable => _isUserController.stream;

  // Function to update the value of the observable
  void updateValue(UserInfo newValue) {
    _isUserController.add(newValue);
  }

  void getCurrentUser() async {
    emit(GetCurrentUserLoading());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    authRepository.getCurrentUser().then((posts) {
      if (posts != null) {
        prefs.setString('userInfo', json.encode(posts));
        // updateValue(posts['type'] == 'PAGE');
        updateValue(UserInfo.fromJson(posts));
        emit(GetCurrentUserSuccess(userInfo: UserInfo.fromJson(posts)));
      } else {
        emit(GetCurrentUserFailure(message: 'GetCurrentUserFailure'));
      }
    });
  }

  void login({String? email, String? password}) {
    emit(LoginLoading());
    authRepository.login(email: email, password: password).then((result) {
      if (result) {
        getCurrentUser();
        emit(LoggedIn(isLoggedInSuccess: result));
      } else {
        emit(LoginError());
      }
    });
  }

  void uploadProfile(String filePath) {
    emit(AuthLoading());
    authRepository.uploadFile(filePath: filePath).then((result) {
      if (result != null && result['statusCode'] == 200) {
        emit(UploadProfileSuccess(profileUploadResponse: result['data']));
      } else {
        emit(UploadProfileFailure(message: result?['message']));
      }
    });
  }

  void register({Map<String, dynamic>? data}) {
    emit(AuthLoading());
    authRepository.register(data: data).then((result) {
      if (result) {
        emit(RegisterUserSuccess(isSuccess: result));
      } else {
        emit(RegisterUserFailure(message: 'RegisterUserFailure'));
      }
    });
  }

  // Close the StreamController when done
  void dispose() {
    _isUserController.close();
  }
}
