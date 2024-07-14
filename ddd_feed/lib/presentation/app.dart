import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:ddd_feed/domain/services/providers/auth_providers.dart';
import 'package:ddd_feed/domain/services/providers/post_providers.dart';
import 'package:ddd_feed/infrastructure/repositories/auth_repository.dart';
import 'package:ddd_feed/infrastructure/repositories/post_repository.dart';
import 'package:ddd_feed/presentation/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../bloc/auth/cubit/auth_cubit.dart';
import 'res/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostsCubit(
            postRepository: PostRepository(PostProviders()),
            authRepository: AuthRepository(AuthProviders()),
          ),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authRepository: AuthRepository(AuthProviders()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Circle',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        builder: EasyLoading.init(),
        home: const Login(),
      ),
    );
  }
}
