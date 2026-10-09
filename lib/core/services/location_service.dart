import 'dart:convert';
import 'dart:io';

class LocationService {
  static double? _lat;
  static double? _lng;
  static String? _country;
  static String? _city;
  static bool _detecting = false;

  static double? get lat => _lat;
  static double? get lng => _lng;
  static String? get country => _country;
  static String? get city => _city;
  static bool get hasLocation => _lat != null && _lng != null;
  static bool get isDetecting => _detecting;

  static Future<bool> detect() async {
    if (hasLocation) return true;
    if (_detecting) return false;
    _detecting = true;
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      final req = await client
          .getUrl(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 12));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      final data = json.decode(body) as Map<String, dynamic>;
      _lat = (data['latitude'] as num?)?.toDouble();
      _lng = (data['longitude'] as num?)?.toDouble();
      _country = data['country_name']?.toString();
      _city = data['city']?.toString();
      client.close();
      _detecting = false;
      return hasLocation;
    } catch (_) {
      _detecting = false;
      return false;
    }
  }
}
