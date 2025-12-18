class DeliveryLoginRequest {
  final String dpEmail;
  final String dpPassword;

  DeliveryLoginRequest({required this.dpEmail, required this.dpPassword});

  Map<String, dynamic> toJson() {
    return {"dp_email": dpEmail, "dp_password": dpPassword};
  }
}
