import 'package:flutter/material.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OfflinePage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.blueGrey,
        backgroundColor: Colors.black87,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/random/no_wifi.png', height: 300),
                  SizedBox(height: 20),
                  const Text(
                    'Sorry mate, you\'re offline!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
