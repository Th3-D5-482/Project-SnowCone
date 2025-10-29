import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DisplayLyrics extends StatefulWidget {
  final String audio;
  const DisplayLyrics({super.key, required this.audio});

  @override
  State<DisplayLyrics> createState() => _DisplayLyricsState();
}

class _DisplayLyricsState extends State<DisplayLyrics> {
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.durationStream.listen((duration) {
      setState(() {
        totalDuration = duration ?? Duration.zero;
      });
    });
    player.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });
    //player.play();
    player.setUrl(widget.audio);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade900,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  bool isDesktop =
                      (kIsWeb || Platform.isWindows) && screenWidth > 1000;
                  // ignore: unused_local_variable
                  double horizontalPadding = isDesktop ? 200 : 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: kIsWeb ? 16 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        kIsWeb ? SizedBox(height: 0) : SizedBox(height: 40),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: 28,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
                            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
                            'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = totalDuration;
                  return Slider(
                    min: 0,
                    max: duration.inMilliseconds.toDouble(),
                    value: position.inMilliseconds
                        .clamp(0, duration.inMilliseconds)
                        .toDouble(),
                    onChanged: (value) async {
                      final seekPosition = Duration(
                        milliseconds: value.toInt(),
                      );
                      await player.seek(seekPosition);
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey.shade700,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(currentPosition),
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    formatDuration(totalDuration),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fast_rewind_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        isPlaying = !isPlaying;
                        player.stop();
                      } else {
                        isPlaying = !isPlaying;
                        player.play();
                      }
                    });
                  },
                  icon: isPlaying
                      ? Icon(
                          Icons.pause_circle_filled_rounded,
                          size: 80,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_circle_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                ),
                SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fast_forward_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
