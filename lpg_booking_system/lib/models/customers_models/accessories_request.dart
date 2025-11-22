class AccessoriesRequest {
  final String userId; // C-001, V-001, S-001
  final int cylinderId; // 1=11kg, 2=15kg, 3=45kg
  final String usagePurpose; // Comma-separated purposes

  AccessoriesRequest({
    required this.userId,
    required this.cylinderId,
    required this.usagePurpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'CylinderId': cylinderId,
      'UsagePurpose': usagePurpose,
    };
  }
}
