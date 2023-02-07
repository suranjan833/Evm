import 'package:active_ecommerce_flutter/screens/resultpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({Key key}) : super(key: key);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  bool firstquestion = false;
  bool secondquestion = false;
  bool thirdquestion = false;
  bool fourthquestion = false;
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Test",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: Text(
              "Q1 . Who is Elon Musk  ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          _myRadioButton(
            title: "A",
            value: 0,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: "B",
            value: 1,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: "C",
            value: 2,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          _myRadioButton(
            title: "D",
            value: 3,
            onChanged: (newValue) => setState(() => _groupValue = newValue),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.blue,
                child: Text('Previous',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ProfileScreen(),
                  //     ));
                },
              /*  style: FlatButton.styleFrom(
                    primary: Colors.blue,
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),*/
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text('show my result',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ResultPage(),
                  //     ));
                },
               /* style: FlaxButton.styleFrom(
                    primary: Colors.blue,
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),*/
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

// Row(
//             children: [
//               Radio(
//                   activeColor: Colors.amber,
//                   value: firstquestion,
//                   groupValue: firstquestion,
//                   onChanged: (value) {
//                     setState(() {
//                       firstquestion = !value;
//                     });
//                   }),
//               Text(
//                 "Test",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               )
//             ],
//           ),
//           Row(
//             children: [
//               Radio(
//                   value: secondquestion,
//                   groupValue: secondquestion,
//                   onChanged: (value) {
//                     setState(() {
//                       secondquestion = !value;
//                     });
//                   }),
//               Text(
//                 "Test",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               )
//             ],
//           ),
//           Row(
//             children: [
//               Radio(
//                   value: thirdquestion,
//                   groupValue: thirdquestion,
//                   onChanged: (value) {
//                     setState(() {
//                       thirdquestion = !value;
//                     });
//                   }),
//               Text(
//                 "Test",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               )
//             ],
//           ),
//           Row(
//             children: [
//               Radio(
//                   value: fourthquestion,
//                   groupValue: fourthquestion,
//                   onChanged: (value) {
//                     setState(() {
//                       fourthquestion = !value;
//                     });
//                   }),
//               Text(
//                 "Test",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               )
//             ],
//           )
}
