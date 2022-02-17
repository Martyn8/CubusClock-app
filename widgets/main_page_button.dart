import 'package:flutter/material.dart';

import '../colors.dart';

class MainPageButton extends StatelessWidget {
  const MainPageButton({
    Key? key,
    required this.size,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final Size size;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: size.width * 0.6,
          height: size.height * 0.2,
          decoration: BoxDecoration(
            color: darkBackgroundColor,
            border: Border.all(
              color: primaryColor,
              width: 6,
            ),
          ),
          child: Center(
            child: Text(
              this.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                letterSpacing: 3,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }
}
