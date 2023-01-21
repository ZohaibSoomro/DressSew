import 'package:dresssew/models/shop.dart';

class Tailor {
  String? id;
  String tailorName;
  String? phoneNumber;
  String? profileImageUrl;
  String email;
  int? experience;
  bool? customizes;
  String? onTimeDelivery;
  double? rating;
  List<Orders>? orders;
  List<Rates>? rates;
  List<String>? expertise;
  String? websiteUrl;
  String? stitchingType;
  Shop? shop;

  Tailor(
      {this.id,
      required this.tailorName,
      this.phoneNumber,
      this.shop,
      required this.email,
      this.experience,
      this.customizes,
      this.onTimeDelivery,
      this.rating,
      this.orders,
      this.profileImageUrl,
      this.rates,
      this.expertise,
      this.websiteUrl,
      this.stitchingType});

  static Tailor fromJson(Map<String, dynamic> json) => Tailor(
      id: json['id'],
      tailorName: json['tailor_name'],
      phoneNumber: json['phone_number'],
      shop: Shop.fromJson(json['shop']),
      email: json['email'],
      experience: json['experience'],
      customizes: json['customizes'],
      onTimeDelivery: json['on_time_delivery'],
      rating: json['rating'],
      orders: (json['orders'] as List).map((e) => Orders.fromJson(e)).toList(),
      rates: (json['rates'] as List).map((e) => Rates.fromJson(e)).toList(),
      expertise: json['expertise'].cast<String>(),
      websiteUrl: json['website_url'],
      stitchingType: json['stitching_type'],
      profileImageUrl: json['profile_image_url']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'tailor_name': tailorName,
        'phone_number': phoneNumber,
        'email': email,
        'experience': experience,
        'shop': shop?.toJson(),
        'profile_image_url': profileImageUrl,
        'customizes': customizes,
        'on_time_delivery': onTimeDelivery,
        'rating': rating,
        'orders': orders?.map((e) => e.toJson()).toList() ?? [],
        'rates': rates?.map((e) => e.toJson()).toList() ?? [],
        'expertise': expertise,
        'website_url': websiteUrl,
        'stitchingType': stitchingType,
      };
}

class Orders {
  String customerId;
  String customerName;
  int rating;
  String reviewText;
  String orderId;
  String deliveryDate;

  Orders(
      {required this.customerId,
      required this.customerName,
      required this.rating,
      required this.reviewText,
      required this.orderId,
      required this.deliveryDate});

  static Orders fromJson(Map<String, dynamic> json) => Orders(
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
