import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stopwatch_task/Stream/stopwatch_stream.dart';

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
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF011A67),
      appBar: AppBar(
        backgroundColor: Color(0xFF397097).withOpacity(0.45),
        title: Text(
          "Non-Stopwatch ",
          style: GoogleFonts.inter(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                textDirection: TextDirection.ltr,
                children: [
                  SvgPicture.network(
                    'https://filebin.net/0xfy0mglcdst5yg5/Ellipse11.svg',
                    width: screen_width * 0.32,
                    height: screen_height * 0.32,
                  ),
                  Positioned(
                    left: screen_width * 0.121,
                    bottom: 120,
                    right: screen_width * 0.121,
                    child: Text(
                      "$hoursStr:$minutesStr:$secondsStr",
                      style: GoogleFonts.inter(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Container(
                      height: screen_height * 0.0692,
                      width: screen_width * 0.2916,
                      child: ElevatedButton(
                        onPressed: isRunning ? stopStopwatch : startStopwatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF435BA0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.white, width: 3.0),
                          ),
                        ),
                        child: Text(
                          isRunning ? 'STOP' : 'START',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Container(
                      height: screen_height * 0.0692,
                      width: screen_width * 0.2916,
                      child: ElevatedButton(
                        onPressed: resetStopwatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF435BA0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.white, width: 3.0),
                          ),
                        ),
                        child: Text(
                          'RESET',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Container(
                height: screen_height * 0.09,
                width: screen_width * 0.2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF397097),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      side: BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                  onPressed: isRunning ? recordLapTime : null,
                  child: Text(
                    'LAP',
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screen_height * 0.036,),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF397097).withOpacity(0.45),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Adjust the value to control the roundness
                  ),
                  height: screen_height * 0.18,
                  child: ListView.builder(
                    itemCount: lapTimes.length,
                    itemBuilder: (context, index) {
                      final lapTime = lapTimes[index];
                      return ListTile(
                        title: Text(
                          lapTime,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
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
