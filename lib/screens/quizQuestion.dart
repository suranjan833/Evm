import 'package:active_ecommerce_flutter/screens/startQuestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:active_ecommerce_flutter/data_model/variant_response.dart';
import 'package:http/http.dart' as http;

class QuizQuestion extends StatefulWidget {
  QuizQuestion({Key key}) : super(key: key);

  @override
  State<QuizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  List question = [
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    },
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    },
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    },
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    },
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    },
    {
      "question": " how to elon musk",
      "topic": " HTML5",
      "look": "0",
      "image": "assets/app_logo.png"
    }
  ];

  List quizQuestion = List.empty(growable: true);

  @override
  void initState() {
    getQuizQuestion();
    super.initState();
  }

  Future getQuizQuestion() async {
    http.Response response = await http
        .get(Uri.parse("https://www.elonmuskvision.com/api/v1/quiz/tesla"));
    setState(() {
      var data = jsonDecode(response.body.toString());
      print(data);
      quizQuestion.add(data);
    });

    print("arun");

    print(quizQuestion);
    print(quizQuestion.length);
    // getquiz();
  }

  // getquiz() {
  //   for (int i = 0; i < quizQuestion.length; i++) {
  //     newlist.add(quizQuestion[i]["topicdata"][i]);
  //   }
  //   print(newlist);
  // }

  String year;
  String month;
  String week;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text(
              "Quiz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(children: [
            Text(
              "Test your Knowledge",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "To earn a skill badge, please choose a topic from the below list and answer all the questions within the given time frame.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: year,
                  hint: Text("Year"),
                  items: <String>[
                    "2013",
                    "2014",
                    "2015",
                    "2016",
                    "2017",
                    "2018",
                    "2019",
                    "2020 ",
                    "2021",
                    "2022",
                    "2023",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      year = v;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: month,
                  hint: Text("Month"),
                  items: <String>[
                    "Jaunary",
                    "Febuary",
                    "March",
                    "April",
                    "May",
                    "June",
                    "July",
                    "August ",
                    "September",
                    "October",
                    "November",
                    "December"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      month = v;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: week,
                  hint: Text("Week"),
                  items: <String>[
                    "Week 1",
                    "Week 2",
                    "Week 3",
                    "Week 4",
                    "Week 5",
                    "Week 6",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      week = v;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.red,
              child: Text('Search',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              onPressed: () {},
              /*style: FlaxButton.styleFrom(
                  primary: Colors.red,
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),*/
            ),
            SizedBox(
                height: 390,
                child: (quizQuestion.isNotEmpty)
                    ? ListView.builder(
                        itemCount: quizQuestion[0]["topicdata"].length,
                        itemBuilder: (cnt, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/app_logo.png",
                                    height: 150,
                                    width: 80,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 270,
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          "${quizQuestion[0]["topicdata"][index]["title"]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Topics: HTML5",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "0 People Took This",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              MaterialButton(
                                color: Colors.red,
                                child: Text(
                                  'Start Now',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StartQuestion(
                                          pass: quizQuestion[0]["topicdata"]
                                              [index][" "],
                                          time: quizQuestion[0]["topicdata"]
                                                  [index]["time_per_question"]
                                              .toString(),
                                          totalQuestion: quizQuestion[0]
                                                      ["topicdata"][index]
                                                  ["total_question"]
                                              .toString(),
                                          topic: quizQuestion[0]["topicdata"]
                                              [index]["tags"][0]["tags"],
                                          questionDetails: quizQuestion[0]
                                              ["topicdata"][index]["title"],
                                        ),
                                      ));
                                },
                               /* style: FlaxButton.styleFrom(
                                    primary: Colors.red,
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),*/
                              ),
                            ],
                          );
                        })
                    : Center(child: CircularProgressIndicator())),
          ]),
        ),
      ),
    );
  }
}
