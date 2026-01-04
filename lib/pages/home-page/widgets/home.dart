import 'dart:convert';
import 'package:emee/pages/chatroom/chatroom.dart';
import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/home-page/widgets/report-popup.dart';
import 'package:emee/services/geolocator_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:emee/pages/data.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserPosition currPosition = UserPosition();
  final List<String> serviceName = Services.names;
  
  void showNotif(serviceid) async {

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          content: const SizedBox(
            height: 60,
            child: Center(
              child : CircularProgressIndicator(),
            ),
          ),
        );
      }
    );

    late Position position;

    try {
      position = await currPosition.getCurrentLocation();
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching location : $err'))
      );
    } 

    if(context.mounted) {
      Navigator.of(context).pop();
    }

    print(position.latitude);
    print(position.longitude);
;
    if(context.mounted && position != null) {
      final theme = Theme.of(context);
      showDialog(
        context: context, 
        builder: (context) {
          return ReportPopUp(serviceid: serviceid,position: position);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : const Text(
          'emee'
        )
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showNotif(1);
              },
              child: Container(
                margin : EdgeInsets.symmetric(vertical : 20, horizontal : 40),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Services.names[0],
                      style : theme.textTheme.titleLarge
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      Services.tags[0],
                      style: TextStyle(
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'lib/assets/ambulance.png',
                        height: 80,
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showNotif(2);
              },
              child: Container(
                margin : EdgeInsets.symmetric(vertical : 20, horizontal : 40),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Services.names[1],
                      style : theme.textTheme.titleLarge
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      Services.tags[1],
                      style: TextStyle(
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'lib/assets/firetruck.png',
                        height: 80,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Text(
            //   '[logo]',
            //   style: theme.textTheme.titleLarge,
            // ),
            // SizedBox(
            //   height: 30,
            // )
          ],
        ),
      )
    );
  }
}