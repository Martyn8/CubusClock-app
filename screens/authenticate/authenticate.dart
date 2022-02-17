import 'package:cubus_clock/screens/authenticate/login.dart';
import 'package:cubus_clock/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView() {
    setState(() => !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return LogIn();
    }
    else {
      return Register();
    }
  }
}
