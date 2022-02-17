import 'package:cubus_clock/bluetooth/ble_connect.dart';
import 'package:cubus_clock/bluetooth/ble_connected.dart';
import 'package:cubus_clock/colors.dart';
import 'package:cubus_clock/model/loading.dart';
import 'package:cubus_clock/screens/assign_page.dart';
import 'package:cubus_clock/screens/measurements_page.dart';
import 'package:cubus_clock/widgets/main_page_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectToDevice _connectToDevice = ConnectToDevice();

  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'CubusClock ',
              style:
              TextStyle(color: textColor, fontSize: 25, letterSpacing: 1),
            ),
            Icon(
              Icons.watch_later_outlined,
              size: 25,
              color: textColor,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.logout_sharp, color: primaryColor,),
              label: Text("Logout", style: TextStyle(color: primaryColor)))
        ],
        backgroundColor: darkBackgroundColor,
      ),
      body: Container(
      color: lightBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MainPageButton(
              size: size,
              text: 'Display measurements',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasurementsPage()),
                );
              },
            ),
            MainPageButton(
              size: size,
              text: 'Assign activities',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignPage()),
                );
              },
            ),
            TextButton.icon(
              onPressed: () async {

                if(ConnectToDevice.connectedDevice == null){
                  setState(() => loading = true);
                  dynamic result =
                  await _connectToDevice.connectToBl52();

                  if(result == null){

                    if(_connectToDevice.cantConnect){
                      setState(() {
                        loading = false;
                        error = "Sorry. Could not connect to device. \n Check your bluetooth connection.";
                      });
                    }
                    else if (_connectToDevice.noDevices){
                      setState(() {
                        loading = false;
                        error = "Sorry. Could not find any devices.";
                      });
                    }
                    else{
                      setState(() {
                        loading = false;
                        error = "Sorry. Something went wrong.";
                      });
                    }
                  }
                  else {
                    setState(() => loading = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BluetoothPage()),
                    );
                  }
                }
                else{
                  error = "Sorry. You are already connected";
                }

              },
              icon: Icon(Icons.bluetooth_connected),
              label: Text("Connect to the device", style: TextStyle(color: textColor)),),
            Text(error,
                style: TextStyle(color: Colors.red, fontSize: 15.0)),
          ],
        ),
      ),
    ),
    );
  }
}
