import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowcone/screens/display_lyrics_chords.dart';

class PlayPage extends StatefulWidget {
  final String backgroundColor;
  final String imageName;
  final String songName;
  final String audio;
  final String lyrics;
  final String chords;
  const PlayPage({
    super.key,
    required this.backgroundColor,
    required this.imageName,
    required this.songName,
    required this.audio,
    required this.lyrics,
    required this.chords,
  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final AudioPlayer player = AudioPlayer();
  late bool isPlaying = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  String lyricsContent = '';
  String chords = '';
  late bool isRestart = false;

  @override
  void initState() {
    super.initState();
    navigatingBackCode();
    player.setUrl(widget.audio).then((_) {
      player.seek(currentPosition);
    });
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
    loadLyrics();
    getChords();
  }

  Future<void> navigatingBackCode() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    int millis = pref1.getInt('currentPostion') ?? 0;
    setState(() {
      isPlaying = pref1.getBool('wasPlaying') ?? true;
      currentPosition = Duration(seconds: millis);
      isRestart = pref1.getBool('isRestart') ?? false;
    });
    player.seek(currentPosition);
    if (isPlaying) {
      player.play();
    } else {
      isPlaying = false;
    }
  }

  Future<void> loadLyrics() async {
    final response = await http.get(Uri.parse(widget.lyrics));
    if (response.statusCode == 200) {
      setState(() {
        lyricsContent = response.body;
      });
    }
  }

  Future<void> getChords() async {
    final response = await http.get(Uri.parse(widget.chords));
    if (response.statusCode == 200) {
      setState(() {
        chords = response.body;
      });
    }
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
        player.stop();
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setBool('wasPlaying', true);
        pref1.setBool('isRestart', false);
        return Future.value(true);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              bool isDesktop =
                  (kIsWeb || Platform.isWindows) && screenWidth > 1000;
              // ignore: unused_local_variable
              double horizontalPadding = isDesktop ? 200 : 0;
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: horizontalPadding,
                  vertical: kIsWeb ? 16 : 0,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.8),
                            Color(int.parse(widget.backgroundColor)),
                            Color.fromRGBO(0, 0, 0, 0.8),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: SizedBox(
                        height: 520,
                        child: Column(
                          children: [
                            kIsWeb ? SizedBox(height: 0) : SizedBox(height: 40),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsetsGeometry.only(left: 8),
                                child: IconButton(
                                  onPressed: () async {
                                    player.stop();
                                    SharedPreferences pref1 =
                                        await SharedPreferences.getInstance();
                                    pref1.setBool('wasPlaying', true);
                                    pref1.setBool('isRestart', false);
                                    // ignore: use_build_context_synchronously
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
                            SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image(
                                image: NetworkImage(widget.imageName),
                                width: 340,
                                height: 340,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      widget.songName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StreamBuilder<Duration>(
                        stream: player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final duration = totalDuration;
                          // ignore: unrelated_type_equality_checks
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
                          onPressed: () {
                            final newPosition =
                                currentPosition - Duration(seconds: 10);
                            player.seek(
                              newPosition >= Duration.zero
                                  ? newPosition
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
                            final newPosition =
                                currentPosition + Duration(seconds: 10);
                            player.seek(
                              newPosition <= totalDuration
                                  ? newPosition
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
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 380,
                        width: double.infinity,
                        child: Card(
                          color: Colors.grey.shade900,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lyrics preview',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  lyricsContent,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                    height: 2,
                                  ),
                                  maxLines: 5,
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          bool wasPlaying = isPlaying;
                                          player.pause();
                                          isPlaying = false;
                                          Navigator.of(context)
                                              .push(
                                                PageRouteBuilder(
                                                  pageBuilder:
                                                      (
                                                        context,
                                                        animation,
                                                        secondaryAnimation,
                                                      ) => DisplayLyricsChords(
                                                        audio: widget.audio,
                                                        lyrics: lyricsContent,
                                                        isChord: false,
                                                        chords: chords,
                                                        position:
                                                            currentPosition,
                                                        isPlaying: wasPlaying,
                                                      ),
                                                  transitionsBuilder:
                                                      (
                                                        context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child,
                                                      ) => FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      ),
                                                  transitionDuration: Duration(
                                                    milliseconds: 800,
                                                  ),
                                                ),
                                              )
                                              .then((_) {
                                                navigatingBackCode();
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Show lyrics',
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        bool wasPlaying = isPlaying;
                                        player.pause();
                                        isPlaying = false;
                                        Navigator.of(context)
                                            .push(
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => DisplayLyricsChords(
                                                      audio: widget.audio,
                                                      lyrics: lyricsContent,
                                                      isChord: true,
                                                      chords: chords,
                                                      position: currentPosition,
                                                      isPlaying: wasPlaying,
                                                    ),
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) => FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ),
                                                transitionDuration: Duration(
                                                  milliseconds: 800,
                                                ),
                                              ),
                                            )
                                            .then((_) {
                                              navigatingBackCode();
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade800,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Chords',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
