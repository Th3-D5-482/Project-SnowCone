import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowcone/database/home_page_db.dart';
import 'package:snowcone/screens/library_page.dart';
import 'package:snowcone/screens/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: [HomeView(), SearchPage(), LibraryPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: index,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          iconSize: 28,
          onTap: (value) => setState(() {
            index = value;
          }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
          ],
        ),
      ),
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

  bool showGreeting = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showGreeting = false;
        });
      }
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
                kIsWeb ||
                (defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.windows ||
                        defaultTargetPlatform == TargetPlatform.linux) &&
                    screenWidth > 1000;
            // ignore: unused_local_variable
            double horizontalPadding = isDesktop ? 200 : 16;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: kIsWeb ? 16 : 8,
              ),
              child: StreamBuilder(
                stream: getConitnueListening('Albums'),
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
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/random/Th3_D5_482.jpeg',
                            ),
                            radius: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            showGreeting ? getGretting() : "SnowCone",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          final orientation = MediaQuery.of(
                            context,
                          ).orientation;

                          int crossAxisCount;
                          double aspectRatio;
                          if (orientation == Orientation.landscape) {
                            crossAxisCount = 3;
                            aspectRatio = kIsWeb ? 5 : 4;
                          } else {
                            if (screenWidth >= 1200) {
                              crossAxisCount = 3;
                              aspectRatio = 6;
                            } else if (screenWidth >= 800) {
                              crossAxisCount = 3;
                              aspectRatio = 5;
                            } else {
                              crossAxisCount = 2;
                              aspectRatio = 2.8;
                            }
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1,
                                ),
                            itemCount: musica.length,
                            itemBuilder: (context, index) {
                              final song = musica[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    8,
                                  ),
                                ),
                                color: const Color.fromARGB(255, 30, 30, 30),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(8),
                                        child: Image.network(
                                          song['image']!,
                                          width: 60,
                                          height: 100,
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
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your top mixes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          return screenWidth > 1000 && kIsWeb && isDesktop
                              ? FutureBuilder(
                                  future: getTopMixes('TopMixes'),
                                  builder: (context, asyncSnapshot) {
                                    final topMixes = asyncSnapshot.data ?? [];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: topMixes.map<Widget>((topMix) {
                                        return SizedBox(
                                          width: 190,
                                          height: 130,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            color: const Color.fromARGB(
                                              255,
                                              30,
                                              30,
                                              30,
                                            ),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusGeometry.circular(
                                                        8,
                                                      ),
                                                  child: Image.network(
                                                    topMix['image']!,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    opacity:
                                                        const AlwaysStoppedAnimation(
                                                          0.5,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    16.0,
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      topMix['name']!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                              : SizedBox(
                                  height: 130,
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
                                      final topMixes = asyncSnapshot.data ?? [];
                                      return ListView.builder(
                                        itemCount: topMixes.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final topMix = topMixes[index];
                                          return SizedBox(
                                            width: 175,
                                            height: 130,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 16.0,
                                              ),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                ),
                                                color: const Color.fromARGB(
                                                  255,
                                                  30,
                                                  30,
                                                  30,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadiusGeometry.circular(
                                                            8,
                                                          ),
                                                      child: Image.network(
                                                        topMix['image']!,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        opacity:
                                                            const AlwaysStoppedAnimation(
                                                              0.5,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16.0,
                                                          ),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          topMix['name']!,
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
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
                      StreamBuilder(
                        stream: getMusic('Music'),
                        builder: (context, asyncSnapshot) {
                          final recentMusica = (asyncSnapshot.data ?? [])
                              .where(
                                (item) => item['isRecentlyListened'] == true,
                              )
                              .toList();
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              return screenWidth > 1000 && kIsWeb && isDesktop
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: List.generate(
                                          recentMusica.length,
                                          (index) {
                                            final recentSong =
                                                recentMusica[index];
                                            return SizedBox(
                                              width: 180,
                                              height: 180,
                                              child: Card(
                                                color: const Color.fromARGB(
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
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: recentMusica.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final recentSong =
                                              recentMusica[index];
                                          return Padding(
                                            padding: EdgeInsets.only(right: 16),
                                            child: SizedBox(
                                              width: 160,
                                              height: 180,
                                              child: Card(
                                                color: const Color.fromARGB(
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
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
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
