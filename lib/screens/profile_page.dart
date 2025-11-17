import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowcone/screens/log_in.dart';

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
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
                      //SizedBox(width: 12),
                      Text(
                        'About me',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 90),
                  CircleAvatar(
                    radius: 110,
                    backgroundImage: AssetImage(
                      'assets/images/random/Th3_D5_482.jpeg',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Th3_D5_482',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "I'm a developer who blends thoughtful design with clean, maintainable code to build intuitive digital experiences. From scalable systems to refined UI flows, I approach every project with precision and empathy. I believe great tools serve real human needs—and that elegance begins with clarity. My goal is to create solutions that look good, feel right, and work flawlessly.",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  kIsWeb ? SizedBox(height: 160) : SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return FutureBuilder(
                                  future: SharedPreferences.getInstance(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      final prefs =
                                          snapshot.data as SharedPreferences;
                                      prefs.setBool('isChecked', false);
                                      return LogIn();
                                    } else {
                                      return Container();
                                    }
                                  },
                                );
                              },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)),
                    child: Text('Sign out'),
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
