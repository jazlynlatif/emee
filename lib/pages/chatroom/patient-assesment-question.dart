import 'package:flutter/material.dart';

class AssesmentQuestion extends StatefulWidget {
  final List<dynamic> questionList;
  final List<List<String>> answerList;
  final CallBack callback;

  const AssesmentQuestion({
    super.key,
    required this.questionList,
    required this.answerList,
    required this.callback
  });

  @override
  State<AssesmentQuestion> createState() => _AssesmentQuestionState();
}

typedef CallBack = void Function(bool val);

class _AssesmentQuestionState extends State<AssesmentQuestion> {
  late List<int> selectedIndex;

  void checkTest() {
    bool tOrF = selectedIndex.every((number) => number > -1);
    if (tOrF) {
      widget.callback(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = List<int>.filled(widget.questionList.length, -1);
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: selectedIndex.length,
      itemBuilder: (context, index) {
        final question = widget.questionList[index];
        final List<String> answers = widget.answerList[index];
        final int quesNo = index;
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal : 35, vertical: 15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.colorScheme.primaryContainer
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: answers.length,
                itemBuilder: (context, answerIndex) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex[quesNo] = answerIndex;
                        checkTest();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: selectedIndex.isEmpty ? Colors.white : selectedIndex[quesNo] == answerIndex ? Colors.red[100] : Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child:Text(
                        answers[answerIndex],
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        );
      }
    );
  }
}