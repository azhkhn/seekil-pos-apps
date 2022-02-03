import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/models/customer_list.model.dart';

class CustomerPageController extends GetxController {
  RxString searchInput = ''.obs;
  PagingController<int, CustomerListModel> pagingController =
      PagingController<int, CustomerListModel>(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      fetchCustomerList(pageKey);
    });
  }

  Future<void> fetchCustomerList(dynamic pageKey) async {
    try {
      final newItems = await CustomerListModel.fetchCustomerList(
        page: pageKey.toString(),
        customerName: searchInput.value,
      );
      final isLastPage = newItems.length < 10;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void onFieldSubmitted(String value) {
    searchInput.value = value;
    fetchCustomerList(0);
    pagingController.refresh();
  }

  void onChangeSearchInput(String value) => searchInput.value = value;

  void resetSearchBar() => searchInput.value = '';
}
