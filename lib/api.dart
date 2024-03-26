import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrayerTimes {
  final DateTime date;
  final Map<String, String> timings;

  PrayerTimes({required this.date, required this.timings});

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      date: DateTime.parse(json['date']['readable']),
      timings: Map<String, String>.from(json['timings']),
    );
  }
}

Future<PrayerTimes> fetchPrayerTimes(double latitude, double longitude, String apiKey) async {
  final response = await http.get(Uri.parse('http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2&school=1&timestamp=${DateTime.now().millisecondsSinceEpoch / 1000}&timezonestring=UTC&format=json&api_key=$apiKey'));

  if (response.statusCode == 200) {
    return PrayerTimes.fromJson(json.decode(response.body)['data']);
  } else {
    throw Exception('Failed to load prayer times');
  }
}
