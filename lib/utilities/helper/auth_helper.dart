import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/models/auth.model.dart';

class AuthHelper {
  static AuthModel user() {
    final box = GetStorage();
    var data = box.read(StorageKeyConstant.USER_LOGGED_IN);
    return AuthModel(
        username: data['username'], level: data['level'], name: data['name']);
  }

  static bool isLoggedIn() {
    final box = GetStorage();
    var data = box.read(StorageKeyConstant.USER_LOGGED_IN);

    if (data != null) return true;
    return false;
  }

  static bool isSuperAdmin() {
    final box = GetStorage();
    var data = box.read(StorageKeyConstant.USER_LOGGED_IN);

    if (data != null) {
      if (data['level'] == 'superadmin') return true;
      return false;
    }
    return false;
  }

  static bool isStaff() {
    final box = GetStorage();
    var data = box.read(StorageKeyConstant.USER_LOGGED_IN);

    if (data != null) {
      if (data['level'] == 'staff') return true;
      return false;
    }
    return false;
  }

  static bool isPartnership() {
    final box = GetStorage();
    var data = box.read(StorageKeyConstant.USER_LOGGED_IN);

    if (data != null) {
      if (data['level'] == 'partnership') return true;
      return false;
    }
    return false;
  }
}
