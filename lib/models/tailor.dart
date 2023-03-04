import 'package:dresssew/models/measurement.dart';
import 'package:dresssew/models/shop.dart';
import 'package:dresssew/models/user_location.dart';

class Tailor {
  String tailorName;
  String email;
  String? id;
  String? userDocId;
  Gender gender;
  String? phoneNumber;
  StitchingType stitchingType;
  List<String> expertise;
  String? profileImageUrl;
  List<Rates> rates;
  Shop? shop;
  int? experience;
  bool? customizes;
  double? onTimeDelivery;
  double? rating;
  // List<DresssewOrder> orders;
  UserLocation location;
  List<Review> reviews;

  Tailor({
    this.id,
    this.userDocId,
    required this.tailorName,
    this.phoneNumber,
    this.shop,
    required this.email,
    this.experience,
    this.customizes,
    this.onTimeDelivery = 100,
    this.rating = 0,
    required this.gender,
    // this.orders = const [],
    this.profileImageUrl,
    this.rates = const [],
    this.reviews = const [],
    this.expertise = const [],
    required this.stitchingType,
    required this.location,
  });

  static Tailor fromJson(Map<String, dynamic> json) => Tailor(
        id: json['id'],
        userDocId: json['user_doc_id'],
        tailorName: json['tailor_name'],
        phoneNumber: json['phone_number'],
        shop: Shop.fromJson(json['shop']),
        email: json['email'],
        reviews: (json['reviews'] != null
            ? (json['reviews'] as List).map((e) => Review.fromJson(e)).toList()
            : []),
        gender: getGender(json['gender']),
        experience: json['experience'],
        customizes: json['customizes'],
        onTimeDelivery: json['on_time_delivery']?.toDouble(),
        rating: json['rating']?.toDouble(),
        // orders: (json['orders'] != null
        //     ? (json['orders'] as List)
        //         .map((e) => DresssewOrder.fromJson(e))
        //         .toList()
        //     : []),
        rates: (json['rates'] as List).map((e) => Rates.fromJson(e)).toList(),
        expertise: json['expertise'].cast<String>(),
        stitchingType: getStitchingType(json['stitchingType']),
        location: UserLocation.fromMap(json['user_location']),
        profileImageUrl: json['profile_image_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tailor_name': tailorName,
        'user_doc_id': userDocId,
        'phone_number': phoneNumber,
        'email': email,
        'gender': gender.name,
        'experience': experience,
        'shop': shop?.toJson(),
        'reviews': reviews,
        'profile_image_url': profileImageUrl,
        'customizes': customizes,
        'on_time_delivery': onTimeDelivery,
        'user_location': location.toJson(),
        'rating': rating,
        // 'orders': orders.map((e) => e.toJson()).toList(),
        'rates': rates.map((e) => e.toJson()).toList(),
        'expertise': expertise,
        'stitchingType': stitchingType.name,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Review {
  String customerName;
  String customerProfileUrl;
  double rating;
  String reviewText;
  String reviewDate;
  String orderId;
  String category;

  Review({
    required this.customerProfileUrl,
    required this.reviewDate,
    required this.customerName,
    required this.rating,
    required this.reviewText,
    required this.orderId,
    required this.category,
  });

  static Review fromJson(Map<String, dynamic> json) => Review(
        customerName: json['customer_name'],
        customerProfileUrl: json['profile_url'],
        rating: json['rating'].toDouble(),
        reviewText: json['review_text'],
        orderId: json['order_id'],
        reviewDate: json['review_date'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'profile_url': customerProfileUrl,
        'rating': rating,
        'review_text': reviewText,
        'order_id': orderId,
        'review_date': reviewDate,
        'category': category,
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

  @override
  String toString() {
    return toJson().values.toString();
  }
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

MeasurementChoice getMeasurementChoice(String type) {
  MeasurementChoice measurementChoice = type == MeasurementChoice.physical.name
      ? MeasurementChoice.physical
      : type == MeasurementChoice.online.name
          ? MeasurementChoice.online
          : MeasurementChoice.viaAgent;
  return measurementChoice;
}
