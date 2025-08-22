import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((result) async {
      final hasInternet = await _checkRealInternet();
      _controller.add(hasInternet);
    });

    // Initial check when app starts
    _initialCheck();
  }

  Stream<bool> get connectionStream => _controller.stream;

  Future<void> _initialCheck() async {
    final hasInternet = await _checkRealInternet();
    _controller.add(hasInternet);
  }

  Future<bool> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _controller.close();
  }
}
