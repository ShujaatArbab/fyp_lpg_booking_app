import 'package:flutter/material.dart';
import 'package:lpg_booking_system/constants.dart';
import 'package:lpg_booking_system/controllers/customer_controller/signup_controller.dart';
import 'package:lpg_booking_system/models/customers_models/signup_request.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/login_screen.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/input_field.dart';

class SignupScreen extends StatefulWidget {
  final String selectedRole;
  const SignupScreen({super.key, required this.selectedRole});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

TextEditingController namecontroller = TextEditingController();
TextEditingController phonecontroller = TextEditingController();
TextEditingController emailcontroller = TextEditingController();
TextEditingController citycontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();
TextEditingController confirmcontroller = TextEditingController();

String errorname = "";
String errorphone = "";
String erroremail = "";
String errorcity = "";
String errorpassword = "";
String errorconfirm = "";
bool isobscurepassword = true;
bool isobscureconfirm = true;
String? role;

class _SignupScreenState extends State<SignupScreen> {
  //! funtion
  void checkvalidation() async {
    setState(() {
      role = widget.selectedRole;
      errorname = namecontroller.text.isEmpty ? "Enter name" : "";
      errorphone = phonecontroller.text.isEmpty ? "Enter phone" : "";
      erroremail = emailcontroller.text.isEmpty ? "Enter email" : "";
      errorcity = citycontroller.text.isEmpty ? "Enter city" : "";
      errorpassword = passwordcontroller.text.isEmpty ? "Enter password" : "";
      errorconfirm = confirmcontroller.text.isEmpty ? "Confirm password" : "";
      if (passwordcontroller.text != confirmcontroller.text) {
        errorconfirm = "Password did't match";
      }
    });
    if (errorname.isNotEmpty ||
        errorphone.isNotEmpty ||
        erroremail.isNotEmpty ||
        errorpassword.isNotEmpty ||
        errorconfirm.isNotEmpty) {
      return;
    }

    final request = SignupRequest(
      name: namecontroller.text,
      phone: phonecontroller.text,
      email: emailcontroller.text,
      city: citycontroller.text,
      password: passwordcontroller.text,
      role: widget.selectedRole,
    );
    final result = await SignupController().Signup(request);
    if (result?.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result!.error!)));
    } else if (result?.data != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup Successful!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80, left: 30),
                child: Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          //!  input fields name
          SizedBox(height: 10),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: namecontroller,
              icon: Icons.person,
              labelText: "Full Name",
              hintText: "Enter name",
              obscureText: false,
              errorText: errorname,
            ),
          ),
          //!  input fields phone
          SizedBox(height: 15),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: phonecontroller,
              icon: Icons.phone,
              labelText: "Phone",
              hintText: "Enter phone",
              obscureText: false,
              errorText: errorphone,
            ),
          ),
          //!  input fields email
          SizedBox(height: 15),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: emailcontroller,
              icon: Icons.email,
              labelText: "Email",
              hintText: "Enter email",
              obscureText: false,
              errorText: erroremail,
            ),
          ),
          //!  input fields city
          SizedBox(height: 15),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: citycontroller,
              icon: Icons.location_on,
              labelText: "City",
              hintText: "Enter city",
              obscureText: false,
              errorText: errorcity,
            ),
          ),
          //!  input fields password
          SizedBox(height: 15),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: passwordcontroller,
              icon: Icons.lock,
              labelText: "Password",
              hintText: "Enter password",
              obscureText: isobscurepassword,
              errorText: errorpassword,
              suffixicon: IconButton(
                icon: Icon(
                  isobscurepassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isobscurepassword = !isobscurepassword;
                  });
                },
              ),
            ),
          ),
          //!  input fields confirm password
          SizedBox(height: 15),
          SizedBox(
            width: 350,
            child: TextInputField(
              controller: confirmcontroller,
              icon: Icons.lock,
              labelText: "Confirm password",
              hintText: "Enter password",
              obscureText: isobscureconfirm,
              errorText: errorconfirm,
              suffixicon: IconButton(
                icon: Icon(
                  isobscureconfirm ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isobscureconfirm = !isobscureconfirm;
                  });
                },
              ),
            ),
          ),
          //!  button
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.only(left: 200),
            child: CustomButton(
              text: "SIGN UP",
              onpressed: () {
                checkvalidation();
              },
            ),
          ),
          //!  signin
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.only(left: 70),
            child: Row(
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
          ),
        ],
      ),
    );
  }
}
