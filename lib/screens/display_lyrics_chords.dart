import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayLyricsChords extends StatefulWidget {
  final String audio;
  final String lyrics;
  final String chords;
  final bool isChord;
  final Duration position;
  final bool isPlaying;
  const DisplayLyricsChords({
    super.key,
    required this.audio,
    required this.lyrics,
    required this.isChord,
    required this.chords,
    required this.position,
    required this.isPlaying,
  });

  @override
  State<DisplayLyricsChords> createState() => _DisplayLyricsChordsState();
}

class _DisplayLyricsChordsState extends State<DisplayLyricsChords> {
  bool isPlaying = true;
  final AudioPlayer player = AudioPlayer();
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  late bool showChorus;
  int transposeValue = 0;
  bool resetVisible = false;
  late bool isRestart = false;
  String transposedChords = '';
  List<String> chordList = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  String transposeChord(String chord, int steps) {
    final regex = RegExp(r'^([A-G][#b]?)(.*)$');
    final match = regex.firstMatch(chord);
    if (match == null) return chord;
    String root = match.group(1)!;
    String suffix = match.group(2)!;
    int index = chordList.indexOf(root);
    if (index == -1) return chord;
    int newIndex = (index + steps) % 12;
    if (newIndex < 0) newIndex += 12;
    return chordList[newIndex] + suffix;
  }

  String transposeLyrics(String lyrics, int steps) {
    final chordRegex = RegExp(r'\[([A-G][#b]?[^\]]*)\]');
    return lyrics.replaceAllMapped(chordRegex, (match) {
      String originalChord = match.group(1)!;
      String transposed = transposeChord(originalChord, steps);
      return '[$transposed]';
    });
  }

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
      if (totalDuration != Duration.zero && currentPosition >= totalDuration) {
        setState(() {
          isRestart = true;
        });
        player.stop();
      }
    });
    if (widget.isPlaying) {
      player.play();
    } else {
      isPlaying = false;
    }
    player.setUrl(widget.audio).then((_) {
      player.seek(widget.position);
    });
    showChorus = widget.isChord;
    transposedChords = transposeLyrics(widget.chords, transposeValue);
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool wasPlaying = isPlaying;
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setBool('wasPlaying', wasPlaying);
        pref1.setInt('currentPostion', currentPosition.inSeconds);
        pref1.setBool('isRestart', isRestart);
        player.pause();
        isPlaying = false;
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
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
                            (kIsWeb || Platform.isWindows) &&
                            screenWidth > 1000;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () async {
                                        bool wasPlaying = isPlaying;
                                        SharedPreferences pref1 =
                                            await SharedPreferences.getInstance();
                                        pref1.setBool('wasPlaying', wasPlaying);
                                        pref1.setInt(
                                          'currentPostion',
                                          currentPosition.inSeconds,
                                        );
                                        pref1.setBool('isRestart', isRestart);
                                        player.pause();
                                        isPlaying = false;
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
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
                              SizedBox(height: 5),
                              Visibility(
                                visible: showChorus ? true : false,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          transposeValue = 0;
                                        });
                                        transposedChords = widget.chords;
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Visibility(
                                        visible: transposeValue != 0
                                            ? true
                                            : false,
                                        child: Text(
                                          'Reset',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          resetVisible = true;
                                          if (transposeValue < 12) {
                                            transposeValue++;
                                            transposedChords = transposeLyrics(
                                              widget.chords,
                                              transposeValue,
                                            );
                                            resetVisible = true;
                                          }
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.blueGrey,
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width: 90,
                                      child: Center(
                                        child: Text(
                                          transposeValue != 0
                                              ? '$transposeValue'
                                              : 'Transpose',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          resetVisible = true;
                                          if (transposeValue > -12) {
                                            transposeValue--;
                                            transposedChords = transposeLyrics(
                                              widget.chords,
                                              transposeValue,
                                            );
                                            resetVisible = true;
                                          }
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.only(right: 5),
                                        minimumSize: Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.blueGrey,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                // ignore: unrelated_type_equality_checks
                                child: Text(
                                  showChorus ? transposedChords : widget.lyrics,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 2.0,
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
                      onPressed: () {
                        final newPostion =
                            currentPosition - Duration(seconds: 10);
                        player.seek(
                          newPostion >= Duration.zero
                              ? newPostion
                              : Duration.zero,
                        );
                      },
                      icon: Icon(
                        Icons.replay_10_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (isRestart) {
                            isPlaying = true;
                            isRestart = false;
                            player.seek(Duration.zero);
                            player.play();
                          } else if (isPlaying) {
                            isPlaying = !isPlaying;
                            player.stop();
                          } else {
                            isPlaying = !isPlaying;
                            player.play();
                          }
                        });
                      },
                      icon: isRestart
                          ? Icon(
                              Icons.replay_circle_filled_rounded,
                              size: 80,
                              color: Colors.white,
                            )
                          : isPlaying
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
                      onPressed: () {
                        final newPostion =
                            currentPosition + Duration(seconds: 10);
                        player.seek(
                          newPostion <= totalDuration
                              ? newPostion
                              : totalDuration,
                        );
                      },
                      icon: Icon(
                        Icons.forward_10_rounded,
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
      ),
    );
  }
}
