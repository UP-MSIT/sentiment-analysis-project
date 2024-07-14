import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/infrastructure/model/user_info.dart';
import 'package:ddd_feed/presentation/auth/login/login.dart';
import 'package:ddd_feed/presentation/components/display_image_widget.dart';
import 'package:ddd_feed/presentation/res/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/api_client.dart';
import '../res/widgets/app_bar.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _buildBody(context),
      appBar: const CustomAppBar(
        title: 'Profile',
        actions: SizedBox(),
      ),
      // bottomNavigationBar: _textInputField(),
    );
  }

  _buildBody(context) {
    UserInfo? userInfo;
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetCurrentUserLoading) {
            EasyLoading.show(status: 'Loading...');
          } else if (state is GetCurrentUserSuccess) {
            EasyLoading.dismiss();
            userInfo = state.userInfo;
          } else if (state is GetCurrentUserFailure) {
            EasyLoading.showError('${state.message}');
          }

          if (userInfo != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                DisplayImage(imagePath: (BASE_URL + userInfo!.profile.toString())),
                const SizedBox(height: 10),
                Text(
                  '${userInfo!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.greyDark,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 170,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: ListView(
                    children: ListTile.divideTiles(
                      color: Colors.grey[200],
                      context: context,
                      tiles: [
                        ListTile(
                          leading: const Text(
                            'ID',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            '000${userInfo!.id}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          minVerticalPadding: 0,
                          horizontalTitleGap: 0,
                        ),
                        ListTile(
                          leading: const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            '${userInfo!.email}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Text(
                            '${userInfo!.type}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () async {
                    EasyLoading.show(status: 'Loading...');
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('token', '');
                    Future.delayed(const Duration(milliseconds: 800), () {
                      EasyLoading.dismiss();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (route) => false);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: ListTile(
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.greyDark,
                        ),
                      ),
                      leading: const Icon(Icons.logout, color: Colors.red),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
