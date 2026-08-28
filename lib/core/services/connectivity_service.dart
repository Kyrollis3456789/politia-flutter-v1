import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Global service monitoring network connectivity and active internet reachability.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService._internal();
  static final ConnectivityService instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _pollingTimer;

  bool _isOnline = true;
  bool _hasInitialCheckRun = false;
  bool _wasOffline = false;

  /// Whether the device has an active, verified internet connection.
  bool get isOnline => _isOnline;

  /// Whether the service has completed its first verification check.
  bool get hasInitialCheckRun => _hasInitialCheckRun;

  /// Whether the app was previously offline (to trigger 'Back Online' banner).
  bool get wasOffline => _wasOffline;

  /// Initializes connectivity listeners and performs background monitoring.
  Future<void> initialize() async {
    // Initial silent check
    await checkConnectivity(isInitial: true);

    // Listen to OS-level connectivity changes (Wi-Fi, Cellular, Ethernet, None)
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      await checkConnectivity();
    });

    // Periodic heartbeat check (every 12s) to catch silent drops/restorations on desktop & mobile
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 12), (_) async {
      await checkConnectivity(isBackgroundPoll: true);
    });
  }

  /// Verifies active internet reachability with robust HTTP fallback on Windows.
  Future<bool> checkConnectivity({bool isBackgroundPoll = false, bool isInitial = false}) async {
    bool hasConnection = true;

    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final isNone = connectivityResults.every((r) => r == ConnectivityResult.none);

      if (isNone) {
        hasConnection = false;
      } else {
        // Validate actual internet access with DNS / HTTP request fallback
        hasConnection = await _checkInternetAccess();
      }
    } catch (e) {
      debugPrint('[ConnectivityService] Error checking connectivity: $e');
      // If error occurs during check, avoid false-offline on startup
      hasConnection = isInitial ? true : false;
    }

    if (isInitial) {
      _isOnline = hasConnection;
      _wasOffline = false;
      _hasInitialCheckRun = true;
      return _isOnline;
    }

    if (_isOnline && !hasConnection) {
      // Transitioned to Offline
      _isOnline = false;
      _wasOffline = true;
      notifyListeners();
    } else if (!_isOnline && hasConnection) {
      // Transitioned to Online
      _isOnline = true;
      notifyListeners();
    }

    _hasInitialCheckRun = true;
    return _isOnline;
  }

  /// Performs lightweight DNS lookup with HTTP request fallback to prevent false offline on Windows.
  Future<bool> _checkInternetAccess() async {
    // 1. Fast DNS Host Lookup
    try {
      final lookupResults = await Future.any([
        InternetAddress.lookup('google.com'),
        InternetAddress.lookup('1.1.1.1'),
        InternetAddress.lookup('athyhvrbkonrekwzixyo.supabase.co'),
      ]).timeout(const Duration(seconds: 3));

      if (lookupResults.isNotEmpty && lookupResults[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {
      // Fallback to HTTP probe
    }

    // 2. HTTP Probe Fallback (Bypasses Windows raw socket sandbox issues)
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
      final request = await client.getUrl(Uri.parse('https://www.google.com/generate_204'));
      final response = await request.close().timeout(const Duration(seconds: 3));
      client.close();
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      try {
        final client = HttpClient()..connectionTimeout = const Duration(seconds: 2);
        final request = await client.getUrl(Uri.parse('https://1.1.1.1'));
        final response = await request.close().timeout(const Duration(seconds: 2));
        client.close();
        return response.statusCode >= 200 && response.statusCode < 400;
      } catch (_) {
        return false;
      }
    }
  }

  /// Resets the `wasOffline` flag once the restored banner has completed displaying.
  void acknowledgeRestoredBanner() {
    _wasOffline = false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pollingTimer?.cancel();
    super.dispose();
  }
}
