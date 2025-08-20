import 'package:flutter/material.dart';
import 'package:snowcone/database/home_page_db.dart';

class LibraryPage extends StatefulWidget {
  final VoidCallback onSearchTap;
  const LibraryPage({super.key, required this.onSearchTap});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late List<String> libraryTypes = ["Folders", "Playlist", "Artist", "Albums"];
  int selectedIndex = -1;

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
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Library',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: widget.onSearchTap,
                          icon: Icon(
                            Icons.search_rounded,
                            size: 28,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: List.generate(libraryTypes.length, (index) {
                        final libraryType = libraryTypes[index];
                        final isSelected = selectedIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Chip(
                              label: Text(libraryType),
                              labelStyle: TextStyle(color: Colors.white),
                              backgroundColor: isSelected
                                  ? Colors.blueGrey
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 24,
                          child: Icon(
                            Icons.add_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Add New Playlist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 24,
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Your Liked Songs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 4),
                            Icon(
                              Icons.arrow_downward,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Recently Played',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: getMusic(),
                      builder: (context, asyncSnapshot) {
                        final recentlyPlayeded = asyncSnapshot.data ?? [];
                        return SizedBox(
                          width: double.infinity,
                          height: 510,
                          child: ListView.builder(
                            itemCount: recentlyPlayeded.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final recentlyPlayed = recentlyPlayeded[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          recentlyPlayed['image'],
                                        ),
                                      ),
                                      SizedBox(width: 28),
                                      Text(
                                        recentlyPlayed['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
