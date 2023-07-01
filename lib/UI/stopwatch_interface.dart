import 'dart:async';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
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
  bool isRunning = false;
  List<String> lapTimes = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadLapTimes();
  }


  void loadLapTimes() {
    final savedLapTimes = sharedPreferences.getStringList('lapTimes');
    if (savedLapTimes != null) {
      setState(() {
        lapTimes = savedLapTimes;
      });
    }
  }

  void saveLapTimes() {
    sharedPreferences.setStringList('lapTimes', lapTimes);
  }

  @override
  void dispose() {
    timerSubscription.cancel();
    super.dispose();
  }

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
                    onPressed: isRunning ? stopStopwatch : startStopwatch,
                    child: Text(
                      isRunning ? 'STOP' : 'START',
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
                    onPressed: resetStopwatch,
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
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: isRunning ? recordLapTime : null,
              child: Text(
                'LAP',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: lapTimes.length,
                itemBuilder: (context, index) {
                  final lapTime = lapTimes[index];
                  return ListTile(
                    title: Text(lapTime),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startStopwatch() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setState(() {
        hoursStr = ((newTick / (60 * 60)) % 60)
            .floor()
            .toString()
            .padLeft(2, '0');
        minutesStr =
            ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopStopwatch() {
    timerSubscription.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetStopwatch() {
    timerSubscription.cancel();
    setState(() {
      hoursStr = '00';
      minutesStr = '00';
      secondsStr = '00';
      lapTimes.clear();
    });
    saveLapTimes();
  }

  void recordLapTime() {
    final lapTime = "$hoursStr:$minutesStr:$secondsStr";
    setState(() {
      lapTimes.insert(0, lapTime);
    });
    saveLapTimes();
  }
}
