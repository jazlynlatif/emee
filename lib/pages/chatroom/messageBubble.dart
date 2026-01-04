import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final Alignment align;
  final String timeString;

  const MessageBubble({
    super.key,
    required this.message,
    required this.align,
    required this.timeString
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateTime time = DateTime.parse(timeString).toLocal();
    final timestamp = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.primary
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: align == Alignment.centerLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16
            ),
            textAlign: align == Alignment.centerRight ? TextAlign.right : TextAlign.left,
          ),
          Text(
            timestamp,
            style: TextStyle(
              fontSize: 8
            ),
          )
        ],
      ),
    );
  }
}