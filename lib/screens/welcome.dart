import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowcone/screens/sign_in.dart';

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
          child: kIsWeb
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 100.0,
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/welcome1.png'),
                        width: 600,
                        height: 600,
                      ),
                      SizedBox(width: 50),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Project',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'SnowCone',
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '" Explore your favorite',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'songs',
                                style: TextStyle(
                                  fontSize: 26,
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
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'chord',
                                style: TextStyle(
                                  fontSize: 26,
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
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'confidence "',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 100),
                          Padding(
                            padding: kIsWeb
                                ? const EdgeInsets.only(bottom: 24)
                                : const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const SignIn(),
                                    transitionDuration: Duration(
                                      milliseconds: 100,
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
                                ),
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(350, 50),
                              ),
                              child: Text('Get Started'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Image(image: AssetImage('assets/images/welcome.png')),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Project',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'SnowCone',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Explore your favorite',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'songs',
                          style: TextStyle(
                            fontSize: 26,
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
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'chord',
                          style: TextStyle(
                            fontSize: 26,
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
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'confidence',
                          style: TextStyle(
                            fontSize: 26,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    Padding(
                      padding: kIsWeb
                          ? const EdgeInsets.only(bottom: 24)
                          : const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignIn(),
                              transitionDuration: Duration(milliseconds: 100),
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
                          ),
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(350, 50),
                        ),
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
