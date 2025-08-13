class LoginRequest {
  final String email;
  final String password;
  LoginRequest({required this.email, required this.password});
  //! converting dart object to json
  Map<String, dynamic> toJson() {
    return {'Email': email, 'Password': password};
  }
}
