import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/modules/order/all_order/controller.dart';
import 'package:seekil_back_office/modules/order/all_order/views/filter.dart';
import 'package:seekil_back_office/modules/order/all_order/views/lists.dart';
import 'package:seekil_back_office/modules/order/all_order/views/search_bar.dart';
import 'package:seekil_back_office/modules/order/all_order/views/sliver_app_bar.dart';
import 'package:seekil_back_office/modules/order/all_order/views/sliver_persistent_header_delegate.dart';

class AllOrder extends StatelessWidget {
  final controller = Get.put(AllOrderController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              AllOrderSliverAppBar(),
              SliverPersistentHeader(
                delegate: SliverHeaderDelegate(
                  minHeight: kToolbarHeight * 2.1,
                  maxHeight: kToolbarHeight * 2.1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AllOrderSearchBar(),
                      AllOrderFilterSection(),
                    ],
                  ),
                ),
                pinned: true,
              )
            ];
          },
          body: AllOrderList()),
    ));
  }

  // void _onShowModalTanggal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //       topRight: Radius.circular(24.0),
  //       topLeft: Radius.circular(24.0),
  //     )),
  //     builder: (context) {
  //       dynamic _selectedTanggal;
  //       String? _selectedStartDate, _selectedEndDate;
  //       String defaultDate = wt.dateFormatter(date: DateTime.now().toString());

  //       TextEditingController startDateController =
  //           TextEditingController(text: defaultDate);
  //       TextEditingController endDateController =
  //           TextEditingController(text: defaultDate);

  //       Future _selectDate(String dateType) async {
  //         DateTime? picked = await showDatePicker(
  //             context: context,
  //             initialDate: new DateTime.now(),
  //             firstDate: new DateTime(2020),
  //             lastDate: new DateTime(2030));
  //         if (picked != null)
  //           setState(() {
  //             if (dateType == 'startDate') {
  //               _selectedStartDate = picked.toString();
  //               startDateController.text =
  //                   wt.dateFormatter(date: picked.toString());
  //             } else {
  //               _selectedEndDate = picked.toString();
  //               endDateController.text =
  //                   wt.dateFormatter(date: picked.toString());
  //             }
  //           });
  //       }

  //       return StatefulBuilder(
  //         builder:
  //             (BuildContext context, void Function(void Function()) setState) {
  //           return Container(
  //               padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
  //               child: Wrap(children: [
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () => Get.back(),
  //                       child: Icon(
  //                         Icons.close_rounded,
  //                         size: 24.0,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     SizedBox(width: 8.0),
  //                     Text('Pilih Tanggal',
  //                         style: TextStyle(
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black))
  //                   ],
  //                 ),
  //                 SizedBox(height: 48.0),
  //                 ListView.separated(
  //                   shrinkWrap: true,
  //                   itemCount: content.length,
  //                   separatorBuilder: (context, index) {
  //                     return Divider(height: 2.0, color: Colors.grey);
  //                   },
  //                   itemBuilder: (context, index) {
  //                     return RadioListTile(
  //                       value: content[index],
  //                       groupValue: _selectedTanggal,
  //                       controlAffinity: ListTileControlAffinity.trailing,
  //                       onChanged: (dynamic value) {
  //                         setState(() {
  //                           _selectedTanggal = value;
  //                         });
  //                       },
  //                       selected: _selectedTanggal == content[index],
  //                       title: Text(content[index]['text'],
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 16.0,
  //                               color: Colors.black)),
  //                     );
  //                   },
  //                 ),
  //                 if (_selectedTanggal != null &&
  //                     _selectedTanggal['value'] == 'custom')
  // Container(
  //   margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
  //   child: Row(
  //     children: [
  //       Expanded(
  //           child: TextFormField(
  //         controller: startDateController,
  //         onTap: () {
  //           _selectDate('startDate');
  //           FocusScope.of(context)
  //               .requestFocus(new FocusNode());
  //         },
  //         maxLines: 1,
  //         decoration: InputDecoration(
  //           labelText: 'Mulai Dari',
  //           labelStyle: TextStyle(
  //             decorationStyle: TextDecorationStyle.solid,
  //             fontSize: 16.0,
  //           ),
  //         ),
  //       )),
  //       SizedBox(width: 24.0),
  //       Expanded(
  //           child: TextFormField(
  //         controller: endDateController,
  //         onTap: () {
  //           _selectDate('endDate');
  //           FocusScope.of(context)
  //               .requestFocus(new FocusNode());
  //         },
  //         maxLines: 1,
  //         decoration: InputDecoration(
  //           labelText: 'Sampai',
  //           labelStyle: TextStyle(
  //             decorationStyle: TextDecorationStyle.solid,
  //             fontSize: 16.0,
  //           ),
  //         ),
  //       )),
  //     ],
  //   ),
  // ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   margin: EdgeInsets.only(top: 16.0),
  //                   child: ElevatedButton(
  //                     child: Text('Terapkan',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 16.0)),
  //                     onPressed: () {
  //                       if (_selectedTanggal['value'] == 'custom') {
  //                         Map<String, String> params = {
  //                           'text':
  //                               '${startDateController.text} - ${endDateController.text}',
  //                           'value':
  //                               'start_date=$_selectedStartDate&end_date=$_selectedEndDate'
  //                         };

  //                         Get.back(result: params);
  //                       } else {
  //                         Get.back(result: _selectedTanggal);
  //                       }
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                         padding: EdgeInsets.all(16.0)),
  //                   ),
  //                 )
  //               ]));
  //         },
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null)
  //       setState(() {
  //         _selectedTanggal = value['text'];
  //         _list = OrderListModel.fetchOrderList(value['value']);
  //       });
  //   });
  // }

  // void _onShowModalStatus() {
  //   showModalBottomSheet(
  //     context: context,
  // isScrollControlled: true,
  // shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.only(
  //   topRight: Radius.circular(24.0),
  //   topLeft: Radius.circular(24.0),
  // )),
  //     builder: (context) {
  //       dynamic _selectedStatus;
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Container(
  //               padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
  //               child: Wrap(children: [
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () => Get.back(),
  //                       child: Icon(
  //                         Icons.close_rounded,
  //                         size: 24.0,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     SizedBox(width: 8.0),
  //                     Text('Mau lihat status apa?',
  //                         style: TextStyle(
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black))
  //                   ],
  //                 ),
  //                 SizedBox(height: 48.0),
  //                 FutureBuilder(
  //                   future: _statusList,
  //                   builder: (context, snapshot) {
  //                     if (snapshot.hasData) {
  //                       List<dynamic> data = snapshot.data as List<dynamic>;
  // return ListView.separated(
  //   shrinkWrap: true,
  //   physics: ScrollPhysics(),
  //   itemCount: data.length,
  //   separatorBuilder: (context, index) {
  //     return Divider(height: 2.0, color: Colors.grey);
  //   },
  //   itemBuilder: (context, index) {
  //     return RadioListTile(
  //       value: data[index],
  //       groupValue: _selectedStatus,
  //       controlAffinity: ListTileControlAffinity.trailing,
  //       onChanged: (dynamic value) {
  //         setState(() {
  //           _selectedStatus = value;
  //         });
  //       },
  //       title: Text(data[index]['name'],
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 16.0,
  //               color: Colors.black)),
  //     );
  //   },
  // );
  //                     }
  //                     return Container();
  //                   },
  //                 ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   margin: EdgeInsets.only(top: 16.0),
  //                   child: ElevatedButton(
  //                     child: Text('Terapkan',
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 16.0)),
  //                     onPressed: () => Get.back(result: _selectedStatus),
  //                     style: ElevatedButton.styleFrom(
  //                         padding: EdgeInsets.all(16.0)),
  //                   ),
  //                 )
  //               ]));
  //         },
  //       );
  //     },
  //   ).then((value) {
  //     if (value != null)
  //       setState(() {
  //         _selectedStatus = value['name'];
  //         // _paramsStatus = 'order_status_id=${value['id']}';
  //         _list =
  //             OrderListModel.fetchOrderList('order_status_id=${value['id']}');
  //       });
  //   });
  // }
}
