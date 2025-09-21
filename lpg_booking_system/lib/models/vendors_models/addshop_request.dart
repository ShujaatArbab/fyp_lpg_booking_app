class AddShopRequest {
  final String shopName;
  final String shopCity;
  final String openTime;
  final String closeTime;
  final String userId; // comes from login response

  AddShopRequest({
    required this.shopName,
    required this.shopCity,
    required this.openTime,
    required this.closeTime,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "shop_name": shopName,
      "shop_city": shopCity,
      "opentime": openTime,
      "closetime": closeTime,
      "userid": userId,
    };
  }
}
