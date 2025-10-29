import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snowcone/database/database.dart';
import 'package:snowcone/screens/profile_page.dart';
import 'package:snowcone/screens/songs_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController searchInput = TextEditingController();

  Color hexToColor(String hex) {
    hex = hex.trim().replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse('0x$hex') ?? 0xFFCCCCCC);
  }

  @override
  void initState() {
    super.initState();
    searchInput = TextEditingController();
  }

  @override
  void dispose() {
    searchInput.dispose();
    super.dispose();
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
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: horizontalPadding,
                  vertical: kIsWeb ? 16 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ProfilePage(),
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
                                transitionDuration: Duration(milliseconds: 800),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/random/Th3_D5_482.jpeg',
                            ),
                            radius: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: searchInput,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search songs, artists, chords or tabs',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      enableSuggestions: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Top genres',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        int crossAxisCount;
                        double aspectRatio;
                        final double topOffSet = screenWidth > 1000 && kIsWeb
                            ? 30
                            : 15;
                        if (screenWidth >= 1200) {
                          crossAxisCount = 4;
                          aspectRatio = 2;
                        } else if (screenWidth >= 800) {
                          crossAxisCount = 2;
                          aspectRatio = 5;
                        } else {
                          crossAxisCount = 2;
                          aspectRatio = 2;
                        }
                        return FutureBuilder(
                          future: getTopGeneres('TopGenres'),
                          builder: (context, snapshot) {
                            final topGenres = snapshot.data ?? [];
                            return SizedBox(
                              width: double.infinity,
                              height: screenWidth > 800 ? 240 : 200,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: aspectRatio,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: topGenres.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final genres = topGenres[index];
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
                                                imageName: genres['image'],
                                                songTitle: genres['name'],
                                                isBand: false,
                                                backgroundColor:
                                                    genres['backgroundColor'],
                                                groupID: genres['groupID'],
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
                                        borderRadius:
                                            BorderRadiusGeometry.circular(8),
                                      ),
                                      color: (genres['color'] != null)
                                          ? hexToColor(genres['color'])
                                          : Color(0xFFCCCCCC),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                genres['name']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: topOffSet,
                                            right: -10,
                                            child: Transform.rotate(
                                              angle: 0.4,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadiusGeometry.circular(
                                                      8,
                                                    ),
                                                child: Image.network(
                                                  genres['image'],
                                                  width: 80,
                                                  height: 80,
                                                ),
                                              ),
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
                      'Browse all',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        int crossAxisCount;
                        double aspectRatio;
                        final double topOffSet = screenWidth > 1000 && kIsWeb
                            ? 40
                            : 30;
                        if (screenWidth >= 1200) {
                          crossAxisCount = 3;
                          aspectRatio = 2;
                        } else if (screenWidth >= 800) {
                          crossAxisCount = 2;
                          aspectRatio = 4.7;
                        } else {
                          crossAxisCount = 2;
                          aspectRatio = 1.7;
                        }
                        return FutureBuilder(
                          future: getBrowseAll('BrowseAll'),
                          builder: (context, asyncSnapshot) {
                            final browseAlls = asyncSnapshot.data ?? [];
                            return SizedBox(
                              width: double.infinity,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: aspectRatio,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: browseAlls.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final browseAll = browseAlls[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
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
                                                  imageName: browseAll['image'],
                                                  songTitle: browseAll['name'],
                                                  isBand: false,
                                                  backgroundColor:
                                                      browseAll['backgroundColor'],
                                                  groupID: browseAll['groupID'],
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
                                        color: (browseAll['color'] != null)
                                            ? hexToColor(browseAll['color'])
                                            : Color(0xFFCCCCCC),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(8),
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  browseAll['name'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: topOffSet,
                                              right: -10,
                                              child: Transform.rotate(
                                                angle: 0.4,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusGeometry.circular(
                                                        8,
                                                      ),
                                                  child: Image.network(
                                                    browseAll['image'],
                                                    width: 80,
                                                    height: 80,
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
                              ),
                            );
                          },
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
