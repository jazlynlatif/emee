import 'package:emee/widgets/victim-report.dart';
import 'package:flutter/material.dart';

class ActiveReport extends StatefulWidget {
  final String service;
  const ActiveReport({
    super.key,
    required this.service,
  });

  @override
  State<ActiveReport> createState() => _ActiveReportState();
}

class _ActiveReportState extends State<ActiveReport> {
  bool? _isVictimClarified;

  void clarifyVictim() {
    setState(() {
      _isVictimClarified = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'active report',
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.close),
            color: const Color.fromRGBO(255, 0, 0, 1),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.service} Emergency',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(
                height:15,
              ),
              // to seperate in different file
              _isVictimClarified == null ? Container(
                margin: EdgeInsets.all(30),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 211, 211, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 0, 0, 1),
                    width: 3
                  )
                ),
                child: Column(
                  children: [
                    Text(
                      'Who is the report for?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
          
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            clarifyVictim();
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
                            side: BorderSide(
                              color: const Color.fromRGBO(192, 192, 192, 1),
                              width: 2
                            )
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Me',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(1, 1, 1, 1)
                                ),
                              )
                            ],
                          )
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            clarifyVictim();
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
                            side: BorderSide(
                              color: const Color.fromRGBO(192, 192, 192, 1),
                              width: 2
                            )
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Other person',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(1, 1, 1, 1)
                                ),
                              )
                            ],
                          )
                        ),
                        Spacer()
                      ],
                    ),
                  ],
                ),
              ) : SizedBox(height: 5,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please Answer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(100),
                  side: BorderSide(
                    width: 2,
                    color: const Color.fromRGBO(169, 169, 169, 1)
                  )
                ),
                child: Text(
                  'ASSESMENT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(1, 1, 1, 1),
                    fontSize: 17
                  ),
                )
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Inbox',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromRGBO(169, 169, 169, 1)
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aids',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          'CPR'
                        ),
                      ),
                      Text(
                        'CPR',
                        style : theme.textTheme.labelMedium
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}