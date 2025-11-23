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
          )
        ],
      ),
    );
  }
}