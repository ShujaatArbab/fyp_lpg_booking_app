class GetComplaintResponse {
  final int comId;
  final int orderId;
  final String complaintText;
  final String complaintStatus;
  final String orderDate; // ISO string from API
  final String buyerId;
  final String sellerId;

  GetComplaintResponse({
    required this.comId,
    required this.orderId,
    required this.complaintText,
    required this.complaintStatus,
    required this.orderDate,
    required this.buyerId,
    required this.sellerId,
  });

  factory GetComplaintResponse.fromJson(Map<String, dynamic> json) {
    return GetComplaintResponse(
      comId: json['com_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      complaintText: json['complaint_text'] ?? "",
      complaintStatus: json['complaint_status'] ?? "",
      orderDate: json['OrderDate']?.toString() ?? "",
      buyerId: json['BuyerId'] ?? "",
      sellerId: json['SellerId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'com_id': comId,
      'order_id': orderId,
      'complaint_text': complaintText,
      'complaint_status': complaintStatus,
      'OrderDate': orderDate,
      'BuyerId': buyerId,
      'SellerId': sellerId,
    };
  }
}
