class Shop {
  String name;
  String address;
  String city;
  String country;
  int postalCode;
  ShopLocation shopLocation;
  String? logoUrl;
  List<String>? shopImages;

  Shop(
      {required this.address,
      required this.city,
      required this.name,
      required this.country,
      required this.postalCode,
      required this.shopLocation,
      this.logoUrl,
      this.shopImages});

  static Shop fromJson(Map<String, dynamic> json) {
    return Shop(
      address: json['address'],
      city: json['city'],
      name: json['name'],
      country: json['country'],
      postalCode: json['postal_code'],
      shopLocation: ShopLocation.fromJson(json['shop_location']),
      logoUrl: json['logo_url'],
      shopImages: json['shop_images'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'city': city,
        'country': country,
        'postal_code': postalCode,
        'shop_location': shopLocation.toJson(),
        'logo_url': logoUrl,
        'shop_images': shopImages,
      };
}

class ShopLocation {
  double latitude;
  double longitude;

  ShopLocation(this.latitude, this.longitude);

  static ShopLocation fromJson(Map<String, dynamic> json) {
    return ShopLocation(json['latitude'], json['longitude']);
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
