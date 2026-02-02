import 'package:get/get.dart';
import 'package:movie_matrix/data/models/user_model.dart';
import 'package:movie_matrix/services/user_service.dart';

class UserController extends GetxController {
  final UserService _service = UserService();

  final user = Rxn<UserModel>();
  final error = ''.obs;
  final isLoading = true.obs;
  final msg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _service.getUserProfile();
      user.value = response;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> putUserDetails(UserModel updateUser) async {
    try {
      isLoading.value = true;
      error.value = '';

      final res = await _service.putUserData(updateUser);
      msg.value = res;
      user.value = updateUser;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
