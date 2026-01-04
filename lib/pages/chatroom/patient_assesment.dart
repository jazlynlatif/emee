import 'dart:convert';

import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/patient-assesment-question.dart';
import 'package:emee/pages/chatroom/timer.dart';
import 'package:emee/pages/home-page/profile_api.dart';
import 'package:flutter/material.dart';

class PatientAssesment extends StatefulWidget {
  final int serviceid;
  final int indicator1;
  final int indicator2;
  final int reportid;

  const PatientAssesment({
    super.key,
    required this.serviceid,
    required this.indicator1,
    required this.indicator2,
    required this.reportid,
  });

  @override
  State<PatientAssesment> createState() => _PatientAssesmentState();
}

class _PatientAssesmentState extends State<PatientAssesment> {
  final controller = AssesmentQuestionController();

  void onTimeUp() {
    controller.forceSubmit?.call();
  }

  void completeAssesment(List<int> userAnswer, List<List<int>> answerId, int assesmentid, List<int> questionId) async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          content: const SizedBox(
            height: 60,
            child: Center(
              child : Text(
                'Terimakasih telah isi evaluasi!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        );
      }
    );

    final List<dynamic> finalUserAnswer = [];
    for(int i =0;i< userAnswer.length;i++) {
      final answerid = userAnswer[i];
      late final final_answerid;
      if(answerid == -1) {
        final_answerid = null;
      }
      else {
        final_answerid = answerId[i][answerid];
      }

      finalUserAnswer.add(final_answerid);
    }

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) Navigator.pop(context);

    late final report;
    late final List<dynamic> mednotes;

    try {
      report = await postUserAnswer(widget.reportid, assesmentid, finalUserAnswer, questionId);

      if(widget.indicator1 == 0) {
        mednotes = await fetchData('mednotes');
      } else {
        mednotes = [];
      }

      print(mednotes);

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => ChatRoom(service: widget.serviceid, reportid: widget.reportid, mednotes: mednotes,)), 
        (Route<dynamic> route) => false
      );

    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString()))
      );
    }               
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAssesment(widget.serviceid, widget.indicator1, widget.indicator2), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError) {
          return Center(child: Text("Error : ${snapshot.error}"),);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No data"));
        }

        final assesmentData = snapshot.data!;

        print(widget.serviceid);

        final assesmentid = assesmentData['assesment_id'];

        final questionListRaw = assesmentData['question_list'];
        final List questionList = questionListRaw.map((q) => q['question_text']).toList();

        final List<dynamic> answerListRaw = assesmentData['answer_list'];
        final Map<int, List<String>> answerListMap = {};
        final Map<int, List<int>> answerIdMap = {};

        
        for (var item in answerListRaw) {
          final qid = item['question_id'];
          final atext = item['answer_text'];
          final aid = item['id'];

          answerListMap.putIfAbsent(qid, () => []);
          answerListMap[qid]!.add(atext);

          answerIdMap.putIfAbsent(qid, () => []);
          answerIdMap[qid]!.add(aid);
        }
        final List<List<String>> answerList = answerListMap.values.toList();
        final List<List<int>> answerIdList = answerIdMap.values.toList();

        // print(answerIdMap);
        List<int> questionId = answerIdMap.keys.toList();
        print(questionId);


        print('this is the questionid');
        print(answerIdList);

        print('this is the question list raw');
        print(questionId);

        print('this is the questionlist');
        print(questionList);

        print('this is the answerid');
        print(answerIdList);

        print('this is the answerlist');
        print(answerList);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Evaluasi'
            ),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'laporan akan secara otomatis dikirim dalam  '
                  ),
                  CountdownTimer(callback: (val) => setState(() => onTimeUp()),)
                ],
              ),
              Expanded(
                child: AssesmentQuestion(questionList: questionList, answerList: answerList, callback: (val) => completeAssesment(val, answerIdList, assesmentid, questionId), controller: controller,)
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }
    );
  }
}