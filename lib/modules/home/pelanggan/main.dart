import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/customer_list.model.dart';
import 'package:seekil_back_office/modules/home/pelanggan/controller.dart';
import 'package:seekil_back_office/widgets/loading_indicator.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late Future<List<dynamic>> customerList;
  final controller = Get.put(CustomerPageController());

  @override
  void initState() {
    super.initState();
    fetchCustomerList();
  }

  fetchCustomerList() {
    customerList = CustomerListModel.fetchCustomerList('customer');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: WidgetHelper.appBar(
          'Pelanggan',
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Obx(
                () => TextFormField(
                  key: Key(controller.searchInput.value),
                  cursorColor: ColorConstant.DEF,
                  initialValue: controller.searchInput.value,
                  // onFieldSubmitted: controller.handleSearchBar,
                  textInputAction: TextInputAction.search,
                  onChanged: controller.onChangeSearchInput,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: Colors.grey[200],
                    hintText: 'Cari Nama Pelanggan',
                    hintStyle: TextStyle(fontSize: 14.0),
                    suffixIconConstraints: BoxConstraints(minWidth: 40.0),
                    prefixIconConstraints: BoxConstraints(minWidth: 40.0),
                    prefixIcon: Icon(Icons.search, color: ColorConstant.DEF),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10.0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    suffixIcon: controller.searchInput.value.isNotEmpty
                        ? GestureDetector(
                            onTap: controller.resetSearchBar,
                            child: Icon(Icons.close_rounded,
                                color: ColorConstant.DEF),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: FutureBuilder(
          future: customerList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return LoadingIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index];
                      return ListTile(
                        leading: Icon(
                          Icons.account_circle_rounded,
                          color: ColorConstant.DEF,
                          size: 48.0,
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.whatsapp ?? '-'),
                        trailing: IconButton(
                          icon: Icon(Icons.chat),
                          onPressed: () {},
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: Text('Tidak ada data'),
                );
            }
          },
        ));
  }
}
