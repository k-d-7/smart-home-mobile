import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class MyAssistancePage extends StatefulWidget {
  const MyAssistancePage({super.key});

  @override
  State<MyAssistancePage> createState() => _MyAssistancePageState();
}

class _MyAssistancePageState extends State<MyAssistancePage> {
  FlutterSoundRecorder _recordingSession = FlutterSoundRecorder();
  final recordingPlayer = AssetsAudioPlayer();

  bool recording = true;
  String pathToAudio = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    "Hello, I am an AI assistance.",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "How can I help you?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 204, 204, 204),
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    recording = !recording;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AudioRecordWidget(recording: recording),
                    SizedBox(height: 10),
                    Text(
                      '00:06',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}

class AudioRecordWidget extends StatelessWidget {
  const AudioRecordWidget({
    super.key,
    required this.recording,
  });

  final bool recording;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0x999999).withOpacity(.3),
          width: 3,
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            recording ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: Colors.white,
            key: ValueKey<bool>(recording),
            size: 40,
          ),
        ),
      ),
    );
  }
}
