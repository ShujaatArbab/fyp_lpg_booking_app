import 'package:flutter/material.dart';
import 'package:lpg_booking_system/constants.dart';
import 'package:lpg_booking_system/controllers/login_controller.dart';
import 'package:lpg_booking_system/models/login_request.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/views/screens/roleselection_screen.dart';
import 'package:lpg_booking_system/views/screens/suppliers_screens/show_orders_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/show_suppliers_screen.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController emailcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();

String erroremail = "";
String errorpassword = "";

class _LoginScreenState extends State<LoginScreen> {
  //!  funtion
  void checkvalidation() async {
    // Validate inputs and update UI
    setState(() {
      erroremail = emailcontroller.text.isEmpty ? "Enter email" : "";
      errorpassword = passwordcontroller.text.isEmpty ? "Enter password" : "";
    });

    if (erroremail.isNotEmpty || errorpassword.isNotEmpty) return;

    final request = LoginRequest(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    );

    final response = await LoginController().login(request);

    //!  login fails
    if (response == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid Credentials')));
      return;
    }

    // ✅ FIXED HERE

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login Successful. Welcome ${response.name}!')),
    );

    if (response.userid.startsWith("V-")) {
      // Vendor → go to Orders screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShowSupplierScreen(vendor: response)),
      );
    } else if (response.userid.startsWith("C-")) {
      // Customer → go to vendor browsing screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ShowVendorScreen(customer: response)),
      );
    } else if (response.userid.startsWith("S-")) {
      // Customer → go to vendor browsing screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SupplierOrdersScreen(supplierId: response.userid),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unknown user type")));
    }
  }

  bool isobscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100, left: 30),
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    "Please signin to continue",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            //!text field email
            SizedBox(height: 30),
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: emailcontroller,
                icon: Icons.person,
                labelText: "Email",
                hintText: "Enter email",
                obscureText: false,
                errorText: erroremail,
              ),
            ),
            //!text field password
            SizedBox(height: 30),
            SizedBox(
              width: 350,
              child: TextInputField(
                controller: passwordcontroller,
                icon: Icons.lock,
                labelText: "Password",
                hintText: "Enter password",
                obscureText: isobscure,
                errorText: errorpassword,
                suffixicon: IconButton(
                  icon: Icon(
                    isobscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      isobscure = !isobscure;
                    });
                  },
                ),
              ),
            ),
            //! button
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(left: 200),
              child: CustomButton(
                text: "SIGN IN",
                onpressed: () {
                  checkvalidation();
                },
              ),
            ),
            //! create account
            SizedBox(height: 260),
            Container(
              margin: EdgeInsets.only(left: 70),
              child: Row(
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoleselectionScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
