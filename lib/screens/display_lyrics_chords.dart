import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DisplayLyricsChords extends StatefulWidget {
  final String audio;
  final String lyrics;
  final String chords;
  final bool isChord;
  const DisplayLyricsChords({
    super.key,
    required this.audio,
    required this.lyrics,
    required this.isChord,
    required this.chords,
  });

  @override
  State<DisplayLyricsChords> createState() => _DisplayLyricsChordsState();
}

class _DisplayLyricsChordsState extends State<DisplayLyricsChords> {
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  late bool showChorus;

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
    showChorus = widget.isChord;
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
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade900,
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      bool isDesktop =
                          (kIsWeb || Platform.isWindows) && screenWidth > 1000;
                      // ignore: unused_local_variable
                      double horizontalPadding = isDesktop ? 200 : 8;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: kIsWeb ? 16 : 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
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
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showChorus = !showChorus;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        showChorus
                                            ? 'View lyrics'
                                            : 'View chords',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.blueGrey,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              // ignore: unrelated_type_equality_checks
                              child: Text(
                                showChorus ? widget.chords : widget.lyrics,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: widget.isChord ? 2.0 : 2.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
