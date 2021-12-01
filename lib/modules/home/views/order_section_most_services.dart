import 'package:flutter/material.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';

class OrderSectionMostServices extends StatelessWidget {
  const OrderSectionMostServices(this.topServices, {Key? key})
      : super(key: key);
  final Future<List<dynamic>> topServices;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Layanan paling sering',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: FutureBuilder(
                    future: topServices,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return Column(
                            children: [
                              Expanded(child: MyShimmer(width: 80, height: 10)),
                              SizedBox(
                                height: 4.0,
                              ),
                              MyShimmer(width: 80, height: 10),
                            ],
                          );
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<dynamic> data = snapshot.data as List<dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                      data.length > 0
                                          ? '${data[0]['master_service.name']}'
                                          : 'services_name',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                ),
                                Text(
                                  data.length > 0
                                      ? '${data[0]['total']}x'
                                      : '0x',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text('services_name',
                                    style: TextStyle(fontSize: 16.0)),
                              ),
                              Text('0x times')
                            ],
                          );
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
