import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:emee/pages/chatroom/messageBubble.dart';
import 'package:emee/pages/chatroom/textMessage.dart';
import 'package:emee/pages/data.dart';
import 'package:emee/pages/home-page/navpage.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final int service;
  final int reportid;
  final List<dynamic> mednotes;

  const ChatRoom({
    super.key,
    required this.service,
    required this.reportid,
    required this.mednotes
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool _endReport = false;

  // bool waitingunit = true;

  MessageBubble medNotesAppear() {
    String messageContent = widget.mednotes.map((item) {
    final title = item['title'] ?? '';
    final notes = item['notes'] ?? '';
    return '$title\n$notes';
  }).join('\n\n');
    return MessageBubble(
      message: messageContent, 
      align: Alignment.centerRight, 
      timeString: DateTime.now().toString()
    );
  }

  void thankYou () async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          content: const SizedBox(
            height: 60,
            child: Center(
              child : Column(
                children: [
                  Text(
                    'Laporan Selesai!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'terima kasih telah percaya pada kami',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );

    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) Navigator.pop(context);
  }

  void sessionDone() async {
    thankYou();

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (context) => const NavPage(),
      ),
      (Route<dynamic> route) => false
    );
  }

  void endSessionButton() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          title: const Text(
            'End report',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          content: const Text(
            'are you sure?',
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {

                showDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      content: const SizedBox(
                        height: 150,
                        child: Center(
                          child : Text(
                            'Laporan selesai!!',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                );

                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) Navigator.pop(context);

                final now = DateTime.now().toString();
                print(now);

                await postEndtime(widget.reportid, now);

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


  bool _checkUnit = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final servicename = widget.service == 1 ? 'Medic' : 'Fire Dept';

    List <Icon> theicons = [
      Icon(Icons.query_builder_sharp), 
      Icon(Icons.document_scanner_outlined), 
      Icon(Icons.fire_truck_outlined),
      Icon(Icons.run_circle_outlined),
      Icon(Icons.handyman_outlined),
      Icon(Icons.check)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          servicename
        ),
        backgroundColor: Colors.grey[200],
        // actions: [
        //   waitingunit 
        //   ? TextButton(
        //     onPressed: () {
        //       endSessionButton();
        //     }, 
        //     style: ButtonStyle(
        //       backgroundColor: WidgetStatePropertyAll(Color.fromRGBO(255, 0, 0, 1)),
        //     ),
        //     child: Text(
        //       'selesai',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold
        //       ),
        //     )
        //   )
        //   : SizedBox(width: 10,),
        //   SizedBox(width: 20,)
        // ],
        // actions: [
        //   ElevatedButton(
        //     onPressed: () {
        //       if (_checkUnit == false) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text('Unit Location Access Not Available'))
        //         );
        //       }
        //     }, 
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: _checkUnit ? Colors.green : Colors.grey[350]
        //     ),
        //     child: Text(
        //       'check unit',
        //       style: TextStyle(
        //         color: _checkUnit ? Colors.white : Colors.black
        //       ),
        //     )
        //   ),
        //   SizedBox(
        //     width: 5,
        //   )
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: getMessageAndStatus(widget.reportid), 
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
            
            
                final initialData = snapshot.data!;
            
                final userData = initialData['message'];
                final int progress = initialData['progress'];
                final endedat = initialData['endedat'];
            
                if (!_endReport && (endedat != null || progress == 6)) {
                  _endReport = true;
            
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    sessionDone();
                  });
                }
            
            
                print(_checkUnit);
            
                print(progress);
            
                // if (progress == 6) {
                //   endReport = true;
                // }

                if(progress>2) {
                  _checkUnit = true;
                }
            
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: progress == 1 ?Colors.black12 : progress == 6 ? Colors.blue[100] :Color.fromRGBO(174, 217, 167, 0.5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ReportChatroom.progressNames[progress-1],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          theicons[progress-1]
                        ],
                      ),
                    ),
                    Expanded(
                      child: userData.isEmpty ?
                      // ? widget.mednotes.isNotEmpty 
                      //     ? Align(alignment: Alignment.centerRight,child: medNotesAppear()) :
                          Align(alignment: Alignment.center, child: Text('mulai percakapan sekarang!')) 
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
                        ),
                    ),
                  ],
                );
              }
            ),
          ),
          TextMessage(service : widget.service, report :  widget.reportid),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}