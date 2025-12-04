class UpdatePriceRequest {
  final String userId;
  final int shopId;
  final int cylinderId;
  final int price;

  UpdatePriceRequest({
    required this.userId,
    required this.shopId,
    required this.cylinderId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'ShopId': shopId,
      'CylinderId': cylinderId,
      'Price': price,
    };
  }
}
