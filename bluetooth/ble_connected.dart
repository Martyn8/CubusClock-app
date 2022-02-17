import 'package:cubus_clock/screens/home/home.dart';
import 'package:cubus_clock/services/send_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../colors.dart';
import 'ble_connect.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({Key? key}) : super(key: key);

  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  bool notSending = true;
  List<BluetoothService> services = ConnectToDevice.services;
  late BluetoothCharacteristic characteristicNotify;
  var readData = List.empty(growable: true);
  late String receivedData = "";
  String infoText = "";
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {

        notSending = true;
        services.clear();
        readData.clear();
        receivedData = "";
        success = false;
        Navigator.pop(context, );
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: darkBackgroundColor,
            title: Text(
              'Connected to a Bluefruit52 device',
              style: TextStyle(color: textColor),
            ),
          ),
          body: Container(
            color: lightBackgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Bluefruit52",
                    style: TextStyle(color: textColor, fontSize: 30),
                  ),
                  if (notSending)
                    Column(
                      children: [
                        if (success)
                          Text("Data has been sent",
                              style:
                                  TextStyle(color: primaryColor, fontSize: 25))
                        else
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                notSending = false;
                                infoText = "Searching for data ...";
                              });
                              await _findCharacteristic();

                              characteristicNotify.value.listen((value) async {
                                widget.readValues[characteristicNotify.uuid] =
                                    value;
                                var string2;
                                bool result = false;

                                string2 = String.fromCharCodes(value);
                                //print("string2: $string2");
                                if (value.isNotEmpty) {
                                  readData.add(string2);
                                  receivedData = readData.join("");
                                  print("dataJoined");
                                  print(receivedData);
                                }
                                if (receivedData.contains("END")) {
                                  result = true;
                                  try {
                                    setState(() =>
                                        infoText = "Sending data to database");
                                    await SendData().sendData(receivedData);
                                  } catch (e) {
                                    setState(() => notSending = true);
                                    throw e;
                                  } finally {
                                    setState(() {
                                      success = true;
                                      notSending = true;
                                    });
                                  }
                                } else
                                  setState(() => infoText = "Reading data");
                                result = false;
                              });
                              await characteristicNotify.setNotifyValue(true);
                            },
                            child: const Text('Start data transmission'),
                            style: ElevatedButton.styleFrom(
                                padding: (EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 50)),
                                primary: primaryColor,
                                elevation: 10,
                                textStyle: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                )),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await ConnectToDevice.connectedDevice
                                    .disconnect();
                              } catch (e) {
                                throw e;
                              }
                              setState(() {
                                ConnectToDevice.connectedDevice = null;
                                readData.clear();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              });
                            },
                            child: const Text('Disconnect'),
                            style: ElevatedButton.styleFrom(
                                padding: (EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 50)),
                                primary: primaryColor,
                                elevation: 10,
                                textStyle: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                )),
                          ),
                        )
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(infoText,
                            style: TextStyle(color: textColor, fontSize: 15)),
                        SpinKitDancingSquare(
                          color: primaryColor,
                          size: 100.0,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )),
    );
  }

  _findCharacteristic() async {
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          if (characteristic.uuid.toString().startsWith("6e400003")) {
            characteristicNotify = characteristic;

          }
        }
      }
    }
  }
}
