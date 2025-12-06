import 'package:emee/pages/data.dart';
import 'package:emee/pages/home-page/profile_api.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List<String> filters = ['All', "On Going", "Completed"];
  late String selectedFilter;

  @override
  void initState() {
    // TODO: implement initState
    selectedFilter = filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'history'
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final String filter = filters[index];
                return Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedFilter == filter ? const Color.fromRGBO(255, 255, 255, 1) : const Color.fromRGBO(105, 105, 105, 1)
                        ),
                      ),
                      backgroundColor: selectedFilter == filter ? theme.colorScheme.primary : const Color.fromRGBO(235, 235, 235, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      side: BorderSide(
                        width: 2,
                        color: selectedFilter == filter ? theme.colorScheme.primary :const Color.fromRGBO(192, 192, 192, 1)
                      ),
                    )
                  ),
                );
              },
            ),
          ),
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

                final userData = snapshot.data!;

                return userData.isEmpty ? Center(child: Text('no reports so far :)')) 
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final data = userData[index];
                    final serviceName = Services.names[data['service_id']-1];
                    final DateTime time = DateTime.parse(data['created_at']).toLocal();
                    final timestamp = '${time.day.toString().padLeft(2, '0')} ' '${Utilities.months[time.month-1]},' ' ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timestamp,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.grey[600]
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: serviceName == 'MEDIC' ? Colors.blue : serviceName == 'FIRE DEPT' ? Colors.red : theme.colorScheme.primary,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                children: [
                                  Text(
                                    serviceName,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
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