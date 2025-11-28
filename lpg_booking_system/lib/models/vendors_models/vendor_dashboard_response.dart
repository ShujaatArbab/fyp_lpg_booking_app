// models/vendor_dashboard.dart

class VendorDashboard {
  final int totalStock;
  final int pendingOrders;
  final int dispatchedOrders;
  final int deliveredOrders;
  final List<ShopStock> shopStocks;

  VendorDashboard({
    required this.totalStock,
    required this.pendingOrders,
    required this.dispatchedOrders,
    required this.deliveredOrders,
    required this.shopStocks,
  });

  factory VendorDashboard.fromJson(Map<String, dynamic> json) {
    var shopList = <ShopStock>[];
    if (json['ShopStocks'] != null) {
      shopList =
          (json['ShopStocks'] as List)
              .map((e) => ShopStock.fromJson(e))
              .toList();
    }

    return VendorDashboard(
      totalStock: json['TotalStock'] ?? 0,
      pendingOrders: json['PendingOrders'] ?? 0,
      dispatchedOrders: json['DispatchedOrders'] ?? 0,
      deliveredOrders: json['DeliveredOrders'] ?? 0,
      shopStocks: shopList,
    );
  }
}

class ShopStock {
  final int shopId;
  final String shopName;
  final List<CylinderStock> cylinderStocks;

  ShopStock({
    required this.shopId,
    required this.shopName,
    required this.cylinderStocks,
  });

  factory ShopStock.fromJson(Map<String, dynamic> json) {
    var cylinderList = <CylinderStock>[];
    if (json['CylinderStocks'] != null) {
      cylinderList =
          (json['CylinderStocks'] as List)
              .map((e) => CylinderStock.fromJson(e))
              .toList();
    }

    return ShopStock(
      shopId: json['ShopId'],
      shopName: json['ShopName'] ?? '',
      cylinderStocks: cylinderList,
    );
  }
}

class CylinderStock {
  final int cylinderId;
  final String cylinderType;
  final int weight;
  final int quantity;

  CylinderStock({
    required this.cylinderId,
    required this.cylinderType,
    required this.weight,
    required this.quantity,
  });

  factory CylinderStock.fromJson(Map<String, dynamic> json) {
    return CylinderStock(
      cylinderId: json['CylinderId'],
      cylinderType: json['CylinderType'] ?? '',
      weight: json['Weight'] ?? 0,
      quantity: json['Quantity'] ?? 0,
    );
  }
}
