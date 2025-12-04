class GetShopsWithStock {
  final String stockId;
  final String cyId;
  final String cylinderName;
  final String quantityAvailable;
  final String price;

  GetShopsWithStock({
    required this.stockId,
    required this.cyId,
    required this.cylinderName,
    required this.quantityAvailable,
    required this.price,
  });

  factory GetShopsWithStock.fromJson(Map<String, dynamic> json) {
    return GetShopsWithStock(
      stockId: json['stock_id'] ?? '0',
      cyId: json['cy_id'] ?? '0',
      cylinderName: json['cylinder_name'] ?? '0',
      quantityAvailable: json['quantity_available'] ?? '0',
      price: json['price'] ?? '0',
    );
  }
}

class GetShopsWithShop {
  final String shopId;
  final String shopName;
  final String lat;
  final String long;
  final String shopCity;
  final String openTime;
  final String closeTime;
  final List<GetShopsWithStock> stocks;

  GetShopsWithShop({
    required this.shopId,
    required this.shopName,
    required this.lat,
    required this.long,
    required this.shopCity,
    required this.openTime,
    required this.closeTime,
    required this.stocks,
  });

  factory GetShopsWithShop.fromJson(Map<String, dynamic> json) {
    var stockList = <GetShopsWithStock>[];
    if (json['stocks'] != null) {
      stockList = List<GetShopsWithStock>.from(
        json['stocks'].map((x) => GetShopsWithStock.fromJson(x)),
      );
    }
    return GetShopsWithShop(
      shopId: json['shop_id'] ?? '0',
      shopName: json['shop_name'] ?? '0',
      lat: json['lat'] ?? '0',
      long: json['long'] ?? '0',
      shopCity: json['shop_city'] ?? '0',
      openTime: json['opentime'] ?? '0',
      closeTime: json['closetime'] ?? '0',
      stocks: stockList,
    );
  }
}
