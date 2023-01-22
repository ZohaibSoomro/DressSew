import 'package:dresssew/models/tailor.dart';

class Customer {
  String? id;
  String name;
  String email;
  bool isRegisteredTailor;
  bool isTailor;
  Gender? gender;
  List<OrdersPlaced> orders;
  String? phoneNumber;
  List<int> profileImageBytes;
  String? address;
  String dateJoined;

  Customer(
      {this.id,
      this.isRegisteredTailor = false,
      required this.dateJoined,
      required this.name,
      required this.email,
      this.gender,
      this.orders = const [],
      this.profileImageBytes = const [],
      this.address,
      this.phoneNumber,
      required this.isTailor});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'gender': gender?.name,
        'date_joined': dateJoined,
        'is_tailor': isTailor,
        'orders': orders.map((e) => e.toJson()).toList(),
        'phone_number': phoneNumber,
        'is_registered': isRegisteredTailor,
        'address': address,
        'profile_image_bytes': profileImageBytes,
      };

  static Customer fromJson(Map<String, dynamic> json) {
    return Customer(
        name: json['name'],
        gender: json['gender'] != null ? getGender(json['gender']) : null,
        email: json['email'],
        isTailor: json['is_tailor'],
        profileImageBytes: json['profile_image_bytes'].cast<int>(),
        id: json['id'],
        isRegisteredTailor: json['is_registered'],
        address: json['address'],
        phoneNumber: json['phone_number'],
        dateJoined: json['date_joined'],
        orders: (json['orders'] as List)
            .map((e) => OrdersPlaced.fromJson(e))
            .toList());
  }
}
