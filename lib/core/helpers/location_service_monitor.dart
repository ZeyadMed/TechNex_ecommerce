part of 'helpers.dart';
class LocationServiceMonitor {
  final BehaviorSubject<bool> _locationServiceSubject =
  BehaviorSubject<bool>.seeded(false);
  StreamSubscription<bool>? _locationSubscription;

  Stream<bool> get locationServiceStream {
    return _locationServiceSubject.stream;
  }
  bool get isLocationServiceEnabled => _locationServiceSubject.value;

  LocationServiceMonitor() {
    _init();
  }

  void _init() {
    // Check initial status
    _checkLocationServiceStatus();

    // Start periodic checks (every 2 seconds)
    _locationSubscription = Stream.periodic(const Duration(seconds: 2))
        .asyncMap((_) => _checkLocationServiceStatus())
        .listen((isEnabled) {
      if (_locationServiceSubject.value != isEnabled) {
        _locationServiceSubject.add(isEnabled);
      }
    });
  }

  Future<bool> _checkLocationServiceStatus() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  // Manual check
  Future<bool> checkLocationService() async {
    final status = await _checkLocationServiceStatus();
    _locationServiceSubject.add(status);
    return status;
  }

  void dispose() {
    _locationSubscription?.cancel();
    _locationServiceSubject.close();
  }
}
