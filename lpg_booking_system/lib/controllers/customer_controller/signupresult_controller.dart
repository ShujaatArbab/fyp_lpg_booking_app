import 'package:lpg_booking_system/models/customers_models/signup_response.dart';

class SignupResult {
  final SignupResponse? data;
  final String? error;

  SignupResult({this.data, this.error});
}
