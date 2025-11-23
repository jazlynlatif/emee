import 'package:emee/pages/active-report.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void showNotif(servicename) {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Report to ${servicename}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Personal Info'
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => ActiveReport(service: servicename)), 
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
                      fontSize: 40
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                showNotif('MEDIC');
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
                      'MEDIC',
                      style : theme.textTheme.titleLarge
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'For Medical Emergencies',
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
                showNotif('FIRE DEPT');
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
                      'FIRE DEPT',
                      style : theme.textTheme.titleLarge
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'For Emergency Assistance',
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
            Text(
              '[logo]',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      )
    );
  }
}