import 'package:ddd_feed/bloc/auth/cubit/auth_cubit.dart';
import 'package:ddd_feed/infrastructure/model/user_info.dart';
import 'package:ddd_feed/presentation/home/posts/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'widgets/bottom_nav.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);
    return StreamBuilder<UserInfo>(
      stream: BlocProvider.of<AuthCubit>(context).isUserObservable,
      builder: (context, snapshot) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex.value,
            children: const [PostPage()],
          ),
          bottomNavigationBar: (snapshot.data?.type == 'PAGE')
              ? BottomNav(
                  currentIndex: currentIndex.value,
                  onPressed: (index) {
                    currentIndex.value = index;
                  },
                )
              : const SizedBox(),
        );
      },
    );
  }
}
