import 'package:flutter/material.dart';
import 'package:snowcone/screens/no_internet_screen.dart';
import 'connectivity_service.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({required this.child, super.key});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  final ConnectivityService _service = ConnectivityService();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _service.connectionStream.listen((status) {
      setState(() {
        _hasInternet = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _hasInternet
        ? widget.child
        : const Scaffold(
            backgroundColor: Colors.black87,
            body: NoInternetScreen(),
          );
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
