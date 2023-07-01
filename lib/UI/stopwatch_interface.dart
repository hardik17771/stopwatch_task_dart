import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopwatch_task/UI/stopwatch_stream.dart';

class TaskStopWatch extends StatefulWidget {
  @override
  _TaskStopWatchState createState() => _TaskStopWatchState();
}

class _TaskStopWatchState extends State<TaskStopWatch> {

  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter StopWatch")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$hoursStr:$minutesStr:$secondsStr",
              style: TextStyle(
                fontSize: 90.0,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: ElevatedButton(

                    onPressed: () {
                      timerStream = stopWatchStream();
                      timerSubscription = timerStream.listen((int newTick) {
                        setState(() {
                          hoursStr = ((newTick / (60 * 60)) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          minutesStr = ((newTick / 60) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                          secondsStr =
                              (newTick % 60).floor().toString().padLeft(2, '0');
                        });
                      });
                    },

                    child: Text(
                      'START',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      timerSubscription.cancel();
                      // timerStream =
                      setState(() {
                        hoursStr = '00';
                        minutesStr = '00';
                        secondsStr = '00';
                      });
                    },

                    child: Text(
                      'RESET',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}