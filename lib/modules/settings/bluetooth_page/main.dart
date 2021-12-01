import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seekil_back_office/constants/general.constant.dart';
import 'package:seekil_back_office/constants/storage_key.constant.dart';
import 'package:seekil_back_office/utilities/helper/snackbar_helper.dart';
import 'package:seekil_back_office/widgets/widget.helper.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final box = GetStorage();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice>? _devices = [];
  BluetoothDevice? _device;
  String? connectStatus;

  @override
  void initState() {
    initBluetoothDevice();
    super.initState();
  }

  initBluetoothDevice() {
    bluetooth.isOn.then((value) async {
      // If bluetooth off
      // Show snackbar notification
      if (!value!) {
        bool? isSnackbarOpen = Get.isSnackbarOpen;
        if (!isSnackbarOpen!) {
          SnackbarHelper.show(
              title: GeneralConstant.ERROR_TITLE,
              message: GeneralConstant.BLUETOOTH_OFF,
              snackStatus: SnackStatus.ERROR,
              withBottomNavigation: true);
        }
        setState(() {
          _devices = null;
        });
      } else {
        List<BluetoothDevice>? bluetoothList =
            await bluetooth.getBondedDevices();
        if (bluetoothList.isNotEmpty) {
          BluetoothDevice? selectedBluetooth =
              box.read(StorageKeyConstant.SELECTED_BLUETOOTH);
          setState(() {
            _devices = bluetoothList;
          });

          if (selectedBluetooth != null) {
            setState(() {
              _device = selectedBluetooth;
            });
          }
        } else {
          setState(() {
            _devices = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper.appBar('Printer'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Perangkat yang tersedia',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () => initBluetoothDevice(),
                        icon: const Icon(Icons.refresh))
                  ],
                ),
                if (_devices != null)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _devices!.length,
                    itemBuilder: (context, index) {
                      var item = _devices![index];
                      return _bluetoothItemList(item);
                    },
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_device != null) {
                bluetooth.printNewLine();
                bluetooth.printCustom('Seekil Shoes Clean & Care', 1, 1);
              } else {
                return null;
              }
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(blurRadius: 20.0, offset: Offset(0, 15.0))
              ]),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                width: Get.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: _device != null ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Center(
                    child: Text(
                  'Test',
                  style: TextStyle(
                      color: _device != null ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bluetoothItemList(BluetoothDevice item) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        title: Text(
          item.name as String,
          style: const TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(item.address as String),
        trailing: TextButton(
          onPressed: () => _device != null
              ? _device == item
                  ? _disconnect()
                  : _connect(item)
              : _connect(item),
          child: Text(
            _device != null
                ? _device == item
                    ? 'Putuskan'
                    : 'Hubungkan'
                : 'Hubungkan',
            style: TextStyle(
                color: _device != null
                    ? _device == item
                        ? Colors.red
                        : Colors.blue
                    : Colors.blue),
          ),
        ),
      ),
    );
  }

  void _connect(BluetoothDevice item) {
    bluetooth.isConnected.then((isConnected) {
      if (!isConnected!) {
        bluetooth.connect(item).then((isConnect) {
          if (isConnect) {
            box.write(StorageKeyConstant.SELECTED_BLUETOOTH, item);
            setState(() {
              _device = item;
            });
            SnackbarHelper.show(
                title: 'Berhasil terhubung',
                message: 'Perangkat berhasil disimpan',
                snackStatus: SnackStatus.INFO,
                withBottomNavigation: true);
          }
        }).catchError((error) {
          SnackbarHelper.show(
              title: GeneralConstant.ERROR_TITLE,
              message: GeneralConstant.BLUETOOTH_NOT_CONNECTED,
              snackStatus: SnackStatus.ERROR,
              withBottomNavigation: true);
        });
      } else {
        _disconnect();
      }
    });
  }

  void _disconnect() {
    bluetooth.disconnect().then((value) {
      box.remove(StorageKeyConstant.SELECTED_BLUETOOTH);
      setState(() {
        _device = null;
      });
      SnackbarHelper.show(
          title: 'Info',
          message: 'Perangkat dihapus',
          snackStatus: SnackStatus.INFO,
          withBottomNavigation: true);
    });
  }
}
