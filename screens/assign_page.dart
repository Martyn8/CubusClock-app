import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

final myTextController = TextEditingController();
String radioListItem = '';

class AssignPage extends StatefulWidget {
  const AssignPage({Key? key}) : super(key: key);

  @override
  _AssignPageState createState() => _AssignPageState();
}

class _AssignPageState extends State<AssignPage> {
  final database = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userUID = _auth.currentUser!.uid;
    final wallActRef = database.child("Users").child("$userUID").child('Walls');

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Assign Activities",
            style: TextStyle(color: textColor, fontSize: 25, letterSpacing: 1),
          ),
          backgroundColor: darkBackgroundColor,
        ),
        body: Container(
          color: lightBackgroundColor,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const RadioList(),
                  TextFormInput(),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await wallActRef
                            .update({radioListItem: myTextController.text});
                        print('New activity has been set');
                        myTextController.clear();
                      } catch (e) {
                        print('Error. $e');
                      }
                    },
                    child: const Text('Save'),
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
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

enum SingingCharacter { Wall_1, Wall_2, Wall_3, Wall_4, Wall_5 }

class RadioList extends StatefulWidget {
  const RadioList({Key? key}) : super(key: key);

  @override
  State<RadioList> createState() => _RadioListState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RadioListState extends State<RadioList> {
  SingingCharacter? _wall = SingingCharacter.Wall_1;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(100, 50, 120, 20),
      child: Column(
        children: <Widget>[
          RadioListTile<SingingCharacter>(
            activeColor: primaryColor,
            title: const Text('Wall 1',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )),
            value: SingingCharacter.Wall_1,
            groupValue: _wall,
            onChanged: (SingingCharacter? value) {
              setState(() {
                radioListItem = 'Wall 1';
                _wall = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            activeColor: primaryColor,
            title: const Text('Wall 2',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )
            ),
            value: SingingCharacter.Wall_2,
            groupValue: _wall,
            onChanged: (SingingCharacter? value) {
              setState(() {
                radioListItem = 'Wall 2';
                _wall = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            activeColor: primaryColor,
            title: const Text('Wall 3',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )
            ),
            value: SingingCharacter.Wall_3,
            groupValue: _wall,
            onChanged: (SingingCharacter? value) {
              setState(() {
                radioListItem = 'Wall 3';
                _wall = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            activeColor: primaryColor,
            title: const Text('Wall 4',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )
            ),
            value: SingingCharacter.Wall_4,
            groupValue: _wall,
            onChanged: (SingingCharacter? value) {
              setState(() {
                radioListItem = 'Wall 4';
                _wall = value;
              });
            },
          ),
          RadioListTile<SingingCharacter>(
            activeColor: primaryColor,
            title: const Text('Wall 5',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                )),
            value: SingingCharacter.Wall_5,
            groupValue: _wall,
            onChanged: (SingingCharacter? value) {
              setState(() {
                radioListItem = 'Wall 5';
                _wall = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class TextFormInput extends StatefulWidget {
  const TextFormInput({Key? key}) : super(key: key);

  @override
  _TextFormInputState createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(60, 30, 60, 50),
        child: TextField(
          controller: myTextController,
          style: TextStyle(color: textColor),
          cursorColor: primaryColor,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Activity Name',
            labelStyle: TextStyle(color: textColor),
            hintText: 'Learning, Cooking, Reading etc.',
            hintStyle: TextStyle(color: textColor),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor,
                width: 1.0,
              ),
            ),
          ),
        ));
  }
}
