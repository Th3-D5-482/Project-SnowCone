import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:snowcone/screens/display_lyrics.dart';

class PlayChordsPage extends StatefulWidget {
  final String backgroundColor;
  final String imageName;
  final String songName;
  final String audio;
  final String lyrics;
  const PlayChordsPage({
    super.key,
    required this.backgroundColor,
    required this.imageName,
    required this.songName,
    required this.audio,
    required this.lyrics,
  });

  @override
  State<PlayChordsPage> createState() => _PlayChordsPageState();
}

class _PlayChordsPageState extends State<PlayChordsPage> {
  final AudioPlayer player = AudioPlayer();
  late bool isPlaying = true;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  String lyricsContent = '';

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.audio);
    player.play();
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
    loadLyrics();
  }

  Future<void> loadLyrics() async {
    final respose = await http.get(Uri.parse(widget.lyrics));
    if (respose.statusCode == 200) {
      setState(() {
        lyricsContent = respose.body;
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
    return Scaffold(
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
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 290,
                      width: double.infinity,
                      child: Card(
                        color: Colors.grey.shade900,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chords preview',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                lyricsContent,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 5,
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {
                                  player.pause();
                                  isPlaying = false;
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => DisplayLyrics(
                                            audio: widget.audio,
                                            lyrics: lyricsContent,
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
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Text(
                                  'Show Chords',
                                  style: TextStyle(fontSize: 16),
                                ),
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
    );
  }
}
