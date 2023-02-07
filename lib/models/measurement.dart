class Measurement {
  String title;
  String unit;
  double measure;

  Measurement({required this.title, this.unit = 'cm', required this.measure});
  Map<String, dynamic> toJson() =>
      {'title': title, 'unit': unit, 'measure': measure};

  static Measurement fromJson(Map<String, dynamic> json) => Measurement(
        title: json['title'],
        unit: json['unit'],
        measure: json['measure'],
      );

  @override
  String toString() {
    return toJson().toString();
  }
}

enum Measurements {
  chestWidth,
  chestHeight,
  westWidth,
  westHeight,
}
