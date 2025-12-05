class VendorComplaintRequest {
  final int orderId;
  final String vendorId;
  final String sellerResponse;

  VendorComplaintRequest({
    required this.orderId,
    required this.vendorId,
    required this.sellerResponse,
  });

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "vendorId": vendorId,
    "sellerResponse": sellerResponse,
  };
}
