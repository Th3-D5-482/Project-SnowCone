import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService() {
    _startMonitoring();
  }

  Stream<bool> get connectionStream => _controller.stream;

  void _startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      // results is a List<ConnectivityResult>
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        _controller.add(false);
      } else {
        final hasInternet = await _checkRealInternet();
        _controller.add(hasInternet);
      }
    });
  }

  Future<bool> _checkRealInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
