import 'package:flutter_blue/flutter_blue.dart';

class ConnectToDevice {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  String connectButtonString = 'Connect';
  final List<BluetoothDevice> devicesList = List.empty(growable: true);
  static late List<BluetoothService> services;
  bool noDevices = true;
  bool cantConnect = false;
  static dynamic connectedDevice;

  Future<dynamic> findDevices() async {
    try {
      flutterBlue.connectedDevices
          .asStream()
          .listen((List<BluetoothDevice> devices) {
        for (BluetoothDevice device in devices) {
          if (device.name.toString() == "Bluefruit52") {
            break;
          }
          _addDeviceToList(device);
        }
      });
      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          if (result.device.name.toString() == "Bluefruit52") {
            flutterBlue.stopScan();
            _addDeviceToList(result.device);
            break;
          }
          _addDeviceToList(result.device);
        }
      });
      await flutterBlue.startScan();
      if (devicesList.isNotEmpty) {
        noDevices = false;
        flutterBlue.stopScan();
        return true;
      } else {
        flutterBlue.stopScan();
        return false;
      }
    } catch (e) {
      print(e.toString());
      flutterBlue.stopScan();
      return null;
    }
  }

  _addDeviceToList(final BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
    }
  }

  Future connectToBl52() async {
    try {
      if (await findDevices().timeout(Duration(seconds: 30))) {
        for (BluetoothDevice device in devicesList) {
          if (device.name.toString() == "Bluefruit52") {
            try {
              await device.connect();
            } catch (e) {
              if (e.toString() != 'already_connected') {
                throw e;
              }
            } finally {
              connectedDevice = device;
              cantConnect = false;
              services = await device.discoverServices();
            }
            return services;
          } else {
            cantConnect = true;
          }
        }
      }
    } catch (e) {
      print(e.toString());
      flutterBlue.stopScan();
      return null;
    }
  }
}
