import 'dart:convert';

import 'package:covid19/src/models/country.dart';
import 'package:covid19/src/models/global.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('https://pomber.github.io/covid19/timeseries.json'));
  return compute(_parseJson, response.body);
}

Map<String, dynamic> _parseJson(String body) {
  var json = jsonDecode(body) as Map<String, dynamic>;
  var countries = <Country>[];

  DateTime? date;
  int totalConfirmed = 0;
  int totalDeaths = 0;
  int totalRecovered = 0;

  json.forEach((name, reports) {
    var country = Country.fromJson(name, reports as List<dynamic>);

    date = country.date;
    totalConfirmed += country.confirmed ?? 0;
    totalDeaths += country.deaths ?? 0;
    totalRecovered += country.recovered ?? 0;

    countries.add(country);
  });

  countries.sort((a, b) => (b.deaths ?? 0).compareTo(a.deaths ?? 0));

  final map = <String, dynamic>{};

  map['countries'] = countries;
  map['global'] = Global()
    ..date = date
    ..confirmed = totalConfirmed
    ..deaths = totalDeaths
    ..recovered = totalRecovered;

  return map;
}
