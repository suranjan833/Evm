import 'package:flutter/material.dart';

class StartQuestion extends StatefulWidget {
  String questionDetails;
  String topic;
  String totalQuestion;
  String time;
  String pass;
  StartQuestion(
      {this.pass,
      this.time,
      this.totalQuestion,
      this.topic,
      this.questionDetails,
      Key key})
      : super(key: key);

  @override
  State<StartQuestion> createState() => _StartQuestionState();
}

class _StartQuestionState extends State<StartQuestion> {
  @override
  Widget build(BuildContext context) {
    print("all details");
    print(widget.questionDetails);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Test",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            )),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Latest Top 5 Winners",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Richard 4/4 ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      " Tom 3/4",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "John 3/4 ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Michael 2/4",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      " Brad 2/4",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffFF0000)),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 250,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${widget.questionDetails}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Topics: ${(widget.topic.toString() ?? "null")}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "3 People Took This",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                    "${widget.totalQuestion.toString() ?? "null"} multiple choice questions"),
                leading: Icon(Icons.more),
              ),
              ListTile(
                title: Text(
                    "${widget.time.toString() ?? "null"} for all questions"),
                leading: Icon(Icons.timer),
              ),
              ListTile(
                title: Text("Need to pass"),
                leading: Icon(Icons.calendar_month),
              ),
              Text(
                "Before you Start",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                " . You must complete this assessment in one session make sure your internet is reliable.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                " . tetst",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      'Back',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {},
                    /* style: FlaxButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),*/
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      'Start',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayQuiz(),
                          ));
                    },
                    /*style: FlaxButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),*/
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
