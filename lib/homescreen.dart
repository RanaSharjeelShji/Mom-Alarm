import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_00/edit_alarm.dart';
import 'package:flutter_application_00/ring_alarm.dart';
import 'package:flutter_application_00/tile.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;
  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: AlarmEditScreen(alarmSettings: settings),
          );
        });

    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          'Mom Alarm',
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigateToAlarmScreen(null);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: alarms.isNotEmpty
            ? Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            20.0), // Adjust the radius as needed
                        bottomRight: Radius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    child: DigitalClock(
                      secondDigitTextStyle:
                          TextStyle(fontSize: h * .03, color: Colors.white),
                      hourMinuteDigitTextStyle:
                          TextStyle(fontSize: h * .1, color: Colors.white),
                      colon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ":",
                          style:
                              TextStyle(fontSize: h * .09, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: alarms.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        String result = DateFormat('yyyy-MM-dd')
                            .format(alarms[index].dateTime);
                        return AlarmTile(
                          Day: result,
                          key: Key(alarms[index].id.toString()),
                          title: TimeOfDay(
                            hour: alarms[index].dateTime.hour,
                            minute: alarms[index].dateTime.minute,
                          ).format(context),
                          onPressed: () => navigateToAlarmScreen(alarms[index]),
                          onDismissed: () {
                            Alarm.stop(alarms[index].id)
                                .then((_) => loadAlarms());
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            20.0), // Adjust the radius as needed
                        bottomRight: Radius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    child: DigitalClock(
                      secondDigitTextStyle:
                          TextStyle(fontSize: h * .03, color: Colors.white),
                      hourMinuteDigitTextStyle:
                          TextStyle(fontSize: h * .1, color: Colors.white),
                      colon: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: h * .09, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.25),
                  const Text(
                    "No alarms set",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  ElevatedButton.icon(
                      style: ButtonStyle(
                        elevation:
                            MaterialStateProperty.all(0), // Set elevation to 0
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurpleAccent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.alarm_add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        navigateToAlarmScreen(null);
                      },
                      label: const Text(
                        "Set Alarm",
                        style: TextStyle(color: Colors.white),
                      )),
                
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
