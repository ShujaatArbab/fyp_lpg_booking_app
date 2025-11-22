class ComplaintRequest {
  final int orderId;
  final String complaintText;
  final String sellerResponse;

  ComplaintRequest({
    required this.orderId,
    required this.complaintText,
    this.sellerResponse = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "complaint_text": complaintText,
      "seller_response": sellerResponse,
    };
  }
}
