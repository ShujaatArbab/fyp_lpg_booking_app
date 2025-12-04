import 'package:flutter/material.dart';
import 'package:lpg_booking_system/views/screens/change_password_request.dart';
import 'package:lpg_booking_system/views/screens/change_password_response.dart';
import 'package:lpg_booking_system/views/screens/change_password_controller.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/input_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userId; // Pass from LoginResponse

  const ChangePasswordScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isOldObscure = true;
  bool _isNewObscure = true;
  bool _isConfirmObscure = true;

  // Error strings
  String oldPasswordError = '';
  String newPasswordError = '';
  String confirmPasswordError = '';

  final Passwordchanging apiService = Passwordchanging();

  void _validateFields() {
    setState(() {
      oldPasswordError =
          _oldPasswordController.text.isEmpty ? "Enter old password" : '';
      newPasswordError =
          _newPasswordController.text.isEmpty ? "Enter new password" : '';
      confirmPasswordError =
          _confirmPasswordController.text.isEmpty ? "Confirm new password" : '';
    });
  }

  Future<void> _handleChangePassword() async {
    _validateFields();

    if (oldPasswordError.isNotEmpty ||
        newPasswordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty) {
      return;
    }

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      setState(() {
        confirmPasswordError = "New password and confirm password do not match";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = ChangePasswordRequest(
        userId: widget.userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final ChangePasswordResponse response = await apiService.changePassword(
        request,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context); // Go back after success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Instruction text
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Please enter your old and new password",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Old Password
                  SizedBox(
                    width: 350,
                    child: TextInputField(
                      controller: _oldPasswordController,
                      icon: Icons.lock,
                      labelText: "Old Password",
                      hintText: "Enter old password",
                      obscureText: _isOldObscure,
                      errorText: oldPasswordError,
                      suffixicon: IconButton(
                        icon: Icon(
                          _isOldObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isOldObscure = !_isOldObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // New Password
                  SizedBox(
                    width: 350,
                    child: TextInputField(
                      controller: _newPasswordController,
                      icon: Icons.lock_outline,
                      labelText: "New Password",
                      hintText: "Enter new password",
                      obscureText: _isNewObscure,
                      errorText: newPasswordError,
                      suffixicon: IconButton(
                        icon: Icon(
                          _isNewObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewObscure = !_isNewObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password
                  SizedBox(
                    width: 350,
                    child: TextInputField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      labelText: "Confirm Password",
                      hintText: "Confirm new password",
                      obscureText: _isConfirmObscure,
                      errorText: confirmPasswordError,
                      suffixicon: IconButton(
                        icon: Icon(
                          _isConfirmObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmObscure = !_isConfirmObscure;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        width: 200,
                        child: CustomButton(
                          text: "Change",
                          onpressed: _handleChangePassword,
                        ),
                      ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
