import 'package:flutter/material.dart';
import 'package:lpg_booking_system/constants.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/vendor_signup_controller.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_signup_request.dart';
import 'package:lpg_booking_system/models/vendors_models/vendor_signup_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/login_screen.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/input_field.dart';

class VendorSignupScreen extends StatefulWidget {
  final String selectedRole;
  const VendorSignupScreen({super.key, required this.selectedRole});

  @override
  State<VendorSignupScreen> createState() => _VendorSignupScreenState();
}

class _VendorSignupScreenState extends State<VendorSignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopCityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscureConfirm = true;

  String errorName = "";
  String errorPhone = "";
  String errorEmail = "";
  String errorCity = "";
  String errorShopName = "";
  String errorShopCity = "";
  String errorPassword = "";
  String errorConfirm = "";

  final VendorSignupController _controller = VendorSignupController();
  bool isLoading = false;

  //! Input Validation
  bool validateInputs() {
    setState(() {
      errorName = nameController.text.isEmpty ? "Enter name" : "";
      errorPhone = phoneController.text.isEmpty ? "Enter phone" : "";
      errorEmail = emailController.text.isEmpty ? "Enter email" : "";
      errorCity = cityController.text.isEmpty ? "Enter city" : "";
      errorShopName = shopNameController.text.isEmpty ? "Enter shop name" : "";
      errorShopCity = shopCityController.text.isEmpty ? "Enter shop city" : "";
      errorPassword = passwordController.text.isEmpty ? "Enter password" : "";
      errorConfirm = confirmController.text.isEmpty ? "Confirm password" : "";
      if (passwordController.text != confirmController.text) {
        errorConfirm = "Passwords didn't match";
      }
    });

    return errorName.isEmpty &&
        errorPhone.isEmpty &&
        errorEmail.isEmpty &&
        errorCity.isEmpty &&
        errorShopName.isEmpty &&
        errorShopCity.isEmpty &&
        errorPassword.isEmpty &&
        errorConfirm.isEmpty;
  }

  //! Signup API call
  void signup() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    // ✅ Use VendorSignupRequest
    VendorSignupRequest request = VendorSignupRequest(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
      city: cityController.text,
      role: widget.selectedRole, // role passed from previous screen
      shopName: shopNameController.text,
      shopCity: shopCityController.text,
    );

    VendorSignupResponse? response = await _controller.signupVendor(request);

    setState(() {
      isLoading = false;
    });

    if (response != null && response.data != null) {
      // Successful signup
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Error or failed signup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?.message ?? "Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              "VENDOR REGISTER",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Name
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: nameController,
                icon: Icons.person,
                labelText: "Full Name",
                hintText: "Enter name",
                obscureText: false,
                errorText: errorName,
              ),
            ),
            const SizedBox(height: 15),
            // Phone
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: phoneController,
                icon: Icons.phone,
                labelText: "Phone",
                hintText: "Enter phone",
                obscureText: false,
                errorText: errorPhone,
              ),
            ),
            const SizedBox(height: 15),
            // Email
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: emailController,
                icon: Icons.email,
                labelText: "Email",
                hintText: "Enter email",
                obscureText: false,
                errorText: errorEmail,
              ),
            ),
            const SizedBox(height: 15),
            // City
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: cityController,
                icon: Icons.location_on,
                labelText: "City",
                hintText: "Enter city",
                obscureText: false,
                errorText: errorCity,
              ),
            ),
            const SizedBox(height: 15),
            // Shop Name
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: shopNameController,
                icon: Icons.store,
                labelText: "Shop Name",
                hintText: "Enter shop name",
                obscureText: false,
                errorText: errorShopName,
              ),
            ),
            const SizedBox(height: 15),
            // Shop City
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: shopCityController,
                icon: Icons.location_city,
                labelText: "Shop City",
                hintText: "Enter shop city",
                obscureText: false,
                errorText: errorShopCity,
              ),
            ),
            const SizedBox(height: 15),
            // Password
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: passwordController,
                icon: Icons.lock,
                labelText: "Password",
                hintText: "Enter password",
                obscureText: isObscurePassword,
                errorText: errorPassword,
                suffixicon: IconButton(
                  icon: Icon(
                    isObscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Confirm Password
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: confirmController,
                icon: Icons.lock,
                labelText: "Confirm password",
                hintText: "Enter password again",
                obscureText: isObscureConfirm,
                errorText: errorConfirm,
                suffixicon: IconButton(
                  icon: Icon(
                    isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscureConfirm = !isObscureConfirm;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Signup button
            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: "SIGN UP", onpressed: signup),
            const SizedBox(height: 30),
            // Already have account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: buttonColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
