class VendorResponse {
  final String userID;
  final String name;
  final String phone;
  final String email;
  final double? longitude;
  final double? latitude;
  final String city;
  final List<Shop> shops; // ✅ Add this

  VendorResponse({
    required this.city,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    required this.userID,
    required this.shops, // ✅ Add this
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      city: json['City'] ?? '',
      email: json['Email'] ?? '',
      latitude: (json['Latitude'] as num?)?.toDouble(),
      longitude: (json['Longitude'] as num?)?.toDouble(),
      name: json['Name'] ?? '',
      phone: json['Phone'] ?? '',
      userID: json['UserID'].toString(),
      shops:
          (json['Shops'] as List<dynamic>? ?? [])
              .map((shopJson) => Shop.fromJson(shopJson))
              .toList(), // ✅ Parse shops
    );
  }
}

class Shop {
  final int shopId;
  final String shopName;
  final double latitude;
  final double longitude;
  final String city;
  final List<Stock> stock;

  Shop({
    required this.shopId,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.stock,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      shopId: json['ShopID'] ?? 0,
      shopName: json['ShopName'] ?? '',
      latitude: (json['Latitude'] ?? 0).toDouble(),
      longitude: (json['Longitude'] ?? 0).toDouble(),
      city: json['City'] ?? '',
      stock:
          (json['Stock'] as List<dynamic>? ?? [])
              .map((stockJson) => Stock.fromJson(stockJson))
              .toList(),
    );
  }
}

class Stock {
  final int stockId;
  final int cylinderId;
  final int quantityAvailable;

  Stock({
    required this.stockId,
    required this.cylinderId,
    required this.quantityAvailable,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockId: json['StockID'] ?? 0,
      cylinderId: json['CylinderID'] ?? 0,
      quantityAvailable: json['QuantityAvailable'] ?? 0,
    );
  }
}
