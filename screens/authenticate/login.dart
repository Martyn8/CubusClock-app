import 'package:cubus_clock/colors.dart';
import 'package:cubus_clock/model/loading.dart';
import 'package:cubus_clock/screens/authenticate/register.dart';
import 'package:cubus_clock/services/auth.dart';
import 'package:flutter/material.dart';

import '../wrapper.dart';

class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: darkBackgroundColor,
              elevation: 0.0,
              title: Text("Sign in"),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    icon: Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                    label:
                        Text("Sign up", style: TextStyle(color: primaryColor)))
              ],
            ),
            body: Container(
                color: lightBackgroundColor,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter an email" : null,
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
                          validator: (val) => val!.length < 8
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
                                  vertical: 20, horizontal: 40)),
                              primary: primaryColor,
                              elevation: 10,
                              textStyle: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              )),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.signIn(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = "Sorry. Could not sign in.";
                                });
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()));
                                //if ok user is automatically logged in
                              }
                            }
                          },
                          child: Text(
                            "Sign in",
                            //style: TextStyle(color: textColor),
                          )),
                      SizedBox(height: 30.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 15.0)),
                    ],
                  ),
                )),
          );
  }
}
