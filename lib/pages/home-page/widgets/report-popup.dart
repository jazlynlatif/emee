import 'dart:convert';

import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/patient_assesment.dart';
import 'package:emee/pages/data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  late final List<String> victimNum;
  late final List<String> indicatorQuestion;

  late final List<Widget> victimsWidget;
  late final List<Widget> victimsNumWidget;

  late String _selectedVicValue;
  late String _selectedVicNumValue;
  
  late LatLng selectedLatLng ;
  
  int _selectedVicIndex = 0;
  int _selectedVicNumIndex = 0;

  final MapController _mapController = MapController();
  bool _mapReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedVicValue = ReportPopUpData.medicIndicator1[0];
    _selectedVicNumValue = ReportPopUpData.medicIndicator2[0];
    selectedLatLng = LatLng(widget.position.latitude, widget.position.longitude);
    victimNum = widget.serviceid == 1 ? ReportPopUpData.medicIndicator2 : ReportPopUpData.fireIndicator2;

    victimsWidget = widget.serviceid == 1 ? ReportPopUpData.medicIndicator1.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold),))).toList() : ReportPopUpData.fireIndicator1.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),))).toList();
    
    victimsNumWidget = widget.serviceid == 1 ? ReportPopUpData.medicIndicator2.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),))).toList() : ReportPopUpData.fireIndicator2.map((value) => Container(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),child: Text(value, style: TextStyle(fontWeight: FontWeight.bold,),))).toList();

    indicatorQuestion = ReportPopUpData.indicatorQuestion[widget.serviceid-1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Lapor ke ${serviceName[widget.serviceid-1]}',
                style: theme.textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Text(
              'Lokasi',
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: FlutterMap(
                mapController: MapController(),
                options : MapOptions(
                  initialCenter: selectedLatLng,
                  initialZoom: 17,
                  onTap: (tapPosition, latLng) {
                    setState(() {
                      selectedLatLng = latLng;
                    });
                    if (_mapReady) {
                      _mapController.move(latLng, 16);
                    }
                  },
                ),
                children : [
                  TileLayer(
                    urlTemplate: 'https://api.maptiler.com/maps/base-v4/{z}/{x}/{y}.png?key=P40e2FSbT2joZsUYelmi',
                    userAgentPackageName: 'com.example.emee',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        '© MapTiler © OpenStreetMap contributors',
                        // onTap: () => launchUrl(
                        //   Uri.parse('https://www.maptiler.com/copyright/'),
                        // ),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedLatLng,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              indicatorQuestion[0],
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
              height: 20,
            ),
            Text(
              indicatorQuestion[1],
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
                onPressed: () async {

                  final report = await postReport(widget.serviceid, _selectedVicIndex,_selectedVicNumIndex + 1, selectedLatLng.latitude, selectedLatLng.longitude);

                  if(context.mounted && report != null) {
                    if(report.statusCode == 200) {
                      final reportdetails = jsonDecode(report.body);
                      final report_id = reportdetails['insertId'];
                      print(report_id);
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => PatientAssesment(serviceid: widget.serviceid, indicator1: _selectedVicIndex, indicator2: _selectedVicNumIndex + 1,reportid: report_id,)), 
                        (Route<dynamic> route) => false
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(report.body))
                      );
                    }
                  }

                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'LAPORKAN',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ],
        )
        ,
      ),
    );
  }
}