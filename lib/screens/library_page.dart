import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowcone/database/database.dart';
import 'package:snowcone/screens/profile_page.dart';
import 'package:snowcone/screens/songs_list.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool isLiked = false;
  late String email;
  String? safeEmail;

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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              bool isDesktop =
                  (kIsWeb || Platform.isWindows) && screenWidth > 1000;
              double horizontalPadding = isDesktop ? 200 : 16;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: kIsWeb ? 16 : 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => ProfilePage(),
                                    transitionDuration: Duration(
                                      milliseconds: 800,
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
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  30,
                                  30,
                                  30,
                                ),
                                backgroundImage: AssetImage(
                                  'assets/images/random/Th3_D5_482.jpeg',
                                ),
                                radius: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Library',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_rounded,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.grey[800], thickness: 2),
                    StreamBuilder(
                      stream: getFavoritesData('Favorites/$safeEmail'),
                      builder: (context, asyncSnapshot) {
                        // ignore: unused_local_variable
                        final favoritesDatas = asyncSnapshot.data ?? [];
                        final isLiked = favoritesDatas.isNotEmpty;
                        return isLiked
                            ? Column(
                                children: [
                                  SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => SongsList(
                                                key: UniqueKey(),
                                                imageName:
                                                    'https://ik.imagekit.io/j7iwyd9ys/Project%20SnowCone/images/songs/how_great_is_our_god.png?updatedAt=1758811880066',
                                                songTitle: 'Liked Songs',
                                                isBand: false,
                                                backgroundColor: '0xFFF8BBD0',
                                                groupID: [0],
                                                isLikedSongs: true,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.pink.shade400,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          width: 56,
                                          height: 56,
                                          child: Icon(
                                            Icons.favorite_rounded,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text('Liked Songs'),
                                        titleTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 80,
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          30,
                                          30,
                                          30,
                                        ),
                                        backgroundImage: AssetImage(
                                          'assets/images/random/library.png',
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Your library is empty!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Add music to make it yours.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}
