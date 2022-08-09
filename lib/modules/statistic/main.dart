import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekil_back_office/constants/color.constant.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/models/statistic.model.dart';
import 'package:seekil_back_office/modules/statistic/controller.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({Key? key}) : super(key: key);
  final controller = Get.put(StatisticController());
  final WordTransformation wordTransformation = WordTransformation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetHelper.appBar('Statistik'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible:
                            controller.selectedDate.value != 'Pilih Tanggal',
                        child: GestureDetector(
                          onTap: controller.resetDateRangePicker,
                          child: const Text(
                            'Hapus Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => _showDateRangePicker(context),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: Icon(Icons.date_range),
                      title: Obx(() => Text(controller.selectedDate.value)),
                      trailing: Icon(Icons.chevron_right_rounded),
                      minLeadingWidth: 4.0,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: controller.tabController,
            labelColor: ColorConstant.DEF,
            indicatorColor: ColorConstant.DEF,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Semua Transaksi'),
              Tab(text: 'Pengeluaran'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                controller.obx(
                  (state) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.black54);
                      },
                      itemBuilder: (context, index) {
                        StatisticModel item = state[index];
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.month!} ${item.year.toString()}',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${item.totalItems.toString()} item',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(wordTransformation
                                  .currencyFormat(item.total)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  onEmpty: Text('Empty'),
                  onError: (error) => Text(error.toString()),
                ),
                Obx(() {
                  if (controller.dataPengeluaran.value != null) {
                    Map<String, dynamic>? state =
                        controller.dataPengeluaran.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Pengeluaran Operasional',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(wordTransformation
                                      .currencyFormat(state?['total']))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            separatorBuilder: (context, index) {
                              return Divider(color: Colors.black54);
                            },
                            itemCount: state?['list'].length,
                            itemBuilder: (context, index) {
                              ExpenditureModel item = state?['list'][index];
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          wordTransformation.dateFormatter(
                                            date: item.createdAt!,
                                          ),
                                        ),
                                        Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (item.description != null)
                                          Text(
                                            item.description ?? '',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(wordTransformation
                                        .currencyFormat(item.price)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('Tidak ada data pengeluaran'));
                  }
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        currentDate: DateTime.now(),
        saveText: 'Simpan',
        fieldEndHintText: 'Tanggal Akhir',
        fieldStartHintText: 'Tanggal Awal');

    if (result != null) {
      controller.onChangeDateRangePicker(result);
    }
  }
}
