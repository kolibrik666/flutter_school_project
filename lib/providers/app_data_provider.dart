import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/earthquake_model.dart';
import '../utils/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppDataProvider with ChangeNotifier {
  init() {
    final now = DateTime.now();
    final earlier = now.subtract(const Duration(days: 10)); // pôvodne 1 deň
    _startTime = getFormattedDateTime(earlier.millisecondsSinceEpoch);
    _endTime = getFormattedDateTime(now.millisecondsSinceEpoch);
    _startTime = getFormattedDateTime(
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    );
    _endTime = getFormattedDateTime(DateTime.now().millisecondsSinceEpoch);
    _maxRadiusKm = _maxRadiusThreshold;
    _setQueryParams();

    getEarthquakeData();
  }

  bool get hasDataLoaded => earthquakeModel != null;

  Future getEarthquakeData() async {
    final uri = _baseUrl.replace(queryParameters: _queryParams);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _earthquakeModel = EarthquakeModel.fromJson(json);
        print(_earthquakeModel!.features.length);
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  final Uri _baseUrl = Uri.parse(
    'https://earthquake.usgs.gov/fdsnws/event/1/query',
  );
  Map<String, String> _queryParams = {};
  double _maxRadiusKm = 500.0;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _startTime = '';
  String _endTime = '';
  String _orderBy = 'time'; // predvolené triedenie podľa času
  String? _currentCity;
  final double _maxRadiusThreshold =
      20001.6; // max. povolená hodnota podľa dokumentácie
  bool _shouldUseLocation = false;
  EarthquakeModel? _earthquakeModel;

  double get maxRadiusKm => _maxRadiusKm;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get startTime => _startTime;
  String get endTime => _endTime;
  String get orderBy => _orderBy;
  String? get currentCity => _currentCity;
  double get maxRadiusThreshold => _maxRadiusThreshold;
  bool get shouldUseLocation => _shouldUseLocation;
  EarthquakeModel? get earthquakeModel => _earthquakeModel;

  void _setQueryParams() {
    _queryParams = {
      'format': 'geojson',
      'starttime': _startTime,
      'endtime': _endTime,
      'minmagnitude': '4',
      'orderby': _orderBy,
      'limit': '500',
      'latitude': '$_latitude',
      'longitude': '$_longitude',
      'maxradiuskm': '$_maxRadiusKm',
    };
  }

  Color getAlertColor(String color) {
    return switch (color) {
      'green' => Colors.green,
      'yellow' => Colors.yellow,
      'orange' => Colors.orange,
      _ => Colors.red,
    };
  }

  void setOrder(String value) {
    _orderBy = value;
    notifyListeners();
    _setQueryParams();
    getEarthquakeData();
  }

  // Setters for Settings page
  void setStartTime(String date) {
    _startTime = date;
    _setQueryParams();
    notifyListeners();
  }

  void setEndTime(String date) {
    _endTime = date;
    _setQueryParams();
    notifyListeners();
  }
}
