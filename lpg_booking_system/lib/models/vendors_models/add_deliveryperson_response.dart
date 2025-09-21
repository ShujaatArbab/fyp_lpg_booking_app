class AddDPResponse {
  final String message;
  final DPData? data;

  AddDPResponse({required this.message, this.data});

  factory AddDPResponse.fromJson(Map<String, dynamic> json) {
    return AddDPResponse(
      message: json['message'],
      data: json['data'] != null ? DPData.fromJson(json['data']) : null,
    );
  }
}

class DPData {
  final int dpid;
  final String dpname;
  final String dpphone;
  final String vendorid;

  DPData({
    required this.dpid,
    required this.dpname,
    required this.dpphone,
    required this.vendorid,
  });

  factory DPData.fromJson(Map<String, dynamic> json) {
    return DPData(
      dpid: json['dpid'],
      dpname: json['dpname'],
      dpphone: json['dpphone'],
      vendorid: json['vendorid'],
    );
  }
}
