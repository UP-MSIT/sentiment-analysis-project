import 'dart:io';

import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/services/api_client.dart';
import '../../res/colors/colors.dart';
import '../../res/constants/app_sizes.dart';
import '../../res/theme/theme.dart';
import '../widgets/action_button.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_textfields.dart';

class CreatePostPage extends HookWidget {
  CreatePostPage({Key? key}) : super(key: key);
  String? filePath = '';
  String? mediaId = '';

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            children: [
              Row(
                children: [
                  ActionButton(
                    heroIcons: HeroIcons.xCircle,
                    heroIconStyle: HeroIconStyle.outline,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Space.vSM(context),
                  Text(
                    "Create post",
                    style: themeData.textTheme.displayMedium,
                  ),
                  const Spacer(),
                  AppButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context.read<PostsCubit>().createPost(description: controller.text, mediaId: mediaId);
                    },
                    child: Text("Post", style: themeData.textTheme.bodyMedium),
                  ),
                ],
              ),
              Space.hSM(context),
              AppTextfield(controller: controller, hintText: 'Tell your circle what\'s happening.'),
              Space.hXSM(context),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyDark, width: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BlocConsumer<PostsCubit, PostsState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    // TODO: implement listener
                    if (state is UploadMediaPostLoading) {
                      EasyLoading.show(status: 'Uploading.. ', maskType: EasyLoadingMaskType.clear);
                    } else if (state is UploadMediaPostSuccess) {
                      EasyLoading.showSuccess('Uploaded!');
                      filePath = '$BASE_URL${state.profileUploadResponse!.filename}';
                      mediaId = state.profileUploadResponse!.id.toString();
                    } else if (state is UploadMediaPostError) {
                      EasyLoading.showError('UploadMediaPostError');
                    }
                    if (state is CreatePostLoading) {
                      EasyLoading.show(status: 'Posting.. ', maskType: EasyLoadingMaskType.clear);
                    } else if (state is CreatePostSuccess) {
                      EasyLoading.showSuccess('Posted!');
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Navigator.of(context).pop();
                      });
                    } else if (state is CreatePostError) {
                      EasyLoading.showError('CreatePostError');
                    }
                    return (filePath != null && filePath!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(filePath ?? '', width: width(context), fit: BoxFit.fill),
                          )
                        : GestureDetector(
                            onTap: () async {
                              final pickedAsset = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedAsset != null) {
                                if (pickedAsset.path.isNotEmpty) {
                                  context.read<PostsCubit>().uploadMediaPost(filePath: pickedAsset.path);
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: AppColors.greyDark, width: 0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HeroIcon(HeroIcons.photo, color: Colors.grey, size: 30),
                                  Text('Add a photo'),
                                ],
                              ),
                            ),
                          );
                  },
                ),
                // Space.hXSM(context),
              ),
              const SizedBox(height: 10),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (filePath != null || filePath!.isNotEmpty)
                    ActionButton(
                      onTap: () async {
                        final pickedAsset = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedAsset != null) {
                          pickedFile.value = File(pickedAsset.path);
                        }
                      },
                      heroIcons: HeroIcons.photo,
                      heroIconStyle: HeroIconStyle.outline,
                      label: "Replace photo",
                    ),
                  if (filePath != null || filePath!.isNotEmpty)
                    ActionButton(
                      onTap: () async {
                        pickedFile.value = null;
                      },
                      heroIcons: HeroIcons.trash,
                      heroIconStyle: HeroIconStyle.outline,
                      color: AppColors.red,
                      label: "Remove photo",
                    ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
