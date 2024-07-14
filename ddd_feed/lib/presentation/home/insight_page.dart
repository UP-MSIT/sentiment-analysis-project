import 'dart:convert';
import 'dart:typed_data';

import 'package:ddd_feed/bloc/insight_type_cubit.dart';
import 'package:ddd_feed/bloc/posts/cubit/posts_cubit.dart';
import 'package:ddd_feed/presentation/auth/register/register.dart';
import 'package:ddd_feed/presentation/res/colors/colors.dart';
import 'package:ddd_feed/presentation/res/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class InsightPage extends StatefulWidget {
  InsightPage({super.key, this.postId});

  final String? postId;

  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  String? insightTypeValue = 'bar';
  final List<String> _insightTypes = ["over_time", "bar", "pie"];
  final _insightTypeCubit = InsightTypeCubit();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<PostsCubit>(context).getPostInsight(postId: widget.postId, chartType: insightTypeValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? bytesImage;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Insight'),
      body: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is GetPostInsightLoading) {
            EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.clear);
          }
        },
        builder: (context, state) {
          if (state is GetPostInsightLoaded) {
            bytesImage = const Base64Decoder().convert(state.insightModel.plotImage ?? '');
            EasyLoading.dismiss();
          }
          return bytesImage != null ? _buildBody(bytesImage) : const SizedBox();
        },
      ),
    );
  }

  _buildBody(image) {
    return Column(
      children: [
        BlocProvider.value(
          value: _insightTypeCubit,
          child: BlocConsumer<PostsCubit, PostsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: AppDropdownInput(
                  options: _insightTypes,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
                  ),
                  icon: Icon(
                    Icons.insights,
                    size: 15,
                    color: AppColors.greyDark,
                  ),
                  value: context.watch<InsightTypeCubit>().state,
                  //userTypeValue,
                  onChanged: (String? value) {
                    insightTypeValue = value;
                    context.read<InsightTypeCubit>().selectInsightType(value);
                    BlocProvider.of<PostsCubit>(context).getPostInsight(postId: widget.postId, chartType: insightTypeValue);
                  },
                  getLabel: (String value) {
                    return value;
                  },
                ),
              );
            },
          ),
        ),
        Image.memory(image),
      ],
    );
  }
}
