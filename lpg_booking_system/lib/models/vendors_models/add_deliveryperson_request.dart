class AddDPRequest {
  final String dpName;
  final String dpPhone;
  final String vendorId;

  AddDPRequest({
    required this.dpName,
    required this.dpPhone,
    required this.vendorId,
  });

  Map<String, dynamic> toJson() {
    return {"dp_name": dpName, "dp_phone": dpPhone, "vendorid": vendorId};
  }
}
