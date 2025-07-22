import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image(image: AssetImage('assets/images/welcome.png')),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
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
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'From the',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(width: 8.0),
              Text(
                'latest',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.0),
              Text('the', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
