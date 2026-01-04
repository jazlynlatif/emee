import 'package:emee/pages/data.dart';
import 'package:emee/pages/home-page/profile_api.dart';
import 'package:emee/pages/home-page/widgets/chatroom-history.dart';
import 'package:emee/pages/home-page/widgets/report-history.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Riwayat'
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchReportHistory(), 
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

                if (snapshot.hasData) {
                  final data = snapshot.data;

                  if (data is Map && data.containsKey("error")) {
                    return Center(child: Text("Unauthorized. Please log in again."));
                  }
                }

                final userData = snapshot.data!;

                print('i am here');

                return userData.isEmpty ? Center(child: Text('Tidak ada laporan :)')) 
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final data = userData[index];
                    final serviceName = Services.names[data['service_id']-1];
                    final DateTime time = DateTime.parse(data['created_at']).toLocal();
                    final timestamp = '${time.day.toString().padLeft(2, '0')} ' '${Utilities.months[time.month-1]},' ' ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    return GestureDetector(
                      onTap: () {
                        print('this is triggered');
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ReportHistory(data: data))
                        );
                        // Navigator.push(
                        //   context, 
                        //   MaterialPageRoute(builder: (context) => ChatRoomHistory(service: Services.names[data['service_id']-1], reportid: data['report_id']))
                        // );
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25), 
                              spreadRadius: 2, 
                              blurRadius: 2, 
                              offset: Offset.zero, 
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: serviceName == 'MEDIS' ? Colors.blue : serviceName == 'DAMKAR' ? Colors.red : theme.colorScheme.primary,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceName,
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'latitide: ${data['latitude']}\nlongitude: ${data['longitude']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  timestamp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey[600]
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              }
            ),
          )
        ],
      ),
    );
  }
}