class AccessoriesRequest {
  final String userId;
  final int cylinderId;
  final String usagePurpose;
  final int quantity; // changed from String to int

  AccessoriesRequest({
    required this.userId,
    required this.cylinderId,
    required this.usagePurpose,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'CylinderId': cylinderId,
      'UsagePurpose': usagePurpose,
      'Quantity': quantity, // integer sent now
    };
  }
}
