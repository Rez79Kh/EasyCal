import 'package:calculator/cal_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  /*
   * Variable for buttons text
   */
  final List<String> buttonsList = [
    'AC',
    '+/-',
    '%',
    '\u00f7',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    'CE',
    '0',
    '.',
    '=',
  ];

  /*
   * Variable for toggle buttons selection
   */
  final isSelected = <bool>[false, false];

  final modeColors = <Color>[Colors.black, Colors.grey];
  final scaffoldColors = <Color>[Color(0xffFFFFFF), Color(0xff22252D)];
  final toggleColors = <Color>[Color(0xffF9F9F9), Color(0xff2A2D37)];
  final buttonsColor = <Color>[Color(0xffF4F4F4), Color(0xff282B33)];
  final numberColors = <Color>[Colors.black, Colors.white];
  final signColors = <Color>[Color(0xff62E5CE), Color(0xffF2797B)];
  final textWeights = <FontWeight>[
    FontWeight.normal,
    FontWeight.bold,
    FontWeight.bold
  ];
  final textSizes = <double>[25, 30, 25];
  final textColors = <Color>[Colors.black, Colors.white, Color(0xffF2797B)];

  int textColorsIndex = 0;
  int textStyleIndex = 0;
  int whichModeSelected = 0;

  String inputPhrase = "0";

  /*
   * Variables for store inputs.
   */
  String input1 = "";
  String input2 = "";
  String opr = "";

  /*
   * This function handles user inputs.
   * 
   * @param char is the input character from user.
   */
  void updateInputPhrase(String char) {
    if (isDigit(char)) {
      setState(() {
        textStyleIndex = 0;
        textColorsIndex = whichModeSelected;
      });
      if (inputPhrase != "") {
        if (inputPhrase[0] == "0") {
          if (inputPhrase.length > 1) {
            if (inputPhrase[1] == ".") {
              setState(() {
                inputPhrase += char;
              });
            }
          } else {
            setState(() {
              inputPhrase = char;
            });
          }
        } else if (isOperator(inputPhrase[0])) {
          opr = inputPhrase[0];
          inputPhrase = char;
        } else {
          setState(() {
            inputPhrase += char;
          });
        }
      } else {
        setState(() {
          inputPhrase += char;
        });
      }
    }

    // Clear entry
    if (char == "CE") {
      if (inputPhrase.length == 1) {
        setState(() {
          inputPhrase = "0";
        });
      } else {
        setState(() {
          inputPhrase = inputPhrase.substring(0, inputPhrase.length - 1);
        });
      }
    }

    // All clear
    if (char == "AC") {
      setState(() {
        textColorsIndex = whichModeSelected;
        textStyleIndex = 0;
        inputPhrase = "0";
        input1 = "";
        input2 = "";
        opr = "";
      });
    }

    if (char == "%") {
      input1 = inputPhrase;
      opr = "/";
      inputPhrase = "100";
      if (input1 != "0")
        calculate();
      else
        inputPhrase = "0";
    }

    if (isOperator(char)) {
      if (!isOperator(inputPhrase)) {
        input1 = inputPhrase;
        setState(() {
          textColorsIndex = 2;
          textStyleIndex = 2;
          inputPhrase = char;
        });
      } else {
        setState(() {
          inputPhrase = char;
        });
      }
    }

    if (char == "=") {
      calculate();
    }

    if (char == "+/-") {
      if (inputPhrase[0] != "-") {
        if (inputPhrase[0] != "0") {
          setState(() {
            inputPhrase = "-" + inputPhrase;
          });
        }
      } else {
        setState(() {
          inputPhrase = inputPhrase.substring(1, inputPhrase.length);
        });
      }
    }

    if (char == "." && !inputPhrase.contains(".")) {
      setState(() {
        inputPhrase += char;
      });
    }
  }

  /*
   * This function calculates the input phrase.
   */
  void calculate() {
    input2 = inputPhrase;

    String finalPhrase = input1 + opr + input2;
    print("num1 : " + input1);
    print("Operator : " + opr);
    print("num2 : " + input2);
    print(finalPhrase);
    finalPhrase = finalPhrase.replaceAll('x', '*');
    finalPhrase = finalPhrase.replaceAll('\u00f7', '/');

    Parser parser = Parser();
    Expression expression = parser.parse(finalPhrase);
    ContextModel contextModel = ContextModel();
    double answer = expression.evaluate(EvaluationType.REAL, contextModel);
    setState(() {
      inputPhrase = answer.toString();
      textColorsIndex = whichModeSelected;
      textStyleIndex = 1;
    });
  }

  /*
   * This function check if the input character is an operator or not.
   * 
   * @param char is the character for check if it is an operator.
   */
  bool isOperator(String char) {
    if (char == "\u00f7" || char == "x" || char == "-" || char == "+")
      return true;
    else
      return false;
  }

  /*
   * This function check if the input character is a number or not.
   * 
   * @param char is the character for check if it is n number.
   */
  bool isDigit(String char) {
    if (char != "AC" &&
        char != "%" &&
        char != "CE" &&
        char != "+/-" &&
        char != "." &&
        char != "=" &&
        !isOperator(char))
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColors[whichModeSelected],
      body: Container(
        child: Column(
          children: [
            // Toggle Buttons View
            Center(
              child: Container(
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: toggleColors[whichModeSelected],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ToggleButtons(
                  borderWidth: 0,
                  fillColor: toggleColors[whichModeSelected],
                  borderRadius: BorderRadius.circular(15.0),
                  isSelected: isSelected,
                  onPressed: (index) {
                    // Toggle Buttons selection
                    setState(() {
                      // Light mode
                      if (index == 0 && isSelected[index] == false) {
                        isSelected[index] = !isSelected[index];
                        isSelected[1] = false;
                        modeColors[0] = Colors.black;
                        modeColors[1] = Colors.grey;
                        whichModeSelected = 0;
                        textColorsIndex = 0;
                      }

                      // Dark mode
                      if (index == 1 && isSelected[index] == false) {
                        isSelected[index] = !isSelected[index];
                        isSelected[0] = false;
                        modeColors[0] = Colors.grey;
                        modeColors[1] = Colors.white;
                        whichModeSelected = 1;
                        textColorsIndex = 1;
                      }
                    });
                  },
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      color: modeColors[0],
                    ),
                    Icon(
                      Icons.dark_mode_outlined,
                      color: modeColors[1],
                    ),
                  ],
                ),
              ),
            ),
            // Input Box
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      inputPhrase,
                      style: TextStyle(
                          color: textColors[textColorsIndex],
                          fontSize: textSizes[textStyleIndex],
                          fontWeight: textWeights[textStyleIndex],
                          fontFamily: 'VarelaRound'),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 10, right: 20, bottom: 40, left: 20),
            ),
            // Calculator
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: toggleColors[whichModeSelected],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  children: List.generate(buttonsList.length, (index) {
                    // AC
                    if (index == 0) {
                      return CalButton(
                          textColor: signColors[0],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // +/-
                    if (index == 1) {
                      return CalButton(
                          textColor: signColors[0],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // %
                    if (index == 2) {
                      return CalButton(
                          textColor: signColors[0],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // Division
                    if (index == 3) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // X
                    if (index == 7) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // -
                    if (index == 11) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // +
                    if (index == 15) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                    // =
                    if (index == 19) {
                      return CalButton(
                          textColor: signColors[1],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    } else {
                      return CalButton(
                          textColor: numberColors[whichModeSelected],
                          color: buttonsColor[whichModeSelected],
                          buttonText: buttonsList[index],
                          selectedMode: whichModeSelected,
                          tapButtonFunc: updateInputPhrase);
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
