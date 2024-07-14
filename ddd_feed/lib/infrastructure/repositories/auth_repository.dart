import 'package:ddd_feed/domain/services/providers/auth_providers.dart';
import 'package:ddd_feed/infrastructure/model/profile_upload_response.dart';

class AuthRepository {
  final AuthProviders providers;

  AuthRepository(this.providers);

  Future getCurrentUser() async => await providers.getCurrentUser();

  Future<bool> login({String? email, String? password}) async {
    return await providers.login(email: email, password: password);
  }

  Future<Map?> uploadFile({String? filePath}) async {
    final result = await providers.uploadFile(filePath ?? '');
    Map? responseResult;
    if (result != null) {
      final statusCode = result.statusCode;
      final statusMessage = result.statusMessage;
      if (statusCode == 200) {
        responseResult = {
          'statusCode': statusCode,
          'message': statusMessage,
          'data': ProfileUploadResponse.fromJson(result.data),
        };
        return responseResult;
      }
    }
    return responseResult;
  }

  Future<bool> register({Map<String, dynamic>? data}) async {
    final result = await providers.register(data: data);
    return result;
  }
}
