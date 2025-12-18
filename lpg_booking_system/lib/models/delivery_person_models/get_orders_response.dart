class DeliveryOrderResponse {
  final int orderId;
  final String customerName;
  final String vendorName;

  DeliveryOrderResponse({
    required this.orderId,
    required this.customerName,
    required this.vendorName,
  });

  factory DeliveryOrderResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderResponse(
      orderId: json['Order_id'],
      customerName: json['CustomerName'],
      vendorName: json['VendorName'],
    );
  }
}
