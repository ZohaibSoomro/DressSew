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

const Map<String, String> measurementImages = {
  "neck": "assets/measurementImages/neck.jpg",
  "shoulderWidth": "assets/measurementImages/shoulderWidth.jpg",
  "halfShoulder": "assets/measurementImages/halfShoulder.jpg",
  "chest": "assets/measurementImages/chest.jpg",
  "waist": "assets/measurementImages/waist.jpg",
  "waistToAnkle": "assets/measurementImages/waistToAnkle.jpg",
  "shirtLength": "assets/measurementImages/shirtLength.jpg",
  "sleeveLength": "assets/measurementImages/coatSleeveLength.jpg",
  // "hip": "assets/measurementImages/hip.jpg",
  // "jacketLength": "assets/measurementImages/jacketLength.jpg",
  // "sleeveLengthForSuit": "assets/measurementImages/sleeveLengthForSuit.jpg",
  // "coatSleeveLength": "assets/measurementImages/coatSleeveLength.jpg",
  // "armLength": "assets/measurementImages/armLength.jpg",
  // "armHole": "assets/measurementImages/armHole.jpg",
  // "biceps": "assets/measurementImages/biceps.jpg",
  // "wrist": "assets/measurementImages/wrist.jpg",
  // "seat": "assets/measurementImages/seat.jpg",
  // "pantsLength": "assets/measurementImages/pantsLength.jpg",
  // "thighs": "assets/measurementImages/thighs.jpg",
  // "inseam": "assets/measurementImages/inseam.jpg",
  // "shortsLength": "assets/measurementImages/shortsLength.jpg",
  // "aboveKnee": "assets/measurementImages/aboveKnee.jpg",
  // "belowKnee": "assets/measurementImages/belowKnee.jpg",
  // "crotchToKnee": "assets/measurementImages/crotchToKnee.jpg",
  // "kneeToCalf": "assets/measurementImages/kneeToCalf.jpg",
  // "calf": "assets/measurementImages/calf.jpg",
  // "ankle": "assets/measurementImages/ankle.jpg",
  // "calfToAnkle": "assets/measurementImages/calfToAnkle.jpg",
};
