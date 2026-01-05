class VendorMonthlySummaryResponse {
  final String vendorId;
  final String month;
  final int totalOrders;
  final int totalCylinders;
  final List<CylinderSummary> cylinderSummary;

  VendorMonthlySummaryResponse({
    required this.vendorId,
    required this.month,
    required this.totalOrders,
    required this.totalCylinders,
    required this.cylinderSummary,
  });

  factory VendorMonthlySummaryResponse.fromJson(Map<String, dynamic> json) {
    return VendorMonthlySummaryResponse(
      vendorId: json['VendorId'],
      month: json['Month'],
      totalOrders: json['TotalOrders'],
      totalCylinders: json['TotalCylinders'],
      cylinderSummary:
          (json['CylinderSummary'] as List)
              .map((e) => CylinderSummary.fromJson(e))
              .toList(),
    );
  }
}

class CylinderSummary {
  final String cylinderSize;
  final int quantity;

  CylinderSummary({required this.cylinderSize, required this.quantity});

  factory CylinderSummary.fromJson(Map<String, dynamic> json) {
    return CylinderSummary(
      cylinderSize: json['CylinderSize'],
      quantity: json['Quantity'],
    );
  }
}
