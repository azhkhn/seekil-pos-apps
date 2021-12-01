import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/models/master_data.model.dart';
import 'package:seekil_back_office/models/order_list.model.dart';
import 'package:seekil_back_office/widgets/order/order_card_shimmer.dart';
import 'package:seekil_back_office/widgets/order/order_empty.dart';
import 'package:seekil_back_office/widgets/order/order_list_card.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({Key? key}) : super(key: key);

  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  late Future<List<OrderListModel>> _list;
  late Future<List<dynamic>> _statusList;

  String _selectedStatus = 'Semua Status';
  // String _paramsStatus = '';
  String _selectedTanggal = 'Semua Tanggal';
  // String _paramsTanggal = '';

  static WordTransformation wt = WordTransformation();

  static String getDate(int days) {
    String startDate = wt.dateFormatter(
        date: DateTime.now().toString(), type: DateFormatType.dateData);
    String endDate = wt.dateFormatter(
        date: DateTime.now().subtract(Duration(days: days)).toString(),
        type: DateFormatType.dateData);

    return 'start_date=$startDate&end_date=$endDate';
  }

  List<dynamic> content = [
    {'text': 'Semua Tanggal', 'value': ''},
    {'text': '30 Hari Terakhir', 'value': getDate(30)},
    {'text': '90 Hari Terakhir', 'value': getDate(90)},
    {'text': 'Pilih Tanggal Sendiri', 'value': 'custom'},
  ];

  @override
  void initState() {
    super.initState();
    _initalMasterData();
  }

  Future<void> _initalMasterData() async {
    setState(() {
      _list = OrderListModel.fetchOrderList('');
      _statusList = MasterDataModel.fetchMasterStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper.appBar('Semua Pesanan'),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    prefixIcon: Icon(Icons.search),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 32,
                    ),
                    hintText: 'Cari transaksi',
                    filled: true,
                    fillColor: Colors.black12,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Wrap(
                    spacing: 4.0,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onShowModalStatus();
                        },
                        child: Chip(
                            deleteIcon: Icon(Icons.keyboard_arrow_down_rounded),
                            onDeleted: () {},
                            label: Text(_selectedStatus)),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onShowModalTanggal();
                        },
                        child: Chip(
                            deleteIcon: Icon(Icons.keyboard_arrow_down_rounded),
                            onDeleted: () {},
                            label: Text(_selectedTanggal)),
                      ),
                      GestureDetector(
                        onTap: _selectedStatus != 'Semua Status' ||
                                _selectedTanggal != 'Semua Tanggal'
                            ? () {
                                setState(() {
                                  // _paramsStatus = '';
                                  // _paramsTanggal = '';
                                  _selectedTanggal = 'Semua Tanggal';
                                  _selectedStatus = 'Semua Status';
                                });
                                _initalMasterData();
                              }
                            : null,
                        child: Chip(
                            labelPadding: EdgeInsets.zero,
                            deleteIcon: Icon(Icons.close_rounded),
                            onDeleted: () {},
                            label: Text('')),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _initalMasterData,
                  child: FutureBuilder<List<OrderListModel>>(
                    future: _list,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return OrderCardShimmer(
                            onRefresh: _initalMasterData,
                          );
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<OrderListModel> data =
                                snapshot.data as List<OrderListModel>;

                            if (data.isNotEmpty) {
                              return ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) => OrderListCard(
                                  data: data[index],
                                  isRefreshed: (bool isRefreshed) {
                                    if (isRefreshed) _initalMasterData();
                                  },
                                ),
                              );
                            } else {
                              return OrderEmpty();
                            }
                          }
                          return Container();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _onShowModalTanggal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(24.0),
        topLeft: Radius.circular(24.0),
      )),
      builder: (context) {
        dynamic _selectedTanggal;
        String? _selectedStartDate, _selectedEndDate;
        String defaultDate = wt.dateFormatter(date: DateTime.now().toString());

        TextEditingController startDateController =
            TextEditingController(text: defaultDate);
        TextEditingController endDateController =
            TextEditingController(text: defaultDate);

        Future _selectDate(String dateType) async {
          DateTime? picked = await showDatePicker(
              context: context,
              initialDate: new DateTime.now(),
              firstDate: new DateTime(2020),
              lastDate: new DateTime(2030));
          if (picked != null)
            setState(() {
              if (dateType == 'startDate') {
                _selectedStartDate = picked.toString();
                startDateController.text =
                    wt.dateFormatter(date: picked.toString());
              } else {
                _selectedEndDate = picked.toString();
                endDateController.text =
                    wt.dateFormatter(date: picked.toString());
              }
            });
        }

        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                child: Wrap(children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close_rounded,
                          size: 24.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text('Pilih Tanggal',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ],
                  ),
                  SizedBox(height: 48.0),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: content.length,
                    separatorBuilder: (context, index) {
                      return Divider(height: 2.0, color: Colors.grey);
                    },
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: content[index],
                        groupValue: _selectedTanggal,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (dynamic value) {
                          setState(() {
                            _selectedTanggal = value;
                          });
                        },
                        selected: _selectedTanggal == content[index],
                        title: Text(content[index]['text'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black)),
                      );
                    },
                  ),
                  if (_selectedTanggal != null &&
                      _selectedTanggal['value'] == 'custom')
                    Container(
                      margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: startDateController,
                            onTap: () {
                              _selectDate('startDate');
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Mulai Dari',
                              labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16.0,
                              ),
                            ),
                          )),
                          SizedBox(width: 24.0),
                          Expanded(
                              child: TextFormField(
                            controller: endDateController,
                            onTap: () {
                              _selectDate('endDate');
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Sampai',
                              labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16.0,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      child: Text('Terapkan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      onPressed: () {
                        if (_selectedTanggal['value'] == 'custom') {
                          Map<String, String> params = {
                            'text':
                                '${startDateController.text} - ${endDateController.text}',
                            'value':
                                'start_date=$_selectedStartDate&end_date=$_selectedEndDate'
                          };

                          Get.back(result: params);
                        } else {
                          Get.back(result: _selectedTanggal);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0)),
                    ),
                  )
                ]));
          },
        );
      },
    ).then((value) {
      if (value != null)
        setState(() {
          _selectedTanggal = value['text'];
          _list = OrderListModel.fetchOrderList(value['value']);
        });
    });
  }

  void _onShowModalStatus() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(24.0),
        topLeft: Radius.circular(24.0),
      )),
      builder: (context) {
        dynamic _selectedStatus;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                child: Wrap(children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close_rounded,
                          size: 24.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text('Mau lihat status apa?',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))
                    ],
                  ),
                  SizedBox(height: 48.0),
                  FutureBuilder(
                    future: _statusList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> data = snapshot.data as List<dynamic>;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: data.length,
                          separatorBuilder: (context, index) {
                            return Divider(height: 2.0, color: Colors.grey);
                          },
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: data[index],
                              groupValue: _selectedStatus,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              },
                              title: Text(data[index]['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black)),
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      child: Text('Terapkan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      onPressed: () => Get.back(result: _selectedStatus),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0)),
                    ),
                  )
                ]));
          },
        );
      },
    ).then((value) {
      if (value != null)
        setState(() {
          _selectedStatus = value['name'];
          // _paramsStatus = 'order_status_id=${value['id']}';
          _list =
              OrderListModel.fetchOrderList('order_status_id=${value['id']}');
        });
    });
  }
}