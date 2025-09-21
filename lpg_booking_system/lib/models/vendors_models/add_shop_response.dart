class AddShopResponse {
  final String message;
  final ShopData data;

  AddShopResponse({required this.message, required this.data});

  factory AddShopResponse.fromJson(Map<String, dynamic> json) {
    return AddShopResponse(
      message: json['message'],
      data: ShopData.fromJson(json['data']),
    );
  }
}

class ShopData {
  final int shopid;
  final String shopname;
  final String shopcity;
  final String opentime;
  final String closetime;
  final String userid;

  ShopData({
    required this.shopid,
    required this.shopname,
    required this.shopcity,
    required this.opentime,
    required this.closetime,
    required this.userid,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      shopid: json['shopid'],
      shopname: json['shopname'],
      shopcity: json['shopcity'],
      opentime: json['opentime'],
      closetime: json['closetime'],
      userid: json['userid'],
    );
  }
}
