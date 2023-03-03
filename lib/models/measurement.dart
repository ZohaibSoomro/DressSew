class Measurement {
  String title;
  String unit;
  double measure;

  Measurement({required this.title, this.unit = 'in', required this.measure});
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

enum MeasurementChoice {
  online,
  physical,
  viaAgent,
}

const Map<String, String> measurementImages = {
  "neck": "assets/measurementImages/neck.jpg",
  "shoulderWidth": "assets/measurementImages/shoulderWidth.jpg",
  "halfShoulder": "assets/measurementImages/halfShoulder.jpg",
  "chest": "assets/measurementImages/chest.jpg",
  "waist": "assets/measurementImages/waist.jpg",
  "waistToAnkle": "assets/measurementImages/waistToAnkle.jpg",
  "shirtLength": "assets/measurementImages/shirtLength.jpg",
  "sleeveLength": "assets/measurementImages/sleeveLength.jpg",
};
