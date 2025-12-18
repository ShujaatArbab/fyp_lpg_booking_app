class DeliveryLoginResponse {
  final int dpId;
  final String dpName;
  final String dpPhone;
  final String dpEmail;
  final String dpPassword;
  final String vendorId;

  DeliveryLoginResponse({
    required this.dpId,
    required this.dpName,
    required this.dpPhone,
    required this.dpEmail,
    required this.dpPassword,
    required this.vendorId,
  });

  factory DeliveryLoginResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryLoginResponse(
      dpId: json['DP_id'],
      dpName: json['DP_name'],
      dpPhone: json['DP_phone'],
      dpEmail: json['DP_email'],
      dpPassword: json['DP_password'],
      vendorId: json['VendorId'],
    );
  }
}
