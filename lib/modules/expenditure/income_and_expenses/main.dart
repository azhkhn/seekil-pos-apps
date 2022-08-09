import 'package:flutter/material.dart';
import 'package:seekil_back_office/models/expenditure.model.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/views/card_incoming.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/views/card_outcoming.dart';
import 'package:seekil_back_office/modules/expenditure/income_and_expenses/views/card_outcoming_staff.dart';
import 'package:seekil_back_office/utilities/helper/auth_helper.dart';
import 'package:seekil_back_office/utilities/helper/word_transformation.dart';
import 'package:seekil_back_office/widgets/shimmer.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class ExpenditureIncomingAndExpenses extends StatefulWidget {
  const ExpenditureIncomingAndExpenses({Key? key}) : super(key: key);

  @override
  State<ExpenditureIncomingAndExpenses> createState() =>
      ExpenditureIncomingAndExpensesState();
}

class ExpenditureIncomingAndExpensesState
    extends State<ExpenditureIncomingAndExpenses> {
  final WordTransformation wt = WordTransformation();
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    setState(() {
      data = ExpenditureModel.fetchCashFlowCurrentMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WidgetHelper.appBar(
        'Arus kas ${wt.currentMonth}',
      ),
      body: RefreshIndicator(
        onRefresh: fetchInitialData,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.0),
          children: [
            if (AuthHelper.isSuperAdmin())
              Text('Total pendapatan', style: TextStyle(fontSize: 24.0)),
            if (AuthHelper.isSuperAdmin())
              FutureBuilder(
                future: data,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Wrap(
                        children: [MyShimmer.rectangular()],
                      );
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            snapshot.data as Map<String, dynamic>;
                        int total = data['total'];

                        return Text(wt.currencyFormat(total),
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: total.isNegative
                                    ? Colors.red
                                    : Colors.green));
                      }
                      return Text('Rp-',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold));
                  }
                },
              ),
            SizedBox(height: 24.0),
            CardIncoming(data),
            SizedBox(height: 24.0),
            if (AuthHelper.isSuperAdmin()) CardExpenses(data),
            if (AuthHelper.isStaff()) CardExpensesStaff()
          ],
        ),
      ),
    );
  }
}
