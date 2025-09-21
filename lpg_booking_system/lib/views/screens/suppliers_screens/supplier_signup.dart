import 'package:flutter/material.dart';
import 'package:lpg_booking_system/constants.dart';
import 'package:lpg_booking_system/controllers/supplier_controller/supplier_signup_controller.dart';
import 'package:lpg_booking_system/models/suppliers_models/supplier_signup_request.dart';
import 'package:lpg_booking_system/models/suppliers_models/supplier_signup_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/login_screen.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/input_field.dart';

class SupplierSignupScreen extends StatefulWidget {
  final String selectedRole;
  const SupplierSignupScreen({super.key, required this.selectedRole});

  @override
  State<SupplierSignupScreen> createState() => _SupplierSignupScreenState();
}

class _SupplierSignupScreenState extends State<SupplierSignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController plantCityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscureConfirm = true;

  String errorName = "";
  String errorPhone = "";
  String errorEmail = "";
  String errorCity = "";
  String errorPlantName = "";
  String errorPlantCity = "";
  String errorPassword = "";
  String errorConfirm = "";

  bool isLoading = false;

  final SupplierSignupController signupController = SupplierSignupController();

  //! Input Validation
  bool validateInputs() {
    setState(() {
      errorName = nameController.text.isEmpty ? "Enter name" : "";
      errorPhone = phoneController.text.isEmpty ? "Enter phone" : "";
      errorEmail = emailController.text.isEmpty ? "Enter email" : "";
      errorCity = cityController.text.isEmpty ? "Enter city" : "";
      errorPlantName =
          plantNameController.text.isEmpty ? "Enter plant name" : "";
      errorPlantCity =
          plantCityController.text.isEmpty ? "Enter plant city" : "";
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
        errorPlantName.isEmpty &&
        errorPlantCity.isEmpty &&
        errorPassword.isEmpty &&
        errorConfirm.isEmpty;
  }

  //! Real Signup (API call)
  void signup() async {
    if (!validateInputs()) return;

    setState(() => isLoading = true);

    final request = SupplierSignupRequest(
      email: emailController.text,
      password: passwordController.text,
      role: widget.selectedRole, // pass role from screen
      name: nameController.text,
      phone: phoneController.text,
      city: cityController.text,
      plantName: plantNameController.text,
      plantCity: plantCityController.text,
    );

    final SupplierSignupResponse? response = await signupController
        .signupSupplier(request);

    setState(() => isLoading = false);

    if (response != null && response.data != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Please try again.")),
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
              "CREATE SUPPLIER ACCOUNT",
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
            // Plant Name
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: plantNameController,
                icon: Icons.factory,
                labelText: "Plant Name",
                hintText: "Enter plant name",
                obscureText: false,
                errorText: errorPlantName,
              ),
            ),
            const SizedBox(height: 15),
            // Plant City
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: plantCityController,
                icon: Icons.location_city,
                labelText: "Plant City",
                hintText: "Enter plant city",
                obscureText: false,
                errorText: errorPlantCity,
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
