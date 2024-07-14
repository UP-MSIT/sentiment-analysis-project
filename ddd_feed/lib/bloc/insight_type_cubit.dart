import 'package:flutter_bloc/flutter_bloc.dart';

class InsightTypeCubit extends Cubit<String?> {
  InsightTypeCubit() : super(null);

  void selectInsightType(String? chartType) {
    emit(chartType);
  }
}
