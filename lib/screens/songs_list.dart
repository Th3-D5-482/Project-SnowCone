import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowcone/database/database.dart';
import 'package:snowcone/screens/play_page.dart';

class SongsList extends StatefulWidget {
  final String imageName;
  final String songTitle;
  final bool isBand;
  final String backgroundColor;
  final List groupID;
  final bool isLikedSongs;
  const SongsList({
    super.key,
    required this.imageName,
    required this.songTitle,
    required this.isBand,
    required this.backgroundColor,
    required this.groupID,
    required this.isLikedSongs,
  });

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  late String email;
  String? safeEmail;
  late bool songListx;

  @override
  void initState() {
    super.initState();
    convertEmail();
  }

  Future<void> convertEmail() async {
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    email = pref2.getString('getEmail')!;
    safeEmail = email.replaceAll('.', '_').replaceAll('@', '_');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            bool isDesktop =
                (kIsWeb || Platform.isWindows) && screenWidth > 1000;
            double horizontalPadding = isDesktop ? 200 : 0;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: kIsWeb ? 16 : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: 460,
                      child: Column(
                        children: [
                          kIsWeb ? SizedBox(height: 0) : SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.grey,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          widget.isLikedSongs
                              ? Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade400,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Icon(
                                          Icons.favorite_rounded,
                                          size: 96,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                  ],
                                )
                              : widget.isBand
                              ? CircleAvatar(
                                  radius: 115,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    30,
                                    30,
                                    30,
                                  ),
                                  backgroundImage: NetworkImage(
                                    widget.imageName,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    widget.imageName,
                                    width: 240,
                                    height: 240,
                                  ),
                                ),
                          SizedBox(height: 20),
                          Text(
                            widget.songTitle,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.isLikedSongs
                      ? StreamBuilder(
                          stream: getFavoritesData('Favorites/$safeEmail'),
                          builder: (context, asyncSnapshot) {
                            final songLists = (asyncSnapshot.data ?? []);
                            if (asyncSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 160),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            }
                            if (songLists.isEmpty) {
                              return const Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 160),
                                    Text(
                                      'No Liked songs',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: SizedBox(
                                height: 480,
                                child: Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: songLists.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final songList = songLists[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => PlayPage(
                                                      id: songList['id'],
                                                      backgroundColor:
                                                          songList['backgroundColor'],
                                                      imageName:
                                                          songList['image'],
                                                      songName:
                                                          songList['name'],
                                                      audio: songList['audio'],
                                                      lyrics:
                                                          songList['lyrics'],
                                                      chords:
                                                          songList['chords'],
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
                                          child: Card(
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              tileColor: Colors.black,
                                              leading: Image.network(
                                                songList['image'],
                                                fit: BoxFit.cover,
                                              ),
                                              title: Text(
                                                songList['name'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : FutureBuilder(
                          future: getMusic("Music"),
                          builder: (context, asyncSnapshot) {
                            final songLists = (asyncSnapshot.data ?? [])
                                .where(
                                  (item) => widget.groupID.contains(item['id']),
                                )
                                .toList();
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: SizedBox(
                                height: 480,
                                child: Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: songLists.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      final songList = songLists[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => PlayPage(
                                                      id: songList['id'],
                                                      backgroundColor:
                                                          songList['backgroundColor'],
                                                      imageName:
                                                          songList['image'],
                                                      songName:
                                                          songList['name'],
                                                      audio: songList['audio'],
                                                      lyrics:
                                                          songList['lyrics'],
                                                      chords:
                                                          songList['chords'],
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
                                          child: Card(
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              tileColor: Colors.black,
                                              leading: Image.network(
                                                songList['image'],
                                                fit: BoxFit.cover,
                                              ),
                                              title: Text(
                                                songList['name'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.play_arrow_rounded,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
