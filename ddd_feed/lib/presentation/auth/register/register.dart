import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/bloc/user_type_cubit.dart';
import 'package:ddd_feed/domain/services/api_client.dart';
import 'package:ddd_feed/presentation/auth/login/login.dart';
import 'package:ddd_feed/presentation/components/display_image_widget.dart';
import 'package:ddd_feed/presentation/components/password_text_field.dart';
import 'package:ddd_feed/presentation/components/text_form_builder.dart';
import 'package:ddd_feed/presentation/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../components/image_picker_dialog.dart';
import '../../res/colors/colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? profileId;
  String? filePath;
  String? userTypeValue = 'USER';
  final List<String> _userTypes = ["PAGE", "USER"];

  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  final TextEditingController _confirmPasswordCtl = TextEditingController();
  final TextEditingController _nameCtl = TextEditingController();

  final _userTypeCubit = UserTypeCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10),
          Text(
            'Welcome to Circle\nCreate a new account',
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          const SizedBox(height: 30.0),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AuthLoading) {
                EasyLoading.show(status: 'Loading...');
              } else if (state is UploadProfileSuccess) {
                EasyLoading.dismiss();
                filePath = '$BASE_URL${state.profileUploadResponse!.filename}';
                profileId = state.profileUploadResponse!.id.toString();
              }
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Theme.of(context).primaryColor,
                    builder: (_) => ImagePickerDialog(
                      callBack: (file) async {
                        if (file.path.isNotEmpty) {
                          BlocProvider.of<AuthCubit>(context).uploadProfile(file.path);
                        }
                      },
                    ),
                  );
                },
                child: DisplayImage(
                  imagePath: filePath ?? "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
                ),
              );
            },
          ),
          const SizedBox(height: 30.0),
          buildForm(context),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account  ',
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Login',
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
    );
  }

  buildForm(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            prefix: Ionicons.person_outline,
            hintText: "Name",
            textInputAction: TextInputAction.next,
            controller: _nameCtl,
          ),
          const SizedBox(height: 20.0),
          TextFormBuilder(
            prefix: Ionicons.person_outline,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
            controller: _emailCtl,
          ),
          const SizedBox(height: 20.0),
          BlocProvider.value(
            value: _userTypeCubit,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {},
              builder: (context, state) {
                return AppDropdownInput(
                  hintText: "User type",
                  options: _userTypes,
                  value: context.watch<UserTypeCubit>().state,
                  //userTypeValue,
                  onChanged: (String? value) {
                    // userTypeValue = value;
                    context.read<UserTypeCubit>().selectUserType(value);
                  },
                  getLabel: (String value) => value,
                );
              },
            ),
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            prefix: Ionicons.lock_closed_outline,
            suffix: Ionicons.eye_outline,
            hintText: "Password",
            textInputAction: TextInputAction.next,
            obscureText: true,
            controller: _passwordCtl,
          ),
          const SizedBox(height: 20.0),
          PasswordFormBuilder(
            prefix: Ionicons.lock_open_outline,
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            submitAction: () => {},
            //viewModel.register(context),
            obscureText: true,
            controller: _confirmPasswordCtl,
          ),
          const SizedBox(height: 25.0),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is RegisterUserSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  EasyLoading.showSuccess('RegisterUserSuccess');
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop();
                  });
                });
              } else if (state is RegisterUserFailure) {
                EasyLoading.showError('RegisterUserFailure');
              }
            },
            builder: (_, __) {
              return _buildWidget();
            },
          ),
        ],
      ),
    );
  }

  _buildWidget() {
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
          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryContainer),
        ),
        child: Text(
          'sign up'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          final Map<String, dynamic> data = {
            'email': _emailCtl.text,
            'name': _nameCtl.text,
            'hashed_password': _passwordCtl.text,
            'type': userTypeValue, // TODO: PAGE, USER
            'profileId': profileId,
          };
          if (_nameCtl.text.isEmpty) {
            SnackBarUtil.showInSnackBar('Name is required', context: context);
          } else if (_emailCtl.text.isEmpty) {
            SnackBarUtil.showInSnackBar('Email is required', context: context);
          } else if (_passwordCtl.text.isEmpty || _confirmPasswordCtl.text.isEmpty) {
            SnackBarUtil.showInSnackBar('Password is required', context: context);
          } else if (_passwordCtl.text != _confirmPasswordCtl.text) {
            SnackBarUtil.showInSnackBar('Password does not matched', context: context);
          } else {
            BlocProvider.of<AuthCubit>(context).register(data: data);
          }
        }, //viewModel.register(context),
      ),
    );
  }
}

class AppDropdownInput<T> extends StatelessWidget {
  final String? hintText;
  final List<T>? options;
  final T? value;
  final String Function(T)? getLabel;
  final void Function(T?)? onChanged;
  final Widget? icon;

  final OutlineInputBorder? enabledBorder;

  const AppDropdownInput({
    super.key,
    this.hintText = 'Please select an Option',
    this.options = const [],
    this.getLabel,
    this.value,
    this.onChanged,
    this.icon,
    this.enabledBorder,
  });

  border(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.0),
    );
  }

  focusBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      borderSide: BorderSide(color: AppColors.greyDark, width: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            prefixIcon: icon ?? Icon(Ionicons.person, size: 15.0, color: AppColors.greyDark),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            border: border(context),
            enabledBorder: enabledBorder ?? border(context),
            focusedBorder: focusBorder(context),
            errorStyle: const TextStyle(height: 0.0, fontSize: 0.0),
          ),
          isEmpty: value == null || value == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              style: TextStyle(color: Colors.black),
              onChanged: onChanged,
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                size: 15,
                color: AppColors.greyDark,
              ),
              dropdownColor: Colors.white,
              items: options?.map((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    getLabel!(value),
                    // style: TextStyle(color: Colors.grey[400]),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
