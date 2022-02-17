import 'package:cubus_clock/model/user.dart';
import 'package:cubus_clock/screens/authenticate/authenticate.dart';
import 'package:cubus_clock/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);
    print(user);

    //return home or auth

      if (user == null) {
        return Authenticate();
      } else {
        return HomePage();
      }

  }
}
