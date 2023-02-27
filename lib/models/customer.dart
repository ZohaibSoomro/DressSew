import 'package:dresssew/models/measurement.dart';
import 'package:dresssew/models/tailor.dart';
import 'package:dresssew/models/user_location.dart';

class Customer {
  String? id;
  String name;
  String email;
  Gender? gender;
  List<OrdersPlaced> orders;
  String? phoneNumber;
  String? profileImageUrl;
  String? address;
  String? userDocId;
  List<Measurement> measurements;
  MeasurementChoice measurementChoice;
  UserLocation location;

  Customer({
    this.id,
    required this.name,
    required this.email,
    this.gender,
    this.orders = const [],
    this.userDocId,
    this.profileImageUrl,
    this.address,
    this.measurementChoice = MeasurementChoice.online,
    this.phoneNumber,
    this.measurements = const [],
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'user_doc_id': userDocId,
        'gender': gender?.name,
        'orders': orders.map((e) => e.toJson()).toList(),
        'phone_number': phoneNumber,
        'measurement_choice': measurementChoice.name,
        'address': address,
        'measurements': measurements.map((e) => e.toJson()).toList(),
        'profile_image_url': profileImageUrl,
        'user_location': location.toJson(),
      };

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(
        name: json['name'],
        gender: json['gender'] != null ? getGender(json['gender']) : null,
        email: json['email'],
        measurementChoice: getMeasurementChoice(json['measurement_choice']),
        profileImageUrl: json['profile_image_url'],
        id: json['id'],
        userDocId: json['user_doc_id'],
        address: json['address'],
        measurements: (json['measurements'] as List)
            .map((e) => Measurement.fromJson(e))
            .toList(),
        phoneNumber: json['phone_number'],
        location: UserLocation.fromMap(json['user_location']),
        orders: (json['orders'] as List)
            .map((e) => OrdersPlaced.fromJson(e))
            .toList());
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
