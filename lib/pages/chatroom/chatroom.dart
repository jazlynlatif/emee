import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/messageBubble.dart';
import 'package:emee/pages/chatroom/textMessage.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final int service;
  final int reportid;

  const ChatRoom({
    super.key,
    required this.service,
    required this.reportid,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  void endSessionButton() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'End report',
            style: TextStyle(
              color: Color.fromRGBO(255, 0, 0, 1),
              fontWeight: FontWeight.bold
            ),
          ),
          content: const Text(
            'are you sure?',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const NavPage(),
                  ),
                  (Route<dynamic> route) => false
                );
              }, 
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(1, 1, 1, 1)
                ),
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              }, 
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 150, 255, 1)
                ),
              )
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final servicename = widget.service == 1 ? 'Medic' : 'Fire Dept';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          servicename
        ),
        backgroundColor: Colors.grey[200],
        actions: [
          TextButton(
            onPressed: () {
              endSessionButton();
            }, 
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(255, 0, 0, 1)),
            ),
            child: Text(
              'end report',
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(),
            child: StreamBuilder(
              stream: getMessage(widget.reportid, widget.service), 
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

                return userData.isEmpty ? Center(child: Text('start messaging now!')) 
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final data = userData[index];
                      final align = data['sender'] == 0 ? Alignment.centerRight : Alignment.centerLeft;
                      return Align(
                        alignment: align,
                        child: MessageBubble(
                          message: data['text_content'], 
                          align: align, 
                          timeString: data['created_at']
                        ),
                      );
                    }
                  );
              }
            )
          ),
          Spacer(),
          TextMessage(service : widget.service, report :  widget.reportid),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}