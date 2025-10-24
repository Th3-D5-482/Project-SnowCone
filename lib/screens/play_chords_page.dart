import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlayChordsPage extends StatefulWidget {
  final String backgroundColor;
  final String imageName;
  const PlayChordsPage({
    super.key,
    required this.backgroundColor,
    required this.imageName,
  });

  @override
  State<PlayChordsPage> createState() => _PlayChordsPageState();
}

class _PlayChordsPageState extends State<PlayChordsPage> {
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
                      height: 460,
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
                              width: 240,
                              height: 240,
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
