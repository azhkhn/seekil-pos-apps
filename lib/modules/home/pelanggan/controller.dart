import 'package:get/get.dart';

class CustomerPageController extends GetxController {
  RxString searchInput = ''.obs;

  void onChangeSearchInput(String value) => searchInput.value = value;

  void resetSearchBar() => searchInput.value = '';
}
