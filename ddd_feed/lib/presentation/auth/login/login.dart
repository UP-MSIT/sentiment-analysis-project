import 'dart:async';
import 'dart:io';

import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/presentation/auth/register/register.dart';
import 'package:ddd_feed/presentation/components/password_text_field.dart';
import 'package:ddd_feed/presentation/components/text_form_builder.dart';
import 'package:ddd_feed/presentation/res/colors/colors.dart';
import 'package:ddd_feed/presentation/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailCtl = TextEditingController(text: 'kbt@gmail.com');
  final TextEditingController _passwords = TextEditingController(text: '123');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            SizedBox(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/login.png'),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                  color: AppColors.greyDark,
                ),
              ),
            ),
            Center(
              child: Text(
                'Log into your account and get started!',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: AppColors.greyDark,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            buildForm(context),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => const Register()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildForm(BuildContext context) {
    return Form(
      // key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            onSaved: (String val) {
              // viewModel.setEmail(val);
            },
            controller: _emailCtl,
          ),
          const SizedBox(height: 15.0),
          PasswordFormBuilder(
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.done,
            // validateFunction: Validations.validatePassword,
            // submitAction: () => viewModel.login(context),
            obscureText: true,
            onSaved: (String val) {
              // viewModel.setPassword(val);
            },
            controller: _passwords,
          ),
          const SizedBox(height: 10.0),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoginLoading) {
                // LoadingUtil.showLoading(context);
              }
              if (state is LoggedIn) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                });
              } else if (state is LoginError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  SnackBarUtil.showInSnackBar('LoginError', context: context);
                  Navigator.of(context).pop();
                });
              }
              return SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  // highlightElevation: 4.0,
                  child: Text(
                    'Log in'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    if (_emailCtl.text.isNotEmpty || _passwords.text.isNotEmpty) {
                      EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
                      BlocProvider.of<AuthCubit>(context).login(email: _emailCtl.text, password: _passwords.text);
                    } else {
                      SnackBarUtil.showInSnackBar('Email or Password are required', context: context);
                    }

                    /*  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ); */
                  }, //viewModel.login(context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SnackBarUtil {
  static void showInSnackBar(String? value, {context}) {
    var snackBar = SnackBar(
      content: Text(
        '$value',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
