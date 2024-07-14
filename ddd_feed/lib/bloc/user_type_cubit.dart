import 'package:flutter_bloc/flutter_bloc.dart';

class UserTypeCubit extends Cubit<String?> {
  UserTypeCubit() : super(null);

  void selectUserType(String? userType) {
    emit(userType);
  }
}
