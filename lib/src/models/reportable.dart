abstract class Reportable {
  DateTime? date;
  int? confirmed;
  int? deaths;
  int? recovered;

  String get confirmedPerc =>
      '(${(( (confirmed ?? 0) / ((confirmed ?? 0) + (deaths ?? 0) + (recovered ?? 0))) * 100).toStringAsFixed(1)}%)';
  String get deathsPerc =>
      '(${(( (deaths ?? 0) / ((confirmed ?? 0) + (deaths ?? 0) + (recovered ?? 0))) * 100).toStringAsFixed(1)}%)';
  String get recoveredPerc =>
      '(${(( (recovered ?? 0) / ((confirmed ?? 0) + (deaths ?? 0) + (recovered ?? 0))) * 100).toStringAsFixed(1)}%)';

  Reportable({
    this.date,
    this.confirmed,
    this.deaths,
    this.recovered,
  });
}
