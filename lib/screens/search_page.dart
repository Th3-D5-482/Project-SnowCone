import 'package:flutter/material.dart';
import 'package:snowcone/database/search_page_db.dart';

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
              double horizontalPadding = screenWidth > 800 ? 200 : 16;
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/random/Th3_D5_482.jpeg',
                          ),
                          radius: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 24,
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
                        hintStyle: TextStyle(color: Colors.grey),
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
                          color: Colors.grey,
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
                      'Your top genres',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        int crossAxisCount;
                        double aspectRatio;
                        if (screenWidth >= 1200) {
                          crossAxisCount = 4;
                          aspectRatio = 2;
                        } else if (screenWidth >= 800) {
                          crossAxisCount = 2;
                          aspectRatio = 4;
                        } else {
                          crossAxisCount = 2;
                          aspectRatio = 2;
                        }
                        return FutureBuilder(
                          future: getGenres(),
                          builder: (context, snapshot) {
                            final topGeneres = snapshot.data ?? [];
                            return SizedBox(
                              width: double.infinity,
                              height: screenWidth > 800 ? 300 : 200,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: aspectRatio,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: topGeneres.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final genres = topGeneres[index];
                                  return Card(
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Positioned(
                                          top: 20,
                                          left: 102,
                                          child: Transform.rotate(
                                            angle: 0.5,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double screenWidth = constraints.maxWidth;
                        int crossAxisCount;
                        double aspectRatio;
                        if (screenWidth >= 1200) {
                          crossAxisCount = 3;
                          aspectRatio = 2;
                        } else if (screenWidth >= 800) {
                          crossAxisCount = 2;
                          aspectRatio = 4;
                        } else {
                          crossAxisCount = 2;
                          aspectRatio = 1.7;
                        }
                        return FutureBuilder(
                          future: getBrowseAll(),
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
                                  return Card(
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              browseAll['name'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Positioned(
                                          top: 30,
                                          left: 103,
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
