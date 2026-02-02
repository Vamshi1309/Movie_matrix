import 'package:dio/dio.dart';
import 'package:movie_matrix/core/network/api_service.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/data/models/user_model.dart';

class UserService {
  static final String baseUrl = '/user';
  final Dio dio = ApiService.dio;

  Future<UserModel> getUserProfile() async {
    try {
      AppLogger.i("User Service Called...");
      AppLogger.i("fetching Data..");

      final response = await dio.get('${baseUrl}/profile');

      AppLogger.i("fetched Data..");
      AppLogger.i(response.data['data']);

      UserModel user = UserModel.fromJson(response.data['data']);

      return user;
    } on DioException catch (e) {
      AppLogger.e("Failed to User Data from User Service");

      String errorMessage = 'failed to fetch User Data';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<String> putUserData(UserModel data) async {
    try {
      AppLogger.i("User Service Called...");
      AppLogger.i("Upadting Data..");

      final response = await dio.put('${baseUrl}/update-user', data: {
        'name': data.name,
        'email': data.email,
        'mobileNumber': data.mobileNumber
      });

      AppLogger.i("updated Data..");
      AppLogger.i(response.data['data']);

      if (response.statusCode == 200) {
        return response.data['message'].toString();
      } else {
        return "failed to update user";
      }
    } on DioException catch (e) {
      AppLogger.e("Failed to User Data from User Service");

      String errorMessage = 'failed to fetch User Data';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }
}
