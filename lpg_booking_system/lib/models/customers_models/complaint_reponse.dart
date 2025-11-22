class ComplaintResponse {
  final String message;
  final int complaintId;

  ComplaintResponse({required this.message, required this.complaintId});

  factory ComplaintResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintResponse(
      message: json["message"],
      complaintId: json["complaint_id"],
    );
  }
}
