import 'dart:math' as math;

class PrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class PrayerService {
  static double qiblaDirection(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final phiK = kaabaLat * math.pi / 180.0;
    final phi = lat * math.pi / 180.0;
    final dLng = (kaabaLng - lng) * math.pi / 180.0;
    final y = math.sin(dLng);
    final x = math.cos(phi) * math.tan(phiK) - math.sin(phi) * math.cos(dLng);
    var bearing = math.atan2(y, x) * 180.0 / math.pi;
    if (bearing < 0) bearing += 360.0;
    return bearing;
  }

  static PrayerTimes calculate({
    required double lat,
    required double lng,
    DateTime? date,
  }) {
    final d = date ?? DateTime.now();
    final doy = d.difference(DateTime(d.year, 1, 1)).inDays + 1;

    final g = 357.529 + 0.98560028 * doy;
    final q = 280.459 + 0.98564736 * doy;
    final L = q + 1.915 * _sin(g) + 0.020 * _sin(2 * g);
    final e = 23.439 - 0.00000036 * doy;
    final ra = _atan2(_cos(e) * _sin(L), _cos(L)) / 15;
    var eqt = q / 15 - _fixHour(ra);
    eqt = eqt / 24;
    final decl = _asin(_sin(e) * _sin(L));

    final dhuhr = _fixHour(12 - eqt - lng / 15);
    final fajr = dhuhr - _hourAngle(18, decl, lat);
    final isha = dhuhr + _hourAngle(18, decl, lat);
    final sunrise = dhuhr - _hourAngle(0.833, decl, lat);
    final maghrib = dhuhr + _hourAngle(0.833, decl, lat);
    final asr = dhuhr + _asrAngle(1, decl, lat);

    return PrayerTimes(
      fajr: _toDate(d, fajr),
      sunrise: _toDate(d, sunrise),
      dhuhr: _toDate(d, dhuhr),
      asr: _toDate(d, asr),
      maghrib: _toDate(d, maghrib),
      isha: _toDate(d, isha),
    );
  }

  static DateTime _toDate(DateTime day, double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).floor();
    return DateTime(day.year, day.month, day.day, h, m);
  }

  static double _sin(double d) => math.sin(d * math.pi / 180);
  static double _cos(double d) => math.cos(d * math.pi / 180);
  static double _tan(double d) => math.tan(d * math.pi / 180);
  static double _asin(double x) => math.asin(x) * 180 / math.pi;
  static double _atan2(double y, double x) =>
      math.atan2(y, x) * 180 / math.pi;
  static double _fixHour(double a) {
    var r = a - 24 * ((a / 24).floorToDouble());
    if (r < 0) r += 24;
    return r;
  }

  static double _hourAngle(double angle, double decl, double lat) {
    final cosT =
        (-_sin(angle) - _sin(decl) * _sin(lat)) / (_cos(decl) * _cos(lat));
    if (cosT > 1 || cosT < -1) return 12;
    return _acos(cosT) / 15;
  }

  static double _asrAngle(double factor, double decl, double lat) {
    final angle = _atan(1 / (factor + _tan((lat - decl).abs())));
    return _hourAngle(90 - angle, decl, lat);
  }

  static double _acos(double x) => math.acos(x) * 180 / math.pi;
  static double _atan(double x) => math.atan(x) * 180 / math.pi;
}
