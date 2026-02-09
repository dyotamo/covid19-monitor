import 'dart:convert';

import 'package:covid19/src/models/reportable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Country extends Reportable {
  String name;

  Country(this.name);

  // res: [{"flags":{"svg":"https://restcountries.com/data/moz.svg"}}]
  Future<String> get flag async {
    final response = await http.get(
        Uri.parse('https://restcountries.com/v3.1/name/$name?fields=flags&fullText=true'));
    final List<dynamic> data = jsonDecode(response.body);
    return data.first['flags']['svg'];
  }

  factory Country.fromJson(String name, List<dynamic> reports) {
    var country = Country(name);
    if (reports.isNotEmpty) {
      var lastReport = reports.last;
      if (lastReport['date'] != null) {
        country.date = DateFormat('yyyy-MM-dd').parse(lastReport['date']);
      }
      country.confirmed = lastReport['confirmed'];
      country.deaths = lastReport['deaths'];
      country.recovered = lastReport['recovered'];
    }
    return country;
  }

  @override
  String toString() => name;
}
