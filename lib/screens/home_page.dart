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
          children: [
            HomeView(),
            SearchPage(),
            LibraryPage(
              onSearchTap: () {
                setState(() {
                  index = 1;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: index,
          iconSize: 28,
          onTap: (value) => setState(() {
            index = value;
          }),
          fixedColor: Colors.blueGrey,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            // ignore: unused_local_variable
            double horizontalPadding = screenWidth > 800 ? 200 : 16;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: StreamBuilder(
                stream: getContinueListening(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  } else if (asyncSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${asyncSnapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
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
                            radius: 30,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getGretting(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Th3-D5-482',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.settings_sharp,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Continue Listening',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double screenWidth = constraints.maxWidth;
                          int crossAxisCount;
                          double aspectRatio;
                          if (screenWidth >= 1200) {
                            crossAxisCount = 3;
                            aspectRatio = 6;
                          } else if (screenWidth >= 800) {
                            crossAxisCount = 3;
                            aspectRatio = 5;
                          } else {
                            crossAxisCount = 2;
                            aspectRatio = 2.5;
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: musica.length,
                            itemBuilder: (context, index) {
                              final song = musica[index];
                              return Card(
                                color: const Color.fromARGB(255, 30, 30, 30),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        song['image']!,
                                        width: 80,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          song['name'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
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
                        'Your Top Mixes',
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
                          return screenWidth > 800
                              ? FutureBuilder(
                                  future: getTopMixes(),
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
                                                  BorderRadius.circular(16.0),
                                            ),
                                            color: const Color.fromARGB(
                                              255,
                                              30,
                                              30,
                                              30,
                                            ),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  topMix['image']!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  opacity:
                                                      const AlwaysStoppedAnimation(
                                                        0.5,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
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
                                    future: getTopMixes(),
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
                                            width: 190,
                                            height: 130,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 16.0,
                                              ),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        16.0,
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
                                                    Image.network(
                                                      topMix['image']!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      opacity:
                                                          const AlwaysStoppedAnimation(
                                                            0.5,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
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
                        stream: getMusic(),
                        builder: (context, asyncSnapshot) {
                          final recentMusica = (asyncSnapshot.data ?? [])
                              .where(
                                (item) => item['isRecentlyListened'] == true,
                              )
                              .toList();
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              return screenWidth > 800
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
                                                        16.0,
                                                      ),
                                                ),
                                                child: Image.network(
                                                  recentSong['image']!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
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
                                                        16.0,
                                                      ),
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
