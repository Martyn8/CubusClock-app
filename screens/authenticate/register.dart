import 'package:cubus_clock/model/loading.dart';
import 'package:cubus_clock/services/auth.dart';
import 'package:cubus_clock/screens/authenticate/login.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _fromKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: darkBackgroundColor,
        elevation: 0.0,
        title: Text("Sign up"),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pop(
                    context, MaterialPageRoute(builder: (context) => LogIn()));
              },
              icon: Icon(Icons.login_sharp, color: primaryColor,),
              label: Text("Sign in", style: TextStyle(color: primaryColor)))
        ],
      ),
      body: Container(
          color: lightBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50.0),
          child: Form(
            key: _fromKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: textColor),

                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                    validator: (val) =>
                    val!.length < 8
                        ? "Your password has to be min 8 characters long "
                        : null,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: textColor),

                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    }),
                SizedBox(height: 30.0),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: (EdgeInsets.symmetric(
                            vertical: 20, horizontal: 35)),
                        primary: primaryColor,
                        elevation: 10,
                        textStyle: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        )),
                    onPressed: () async {
                      if (_fromKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.register(email, password).timeout(Duration(seconds: 30));
                        if (result == null) {setState(() {
                          error = "Invalid email";
                          loading = false;
                        });
                        } else{
                          Navigator.pop(
                              context, MaterialPageRoute(builder: (context) => LogIn()));
                          //if ok user is automatically logged in
                        }
                      }
                    },
                    child: Text(
                      "Register",
                      //style: TextStyle(color: textColor),
                    )),
                SizedBox(height: 40.0),
                Text(error,style: TextStyle(color: Colors.red, fontSize: 15.0)),
              ],
            ),
          )),
    );
  }
}
