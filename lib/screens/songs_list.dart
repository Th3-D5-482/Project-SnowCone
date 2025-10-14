import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snowcone/database/database.dart';

class SongsList extends StatefulWidget {
  final String imageName;
  final String songTitle;
  final bool isBand;
  final String backgroundColor;
  final int groupID;
  const SongsList({
    super.key,
    required this.imageName,
    required this.songTitle,
    required this.isBand,
    required this.backgroundColor,
    required this.groupID,
  });

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
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
                          widget.isBand
                              ? CircleAvatar(
                                  radius: 115,
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
                  StreamBuilder(
                    stream: getMusic("Music"),
                    builder: (context, asyncSnapshot) {
                      final songLists = (asyncSnapshot.data ?? [])
                          .where((item) => item['groupID'] == widget.groupID)
                          .toList();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  child: Card(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      tileColor: Colors.black,
                                      leading: Image.network(
                                        songList['image'],
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        songList['name'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Icon(Icons.play_arrow_rounded),
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
