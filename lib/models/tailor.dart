import 'package:dresssew/models/shop.dart';

class Tailor {
  String tailorName;
  String email;
  String? id;
  Gender gender;
  String? phoneNumber;
  StitchingType stitchingType;
  List<String> expertise;
  String? profileImageUrl;
  List<Rates> rates;
  Shop? shop;
  int? experience;
  bool? customizes;
  String? onTimeDelivery;
  String? customerDocId;
  double? rating;
  List<OrdersPlaced> orders;

  Tailor({
    this.id,
    required this.tailorName,
    this.phoneNumber,
    this.shop,
    this.customerDocId,
    required this.email,
    this.experience,
    this.customizes,
    this.onTimeDelivery,
    this.rating,
    required this.gender,
    this.orders = const [],
    this.profileImageUrl,
    this.rates = const [],
    this.expertise = const [],
    required this.stitchingType,
  });

  static Tailor fromJson(Map<String, dynamic> json) => Tailor(
      id: json['id'],
      customerDocId: json['customer_doc_id'],
      tailorName: json['tailor_name'],
      phoneNumber: json['phone_number'],
      shop: Shop.fromJson(json['shop']),
      email: json['email'],
      gender: getGender(json['gender']),
      experience: json['experience'],
      customizes: json['customizes'],
      onTimeDelivery: json['on_time_delivery'],
      rating: json['rating'],
      orders: (json['orders'] as List)
          .map((e) => OrdersPlaced.fromJson(e))
          .toList(),
      rates: (json['rates'] as List).map((e) => Rates.fromJson(e)).toList(),
      expertise: json['expertise'].cast<String>(),
      stitchingType: getStitchingType(json['stitching_type']),
      profileImageUrl: json['profile_image_url']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_doc_id': customerDocId,
        'tailor_name': tailorName,
        'phone_number': phoneNumber,
        'email': email,
        'gender': gender.name,
        'experience': experience,
        'shop': shop?.toJson(),
        'profile_image_url': profileImageUrl,
        'customizes': customizes,
        'on_time_delivery': onTimeDelivery,
        'rating': rating,
        'orders': orders.map((e) => e.toJson()).toList(),
        'rates': rates.map((e) => e.toJson()).toList(),
        'expertise': expertise,
        'stitchingType': stitchingType.name,
      };
}

class OrdersPlaced {
  String customerId;
  String customerName;
  int rating;
  String reviewText;
  String orderId;
  String deliveryDate;

  OrdersPlaced(
      {required this.customerId,
      required this.customerName,
      required this.rating,
      required this.reviewText,
      required this.orderId,
      required this.deliveryDate});

  static OrdersPlaced fromJson(Map<String, dynamic> json) => OrdersPlaced(
        customerId: json['customer_id'],
        customerName: json['customer_name'],
        rating: json['rating'],
        reviewText: json['review_text'],
        orderId: json['order_id'],
        deliveryDate: json['delivery_date'],
      );

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'customer_name': customerName,
        'rating': rating,
        'review_text': reviewText,
        'order_id': orderId,
        'delivery_date': deliveryDate,
      };
}

class Rates {
  String category;
  int price;

  Rates({required this.category, required this.price});

  static Rates fromJson(Map<String, dynamic> json) => Rates(
        category: json['category'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'price': price,
      };
}

enum StitchingType {
  gents,
  ladies,
  both,
}

StitchingType getStitchingType(String type) {
  StitchingType stitchingType = type == StitchingType.gents.name
      ? StitchingType.gents
      : type == StitchingType.ladies.name
          ? StitchingType.ladies
          : StitchingType.both;
  return stitchingType;
}

enum Gender { male, female }

Gender getGender(String type) {
  Gender gender = type == Gender.male.name ? Gender.male : Gender.female;
  return gender;
}
