import 'package:flutter/material.dart';

class CalButton extends StatefulWidget {
  var color;
  final textColor;
  final String buttonText;
  final Function tapButtonFunc;
  final selectedMode;

  CalButton(
      {this.color,
      this.textColor,
      required this.buttonText,
      required this.tapButtonFunc,
      this.selectedMode});

  @override
  State<StatefulWidget> createState() {
    return CalButtonState();
  }
}

class CalButtonState extends State<CalButton> {
  final buttonsColor = <Color>[Color(0xffF4F4F4), Color(0xff282B33)];
  final selectButtonColor = <Color>[Color(0xffA8A8A8), Color(0xffD6D6D6)];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails t) {
        setState(() {
          widget.color = selectButtonColor[widget.selectedMode];
        });
      },
      onTapUp: (TapUpDetails t) {
        setState(() {
          widget.color = buttonsColor[widget.selectedMode];
        });
      },
      onTap: () {
        widget.tapButtonFunc(widget.buttonText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'VarelaRound',
            ),
          ),
        ),
      ),
    );
  }
}
