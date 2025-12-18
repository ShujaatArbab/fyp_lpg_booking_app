class AddDPRequest {
  final String dpName;
  final String dpPhone;
  final String vendorId;
  final String dpEmail;
  final String dpPassword;

  AddDPRequest({
    required this.dpName,
    required this.dpPhone,
    required this.dpEmail,
    required this.dpPassword,
    required this.vendorId,
  });

  Map<String, dynamic> toJson() {
    return {
      "dp_name": dpName,
      "dp_phone": dpPhone,
      "dp_email": dpEmail,
      "dp_password": dpPassword,
      "vendorid": vendorId,
    };
  }
}
