import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SongsList extends StatefulWidget {
  final String imageName;
  final String songTitle;
  final bool isBand;
  final String backgroundColor;
  const SongsList({
    super.key,
    required this.imageName,
    required this.songTitle,
    required this.isBand,
    required this.backgroundColor,
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
                      height: 550,
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Align(
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
                          SizedBox(height: 10),
                          Text(
                            "Light in the darkness,\npromise in the silence.",
                            style: TextStyle(
                              fontSize: 20,
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
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
