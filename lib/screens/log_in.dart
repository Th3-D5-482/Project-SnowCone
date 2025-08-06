import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snowcone/screens/home_page.dart';
import 'package:snowcone/screens/sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  bool visibility = false;
  bool isChecked = true;
  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
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
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
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
                      image: AssetImage('assets/images/random/logo.png'),
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
                    SizedBox(
                      width: 380,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            label: Text(
                              'Email',
                              style: TextStyle(color: Colors.white),
                            ),
                            hintText: 'Enter your email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white54,
                            ),
                          ),
                          autocorrect: false,
                          autofillHints: [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailPattern = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            );
                            if (!emailPattern.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 380,
                      height: 60,
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(
                          label: Text(
                            'Password',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock, color: Colors.white54),
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                            icon: visibility
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: visibility ? false : true,
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: kIsWeb
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
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
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final trimmedEmail = email.text.trim();
                        final trimmedPassword = password.text.trim();
                        if (_formKey.currentState!.validate() &&
                            trimmedEmail.isNotEmpty &&
                            trimmedPassword.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: trimmedEmail,
                                  password: trimmedPassword,
                                );
                            if (isChecked) {
                              final SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              await pref.setBool('isChecked', true);
                            }
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login successful')),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const HomePage(),
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
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User not found')),
                              );
                            } else if (e.code == 'wrong-password') {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Wrong password')),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Invalid login details. Please check your email or password, or sign up if you don\'t have an account.',
                                  ),
                                ),
                              );
                            }
                          }
                          // Handle login logic here
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill in all fields'),
                            ),
                          );
                        }
                      },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SignUp(),
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
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
