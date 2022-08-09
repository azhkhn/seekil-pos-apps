import 'package:flutter/material.dart';

class ExpenditureEmptyList extends StatelessWidget {
  const ExpenditureEmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum ada data pengeluaran bulan ini',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tap tombol ',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Icon(Icons.add_circle),
            Text(
              ' untuk tambah pengeluaran',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
