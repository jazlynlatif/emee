import 'package:flutter/material.dart';

class VictimeReport extends StatelessWidget {
  const VictimeReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onPressed: () {}, 
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
                onPressed: () {}, 
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
    );
  }
}