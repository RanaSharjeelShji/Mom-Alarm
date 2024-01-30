import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_00/stop.dart';
import 'package:lottie/lottie.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

class AlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Your alarm  is ringing...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Lottie.asset('assets/Animation - 1706292019590.json'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            height: MediaQuery.of(context).size.height * .08,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(
                                  0,
                                ), // Set elevation to 0
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepPurple),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StopScreen(
                                        alarmSettings: alarmSettings),
                                  ),
                                );
                              },
                              child: Text(
                                "STOP ALARM",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Focus(
                    autofocus: true,
                    onKeyEvent: (node, event) {
                      if (event.physicalKey ==
                              PhysicalKeyboardKey.audioVolumeUp ||
                          event.physicalKey ==
                              PhysicalKeyboardKey.audioVolumeDown) {
                        print(
                            'button button ${event.physicalKey.debugName}');
                            PerfectVolumeControl.setVolume(10 );
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: const Text(""),
                  )
          ],
        ),
      ),
    );
  }
}
