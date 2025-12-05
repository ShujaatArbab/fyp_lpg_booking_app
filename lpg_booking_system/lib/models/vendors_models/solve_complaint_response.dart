class VendorComplaintResponse {
  final String message;
  final int? complaintId;
  final int? orderId;
  final String? status;

  VendorComplaintResponse({
    required this.message,
    this.complaintId,
    this.orderId,
    this.status,
  });

  factory VendorComplaintResponse.fromJson(Map<String, dynamic> json) {
    return VendorComplaintResponse(
      message: json['message'] ?? '',
      complaintId: json['complaintId'],
      orderId: json['orderId'],
      status: json['status'],
    );
  }
}
