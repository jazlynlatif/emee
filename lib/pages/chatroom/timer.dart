import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final CallBack callback;
  const CountdownTimer({
    super.key,
    required this.callback
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

typedef CallBack = void Function(bool val);

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  int _seconds = 60;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_seconds > 0) {
          _seconds =_seconds - 1;
        } else {
          _timer.cancel();
          widget.callback(true);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _seconds <= 59 ? '00:$_seconds' : '0${(_seconds/60).floor()}:${_seconds - ((_seconds/60).floor()*60) > 9 ? '' : '0'}${_seconds - ((_seconds/60).floor()*60)}',
      style: TextStyle(
        color: Color.fromRGBO(255, 1, 1, 1),
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),
    );
  }
}