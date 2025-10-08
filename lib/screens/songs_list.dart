import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SongsList extends StatefulWidget {
  final String imageName;
  final String songTitle;
  final bool isBand;
  const SongsList({
    super.key,
    required this.imageName,
    required this.songTitle,
    required this.isBand,
  });

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              bool isDesktop =
                  (kIsWeb || Platform.isWindows) && screenWidth > 1000;
              double horizontalPadding = isDesktop ? 200 : 16;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: kIsWeb ? 16 : 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    widget.isBand
                        ? Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 115,
                              backgroundImage: NetworkImage(widget.imageName),
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.imageName,
                                width: 230,
                                height: 230,
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.songTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
