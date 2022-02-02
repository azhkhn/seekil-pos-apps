import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';

var objectSelectedDate = {'start_date': '', 'end_date': ''};
var defaultObjectFilter = {
  'order_type_id': '',
  'order_status_id': '',
  'payment_method_id': '',
  'payment_status': '',
  'customer_name': '',
  'start_date': '',
  'end_date': '',
};

class AllOrderController extends GetxController {
  WordTransformation wt = WordTransformation();
  PagingController<int, OrderListModel> pagingController =
      PagingController<int, OrderListModel>(firstPageKey: 0);

  RxList filterPaymentStatusList = GeneralConstant.filterPaymentStatus.obs;
  RxList filterDateList = GeneralConstant.filterDateMenu.obs;
  RxList filterOrderStatusList = [].obs;
  RxList filterPaymentMethodList = [].obs;

  RxBool showBorderStartDate = false.obs;
  RxBool showBorderEndDate = false.obs;
  RxString queryParameters = ''.obs;
  RxString filterCount = ''.obs;
  RxString searchInput = ''.obs;
  RxBool isFiltered = false.obs;

  final gvFilterDate = {}.obs;
  final selectedDateTitle = RxMap(objectSelectedDate).obs;
  final objectFilter = RxMap(defaultObjectFilter).obs;

  @override
  void onInit() {
    super.onInit();
    fetchMasterData();
    pagingController.addPageRequestListener((pageKey) {
      fetchOrderList(pageKey);
    });
  }

  @override
  void onClose() {
    super.onClose();
    pagingController.dispose();
  }

  String checkQueryParams() {
    // Remove key if value is empty
    objectFilter.value.removeWhere((key, value) => value == '');
    // If all value is empty
    // provide query params as empty value = ''
    // if one of more value is available
    // provide query params with given key-value
    return queryParameters.value = objectFilter.value == {}
        ? ''
        : Uri(queryParameters: objectFilter.value).query;
  }

  Future<void> fetchOrderList(dynamic pageKey) async {
    String queryParams = checkQueryParams();
    filterCount.value = objectFilter.value.length.toString();

    try {
      final newItems =
          await OrderListModel.fetchOrderList(queryParams, pageKey.toString());
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

  Future<void> fetchMasterData() async {
    filterOrderStatusList.value = await MasterDataModel.fetchMasterStatus();
    filterPaymentMethodList.value =
        await MasterDataModel.fetchMasterPaymentMethod();
  }

  void onChangeSearchInput(String value) => searchInput.value = value;

  void handleSearchBar(String value) {
    objectFilter.value['customer_name'] = value;
    pagingController.refresh();
  }

  void resetSearchBar() {
    searchInput.value = '';
    objectFilter.value['customer_name'] = '';
    pagingController.refresh();
  }

  void resetFilter() {
    isFiltered.value = false;
    gvFilterDate.value = {};
    objectFilter.value = RxMap(defaultObjectFilter);
    selectedDateTitle.value = RxMap(objectSelectedDate);
  }

  void onApplyFilter() {
    isFiltered.value = true;
    Get.back();
    pagingController.refresh();
  }

  void onChangeFilterPaymentStatus(dynamic value) {
    objectFilter.value['payment_status'] = value['value'];
  }

  void onChangeFilterOrderStatus(dynamic value) {
    objectFilter.value['order_status_id'] = value['id'].toString();
  }

  void onChangedDate(dynamic value) {
    gvFilterDate.value = value;
    objectFilter.value['start_date'] = value['value']['start_date'];
    objectFilter.value['end_date'] = value['value']['end_date'];
  }

  void onSelectedDate(DateTime? pickedDateTime, String dateType) {
    String selectedDate = wt.dateFormatter(
      date: pickedDateTime.toString(),
    );
    String formattedSelectedDate = wt.dateFormatter(
      date: pickedDateTime.toString(),
      type: DateFormatType.dateData,
    );
    objectFilter.value[dateType] = formattedSelectedDate;
    selectedDateTitle.value[dateType] = selectedDate;
  }

  void resetSelectedDate() {
    selectedDateTitle.value = RxMap(objectSelectedDate);
    objectFilter.value['start_date'] = '';
    objectFilter.value['end_date'] = '';
  }

  bool hasDateValue() {
    var startDate = objectFilter.value['start_date'];
    var endDate = objectFilter.value['end_date'];
    if (startDate != '' && endDate != '') {
      if (startDate != null && endDate != null) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool isStartDateBeforeEndDate() {
    if (hasDateValue()) {
      var startDate = objectFilter.value['start_date'];
      var endDate = objectFilter.value['end_date'];
      if (DateTime.parse(endDate!).isBefore(DateTime.parse(startDate!))) {
        return true;
      }
    }

    return false;
  }
}
