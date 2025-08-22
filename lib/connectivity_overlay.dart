import 'package:flutter/material.dart';
import 'package:snowcone/screens/offline_page.dart';
import 'connectivity_service.dart';

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;
  const ConnectivityOverlay({required this.child, super.key});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  final ConnectivityService _service = ConnectivityService();
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _service.connectionStream.listen((status) {
      if (mounted) {
        setState(() {
          _hasInternet = status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 👇 Full replacement, not overlay
    return _hasInternet
        ? widget.child
        : const Scaffold(backgroundColor: Colors.black, body: OfflinePage());
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
