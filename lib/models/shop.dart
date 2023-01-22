class Shop {
  String name;
  String address;
  String? websiteUrl;
  String city;
  String country;
  int postalCode;
  List<int> logoUrl;
  List<List<int>> shopImagesBytes;

  Shop(
      {required this.address,
      required this.city,
      required this.name,
      this.websiteUrl,
      this.country = "Pakistan",
      required this.postalCode,
      this.logoUrl = const [],
      this.shopImagesBytes = const []});

  static Shop fromJson(Map<String, dynamic> json) {
    return Shop(
      address: json['address'],
      city: json['city'],
      name: json['name'],
      websiteUrl: json['website_url'],
      country: json['country'],
      postalCode: json['postal_code'],
      logoUrl: json['logo_url'].cast<int>(),
      shopImagesBytes: json['shop_images'].cast<List<int>>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'city': city,
        'country': country,
        'website_url': websiteUrl,
        'postal_code': postalCode,
        'logo_url': logoUrl,
        'shop_images': shopImagesBytes,
      };
}

// class ShopLocation {
//   double latitude;
//   double longitude;
//
//   ShopLocation(this.latitude, this.longitude);
//
//   static ShopLocation fromJson(Map<String, dynamic> json) {
//     return ShopLocation(json['latitude'], json['longitude']);
//   }
//
//   Map<String, dynamic> toJson() => {
//         'latitude': latitude,
//         'longitude': longitude,
//       };
// }
