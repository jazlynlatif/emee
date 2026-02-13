import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/data.dart';
import 'package:emee/pages/home-page/widgets/chatroom-history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportHistory extends StatefulWidget {
  final Map data;
  const ReportHistory({
    super.key,
    required this.data,
  });

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {

  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('this is widget.data');
    print(widget.data);

    final DateTime timeStart = DateTime.parse(widget.data['created_at']).toLocal();
    final timestampStart = '${timeStart.day.toString().padLeft(2, '0')} ' '${Utilities.monthsFull[timeStart.month-1]} ' '${timeStart.year}, ' ' ${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}';

    final DateTime timeEnd = DateTime.parse(widget.data['ended_at']).toLocal();
    final timestampEnd = '${timeEnd.day.toString().padLeft(2, '0')} ' '${Utilities.monthsFull[timeEnd.month-1]} ' '${timeEnd.year}, ' ' ${timeEnd.hour.toString().padLeft(2, '0')}:${timeEnd.minute.toString().padLeft(2, '0')}';
    
    final MapController _mapController = MapController();

    final servicename = Services.names[widget.data['service_id']-1];
    

    final lat = widget.data['latitude'];
    final long = widget.data['longitude'];

    return Scaffold(
      appBar: AppBar(
        title: Text(servicename),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getReportInformation(widget.data['report_id'], 0, widget.data['service_id']), 
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
          
                final userData = snapshot.data!;

                print('${widget.data['service_id']} ${widget.data['report_id']}');

                final initialData = userData[0];
                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: FlutterMap(
                        mapController: _mapController,
                        options : MapOptions(
                          initialCenter: LatLng(lat, long),
                          initialZoom: 17,
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
                                point: LatLng(lat, long),
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
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => ChatRoomHistory(service: widget.data['service_id'], reportid: widget.data['report_id'],))
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                )
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.25), 
                                //     spreadRadius: 2, 
                                //     blurRadius: 2, 
                                //     offset: Offset.zero, 
                                //   )
                                // ]
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble,
                                    color: theme.colorScheme.primary,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Chatroom',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Spacer(),
                                  // IconButton(
                                  //   onPressed: () async {
                                  //     // try {
                                  //     //    await openLocation(-7.0064, 110.4323);
                                  //     // } catch (err) {
                                  //     //   ScaffoldMessenger.of(context).showSnackBar(
                                  //     //     SnackBar(content: Text(err))
                                  //     //   );
                                  //     // }
                                  //   }, 
                                  //   icon: Icon(Icons.link)
                                  // )
                                ],
                              ),
                            ),
                          ),
                          // ChatRoomHistory(username: initialData['username'],reportid: widget.data['report_id']),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lokasi',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.data['latitude']}, ${widget.data['longitude']}',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Dilaporkan pada',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${timestampStart}',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Selesai pada',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  timestampEnd,
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      // decoration: BoxDecoration(
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.25), 
                      //       spreadRadius: 2, 
                      //       blurRadius: 2, 
                      //       offset: Offset.zero, 
                      //     )
                      //   ]
                      // ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25), 
                              spreadRadius: 0.5, 
                              blurRadius: 2, 
                              offset: Offset.zero, 
                            )
                          ]
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: theme.colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Assesment',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Divider(
                            //   color: theme.colorScheme.primary,
                            //   thickness: 2,
                            // ),
                            SizedBox(
                              height: 120,
                              child: FutureBuilder(
                                future: getAssesmentResult(widget.data['report_id']), 
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

                                  final userData = snapshot.data!;

                                  return userData.isEmpty
                                  ? Center(child: Text('tidak terjawab', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 15)),)
                                  : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: userData.length,
                                    itemBuilder: (context, index) {
                                      final data = userData[index];
                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: theme.colorScheme.primary, 
                                              spreadRadius: 0.25, 
                                              blurRadius: 2, 
                                              offset: Offset.zero, 
                                            )
                                          ]
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['question'],
                                              style: theme.textTheme.titleSmall,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: data['answer'] == null
                                              ? Text('Tidak dijawab')
                                              : Text(
                                                data['answer'],
                                                style: TextStyle(
                                                  fontSize: 12
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  );
                                }
                              )
                            )
                          ],
                        ),
                      )
                    ),
                  ],
                );
            }
           ),
        )
      ),
    );
  }
}