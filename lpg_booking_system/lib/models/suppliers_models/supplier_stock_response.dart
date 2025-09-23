class SupplierStock {
  final int stockId;
  final int cylinderId;
  final String cylinderSize;
  final int quantityAvailable;
  final String shopId;
  final String supplierId;
  final String supplierName;

  SupplierStock({
    required this.stockId,
    required this.cylinderId,
    required this.cylinderSize,
    required this.quantityAvailable,
    required this.shopId,
    required this.supplierId,
    required this.supplierName,
  });

  factory SupplierStock.fromJson(Map<String, dynamic> json) {
    return SupplierStock(
      stockId: json['stock_id'],
      cylinderId: json['cy_id'],
      cylinderSize: json['CylinderSize'],
      quantityAvailable: json['quantity_available'],
      shopId: json['ShopId'],
      supplierId: json['SupplierId'],
      supplierName: json['SupplierName'],
    );
  }
}
