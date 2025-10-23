import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              bool isDesktop =
                  (kIsWeb || Platform.isWindows) && screenWidth > 1000;
              // ignore: unused_local_variable
              double horizontalPadding = isDesktop ? 200 : 16;
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: kIsWeb ? 16 : 8,
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentGeometry.topLeft,
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
