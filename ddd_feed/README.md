# Social Media Feed App - CIRCLE

## Getting Started

To get started with the app, follow these steps:

1. Clone this repository to your local machine.
2. Open the project in your favorite IDE or code editor.
3. Run `flutter pub get` to install the required dependencies.
4. Run the app using `flutter run` command.

## Bloc and Cubit usage

***auth_providers.dart***
```dart
class AuthProviders {
  final ApiClient _client;

  AuthProviders(this._client);

  /// Create a new login provider
  Future<bool> login({String? email, String? password}) async {
    final formData = FormData.fromMap({'username': email?.trim(), 'password': password});
    Response? response;
    try {
      Response response = await _client.dio.post(
        "/api/token",
        data: formData,
        options: Options(validateStatus: _validateStatus),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint("ERROR : $e");
    }
    return response!.statusCode != 200;
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
```
***auth_repo.dart***
```dart

class AuthRepository {
  final AuthProviders providers;

  AuthRepository(this.providers);

  Future<bool> login({String? email, String? password}) async {
    return await providers.login(email: email, password: password);
  }
}  
```

***auth_cubit.dart***
```dart
final AuthRepository authRepository;

void login({String? email, String? password}) {
    emit(AuthLoading());
    authRepository.login(email: email, password: password).then((reuslt) {
        if (reuslt) {
            emit(LoggedIn(isLoggedInSuccess: reuslt));
        } else {
            emit(LoginError());
        }
    });
}
```

***auth_state.dart***
```dart

class AuthLoading extends AuthState {}

class LoggedIn extends AuthState {
  final bool? isLoggedInSuccess;
  LoggedIn({this.isLoggedInSuccess});
}

class LoginError extends AuthState {}

```

***login.dart***
```dart
BlocConsumer<AuthCubit, AuthState>(
    listener: (context, state) {},
    builder: (context, state) {
        if (state is AuthLoading) {
            LoadingUtil.showLoading(context); // show loading
        }

        if (state is LoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(); // pop the loading
            });
        }
        if (state is LoginError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                LoadingUtil.showInSnackBar('LoginError', context: context); // show error snackbar message
                Navigator.of(context).pop();
            });
        }
        return SizedBox(); // return the Login UI
    },
),
```

***user_type_cubit.dart***
```dart 

import 'package:flutter_bloc/flutter_bloc.dart';

class UserTypeCubit extends Cubit<String?> {
  UserTypeCubit() : super(null);

  void selectUserType(String? userType) {
    emit(userType);
  }
}

```
***user_page.dart***

``` dart 
final _userTypeCubit = UserTypeCubit();

BlocProvider.value(
    value: _userTypeCubit,
    child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
        return Widget(
                value: context.watch<UserTypeCubit>().state, //userTypeValue,
                onChanged: (String? value) {
                    context.read<UserTypeCubit>().selectUserType(value);
                },
            );
        },
    ),
),
```          