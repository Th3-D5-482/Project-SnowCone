import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/welcome.png')),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Project',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                Text(
                  'SnowCone',
                  style: TextStyle(
                    fontSize: 32,
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
            ElevatedButton(
              onPressed: () => {},
              style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)),
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
