import 'dart:convert';

import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/patient-assesment-question.dart';
import 'package:emee/pages/chatroom/timer.dart';
import 'package:flutter/material.dart';

class PatientAssesment extends StatefulWidget {
  final int serviceid;
  final int victimid;
  final int victimNumId;

  const PatientAssesment({
    super.key,
    required this.serviceid,
    required this.victimid,
    required this.victimNumId
  });

  @override
  State<PatientAssesment> createState() => _PatientAssesmentState();
}

class _PatientAssesmentState extends State<PatientAssesment> {

  void completeAssesment() async {
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
                'Terimakasih telah isi Assesment!',
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

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) Navigator.pop(context);

    final report = await postReport(widget.serviceid);


    if(context.mounted && report != null) {
      if(report.statusCode == 200) {
        final reportdetails = jsonDecode(report.body)[0];
        final report_id = reportdetails['insertId'];
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => ChatRoom(service: widget.serviceid, reportid: report_id)), 
          (Route<dynamic> route) => false
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(report.body))
        );
      }
    }
                            
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getAssesment(widget.serviceid, widget.victimid, widget.victimNumId), 
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

        final questionListRaw = assesmentData['question_list'];
        final List questionList = questionListRaw.map((q) => q['question_text']).toList();

        final answerListRaw = assesmentData['answer_list'];
        final Map<int, List<String>> answerListMap = {};
        
        for (var item in answerListRaw) {
          final qid = item['question_id'];
          final atext = item['answer_text'];

          if(!answerListMap.containsKey(qid)) {
            answerListMap[qid] = [];
          }

          answerListMap[qid]!.add(atext);
        }
        final List<List<String>> answerList = answerListMap.values.toList();

        print(questionList);
        print(answerList);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Victim Assesment'
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
                  CountdownTimer(callback: (val) => setState(() => completeAssesment()),)
                ],
              ),
              Expanded(
                child: AssesmentQuestion(questionList: questionList, answerList: answerList, callback: (val) => setState(() => completeAssesment()))
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