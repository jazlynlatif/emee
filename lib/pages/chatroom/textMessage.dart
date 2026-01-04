import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  final int service;
  final int report;
  const TextMessage({
    super.key,
    required this.service,
    required this.report
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController _messageController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.grey
                  )
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(30)
            ),
            
            child: IconButton(
              onPressed: () async {
                if(_messageController.text.isNotEmpty || _messageController.text != '') {
                  await sendMessage(
                    _messageController.text, 
                    report
                  );
                  _messageController.clear();
                }
              }, 
              icon: Icon(Icons.send),
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
