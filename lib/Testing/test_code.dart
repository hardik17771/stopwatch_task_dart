import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch_task/UI/stopwatch_interface.dart';


void main() {
  group('TaskStopWatch', () {
    late SharedPreferences sharedPreferences;

    setUp(() async {
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear(); // Clear any existing data
    });

    testWidgets('Start and stop the stopwatch', (WidgetTester tester) async {
      await tester.pumpWidget(TaskStopWatch());

      // Tap the start button
      await tester.tap(find.text('START'));
      await tester.pump();

      // Verify that the stopwatch is running
      expect(find.text('00:00:01'), findsOneWidget); // Assuming 1 second has passed

      // Tap the stop button
      await tester.tap(find.text('STOP'));
      await tester.pump();

      // Verify that the stopwatch has stopped
      expect(find.text('00:00:01'), findsOneWidget);
    });

    testWidgets('Record and reset lap times', (WidgetTester tester) async {
      await tester.pumpWidget(TaskStopWatch());

      // Start the stopwatch
      await tester.tap(find.text('START'));
      await tester.pump();

      // Record a lap time
      await tester.tap(find.text('LAP'));
      await tester.pump();

      // Verify that the lap time is displayed
      expect(find.text('00:00:01'), findsOneWidget);

      // Reset the stopwatch and lap times
      await tester.tap(find.text('RESET'));
      await tester.pump();

      // Verify that the lap times are cleared
      expect(find.text('00:00:01'), findsNothing);
    });

    testWidgets('Persistence of lap times', (WidgetTester tester) async {
      // Simulate previously recorded lap times in shared preferences
      await sharedPreferences.setStringList('lapTimes', ['00:00:01', '00:00:02']);

      await tester.pumpWidget(TaskStopWatch());

      // Verify that the previously recorded lap times are displayed
      expect(find.text('00:00:01'), findsOneWidget);
      expect(find.text('00:00:02'), findsOneWidget);
    });
  });
}


