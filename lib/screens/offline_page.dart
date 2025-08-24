import 'package:flutter/material.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));
          },
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.black87,
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/random/no_wifi.png',
                        ),
                        backgroundColor: Colors.transparent,
                        radius: 120,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sorry mate, you\'re offline!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
