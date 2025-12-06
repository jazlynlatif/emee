import 'dart:convert';

import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/patient_assesment.dart';
import 'package:emee/pages/data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ReportPopUp extends StatefulWidget {
  final int serviceid;
  final Position position;
  const ReportPopUp({
    super.key,
    required this.serviceid,
    required this.position
  });

  @override
  State<ReportPopUp> createState() => _ReportPopUpState();
}

class _ReportPopUpState extends State<ReportPopUp> {
  final List<String> serviceName = Services.names;
  final List<String> victimNum = ReportPopUpData.victimNum;
  final List<Widget> victimsWidget = ReportPopUpData.victim.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold),))).toList();
  final List<Widget> victimsNumWidget = ReportPopUpData.victimNum.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold),))).toList();
  late String _selectedVicValue;
  late String _selectedVicNumValue;
  
  int _selectedVicIndex = 0;
  int _selectedVicNumIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedVicValue = ReportPopUpData.victim[0];
    _selectedVicNumValue = ReportPopUpData.victimNum[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Report to ${serviceName[widget.serviceid-1]}',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                'Location',
                style: theme.textTheme.titleSmall,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.position.toString(),
                style: TextStyle(
                  fontSize: 18
                )
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Untuk siapa?',
                style: theme.textTheme.titleSmall,
              ),
              SizedBox(
                height: 10,
              ),
              ToggleButtons(
                selectedColor: Colors.black,
                fillColor: theme.colorScheme.primary,
                isSelected: List.generate(victimsWidget.length, (i) => i == _selectedVicIndex),
                onPressed: (index) {
                  setState(() {
                    _selectedVicIndex = index;
                  });
                },
                children: victimsWidget, 
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Jumlah pasien/korban?',
                style: theme.textTheme.titleSmall,
              ),
              SizedBox(
                height: 10,
              ),
              ToggleButtons(
                selectedColor: Colors.black,
                fillColor: theme.colorScheme.primary,
                isSelected: List.generate(victimsNumWidget.length, (i) => i == _selectedVicNumIndex),
                onPressed: (index) {
                  setState(() {
                    _selectedVicNumIndex = index;
                  });
                },
                children: victimsNumWidget, 
              ),
              SizedBox(
                height: 35,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => PatientAssesment(serviceid: widget.serviceid, victimid: _selectedVicIndex, victimNumId: _selectedVicNumIndex + 1,)), 
                      (Route<dynamic> route) => false
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'REPORT',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}