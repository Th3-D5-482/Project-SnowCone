import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20),
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    label: Text('Email', style: TextStyle(color: Colors.white)),
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email, color: Colors.white54),
                  ),
                  autocorrect: false,
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock, color: Colors.white54),
                    suffixIcon: Icon(Icons.visibility, color: Colors.white54),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) => setState(() {
                        isChecked = value ?? false;
                      }),
                      activeColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      side: BorderSide(color: Colors.white54, width: 1.5),
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(350, 50),
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text('Log In'),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
