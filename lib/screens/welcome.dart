import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowcone/connectivity_overlay.dart';
import 'package:snowcone/screens/log_in.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Image.asset(
                'assets/images/random/welcome.png',
                height: kIsWeb ? 480 : null,
                width: double.infinity,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Project',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'SnowCone',
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explore your favorite',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'songs',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8.0),
                  Text(
                    'Master every',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'chord',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8.0),
                  Text(
                    'Play with',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'confidence',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Padding(
                padding: kIsWeb
                    ? const EdgeInsets.only(bottom: 24)
                    : const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ConnectivityOverlay(child: const LogIn()),
                        transitionDuration: Duration(milliseconds: 100),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                      ),
                    ),
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)),
                  child: Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
