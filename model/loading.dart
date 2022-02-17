import 'package:cubus_clock/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightBackgroundColor,
      child: Center(
        child: SpinKitDancingSquare(
          color: primaryColor,
          size: 100.0,
        ),
      ),
    );
  }
}
