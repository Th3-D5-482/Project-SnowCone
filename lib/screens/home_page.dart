import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowcone/database/database.dart';
import 'package:snowcone/screens/play_page.dart';
import 'package:snowcone/screens/profile_page.dart';
import 'package:snowcone/screens/songs_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int index = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(body: HomeView()),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String getGretting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  bool isGreeting = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 8), () {
      setState(() {
        isGreeting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: kIsWeb ? 16 : 8,
              ),
              child: FutureBuilder(
                future: getConitnueListening('Albums'),
                builder: (context, asyncSnapshot) {
                  final musica = (asyncSnapshot.data ?? [])
                      .where((item) => item['isContinueListening'] == true)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/random/Th3_D5_482.jpeg',
                              ),
                              radius: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isGreeting ? getGretting() : "SnowCone",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          int crossAxisCount;
                          double aspectRatio;
                          if (screenWidth >= 1200) {
                            crossAxisCount = 3;
                            aspectRatio = 5;
                          } else if (screenWidth >= 800) {
                            crossAxisCount = 3;
                            aspectRatio = 4;
                          } else {
                            crossAxisCount = 2;
                            aspectRatio = 2.9;
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: kIsWeb ? 5 : 1,
                                  mainAxisSpacing: kIsWeb ? 5 : 1,
                                ),
                            itemCount: musica.length,
                            itemBuilder: (context, index) {
                              final song = musica[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => SongsList(
                                            imageName: song['image'],
                                            songTitle: song['name'],
                                            isBand: false,
                                            backgroundColor:
                                                song['backgroundColor'],
                                            groupID: song['groupID'],
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                  ),
                                  color: const Color.fromARGB(255, 30, 30, 30),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(8),
                                          child: Image.network(
                                            song['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            song['name'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Top mixes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                        future: getTopMixes('TopMixes'),
                        builder: (context, asyncSnapshot) {
                          final topMixes = asyncSnapshot.data ?? [];
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              return screenWidth > 1000 && kIsWeb || isDesktop
                                  ? SizedBox(
                                      height: 220,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: topMixes.length,
                                        itemBuilder: (context, index) {
                                          final topMix = topMixes[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) => SongsList(
                                                          imageName:
                                                              topMix['image'],
                                                          songTitle:
                                                              topMix['name'],
                                                          isBand: false,
                                                          backgroundColor:
                                                              topMix['backgroundColor'],
                                                          groupID:
                                                              topMix['groupID'],
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
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 800,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 180,
                                                    height: 180,
                                                    child: Card(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            30,
                                                            30,
                                                            30,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.network(
                                                          topMix['image']!,
                                                          fit: BoxFit.fill,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 8.0,
                                                        ),
                                                    child: Text(
                                                      topMix['name']!,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: FutureBuilder(
                                        future: getTopMixes('TopMixes'),
                                        builder: (context, asyncSnapshot) {
                                          if (asyncSnapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                'Error: ${asyncSnapshot.error}',
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            );
                                          }
                                          final topMixes =
                                              asyncSnapshot.data ?? [];
                                          return ListView.builder(
                                            itemCount: topMixes.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final topMix = topMixes[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      PageRouteBuilder(
                                                        pageBuilder:
                                                            (
                                                              context,
                                                              animation,
                                                              secondaryAnimation,
                                                            ) => SongsList(
                                                              imageName:
                                                                  topMix['image'],
                                                              songTitle:
                                                                  topMix['name'],
                                                              isBand: false,
                                                              backgroundColor:
                                                                  topMix['backgroundColor'],
                                                              groupID:
                                                                  topMix['groupID'],
                                                            ),
                                                        transitionsBuilder:
                                                            (
                                                              context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child,
                                                            ) => FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            ),
                                                        transitionDuration:
                                                            Duration(
                                                              milliseconds: 800,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: 160,
                                                        height: 160,
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          color:
                                                              const Color.fromARGB(
                                                                255,
                                                                30,
                                                                30,
                                                                30,
                                                              ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadiusGeometry.circular(
                                                                  8,
                                                                ),
                                                            child: Image.network(
                                                              topMix['image']!,
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 8.0,
                                                            ),
                                                        child: Text(
                                                          topMix['name'],
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Praise & Worship bands',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      FutureBuilder(
                        future: getArtist('Artist'),
                        builder: (context, asyncSnapshot) {
                          final artists = asyncSnapshot.data ?? [];
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              return screenWidth > 1000 && kIsWeb || isDesktop
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 220,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: artists.length,
                                        itemBuilder: (context, index) {
                                          final artist = artists[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) => SongsList(
                                                          imageName:
                                                              artist['image']!,
                                                          songTitle:
                                                              artist['name']!,
                                                          isBand: true,
                                                          backgroundColor:
                                                              artist['backgroundColor']!,
                                                          groupID:
                                                              artist['groupID']!,
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
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 800,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                          255,
                                                          30,
                                                          30,
                                                          30,
                                                        ),
                                                    radius: 75,
                                                    backgroundImage:
                                                        NetworkImage(
                                                          artist['image']!,
                                                        ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    artist['name']!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 190,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: artists.length,
                                        itemBuilder: (context, index) {
                                          final artist = artists[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16.0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                    pageBuilder:
                                                        (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                        ) => SongsList(
                                                          imageName:
                                                              artist['image'],
                                                          songTitle:
                                                              artist['name'],
                                                          isBand: true,
                                                          backgroundColor:
                                                              artist['backgroundColor'],
                                                          groupID:
                                                              artist['groupID'],
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
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 800,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                          255,
                                                          30,
                                                          30,
                                                          30,
                                                        ),
                                                    radius: 75,
                                                    backgroundImage:
                                                        NetworkImage(
                                                          artist['image'],
                                                        ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    artist['name'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Based on your recent listening',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                        future: getMusic('Music'),
                        builder: (context, asyncSnapshot) {
                          final recentMusica = (asyncSnapshot.data ?? [])
                              .where(
                                (item) => item['isRecentlyListened'] == true,
                              )
                              .toList();
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              return screenWidth > 1000 && kIsWeb || isDesktop
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 220,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 6,
                                        itemBuilder: (context, index) {
                                          final recentSong =
                                              recentMusica[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
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
                                                          backgroundColor:
                                                              recentSong['backgroundColor'],
                                                          imageName:
                                                              recentSong['image'],
                                                          songName:
                                                              recentSong['name'],
                                                          audio:
                                                              recentSong['audio'],
                                                          lyrics:
                                                              recentSong['lyrics'],
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
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 800,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 180,
                                                    height: 180,
                                                    child: Card(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            30,
                                                            30,
                                                            30,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.network(
                                                          recentSong['image']!,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    recentSong['name']!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: recentMusica.length >= 6
                                            ? 6
                                            : recentMusica.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final recentSong =
                                              recentMusica[index];
                                          return Padding(
                                            padding: EdgeInsets.only(right: 8),
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
                                                          backgroundColor:
                                                              recentSong['backgroundColor'],
                                                          imageName:
                                                              recentSong['image'],
                                                          songName:
                                                              recentSong['name'],
                                                          audio:
                                                              recentSong['audio'],
                                                          lyrics:
                                                              recentSong['lyrics'],
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
                                                    transitionDuration:
                                                        Duration(
                                                          milliseconds: 800,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 160,
                                                    height: 160,
                                                    child: Card(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            30,
                                                            30,
                                                            30,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadiusGeometry.circular(
                                                              8,
                                                            ),
                                                        child: Image.network(
                                                          recentSong['image']!,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 8.0,
                                                        ),
                                                    child: Text(
                                                      recentSong['name'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
