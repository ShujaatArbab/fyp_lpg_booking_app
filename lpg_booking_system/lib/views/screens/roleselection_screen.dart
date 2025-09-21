import 'package:flutter/material.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/cust_signup_screen.dart';
import 'package:lpg_booking_system/views/screens/suppliers_screens/supplier_signup.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/ven_signup_screen.dart';

class RoleselectionScreen extends StatefulWidget {
  const RoleselectionScreen({super.key});

  @override
  State<RoleselectionScreen> createState() => _RoleselectionScreenState();
}

class _RoleselectionScreenState extends State<RoleselectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //!  appbar title
      appBar: AppBar(
        title: Text(
          'Role Selection',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      //!  select role
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 50, top: 20),

                child: Text(
                  'Please Select Role',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          //!  customer
          SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(selectedRole: 'cust'),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 100,
                  alignment: Alignment(0.0, 0.0),

                  margin: EdgeInsets.only(left: 100, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 3),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orange,
                  ),
                  child: Text(
                    'Customer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //!  vendor
          SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VendorSignupScreen(selectedRole: 'ven'),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 100,
                  alignment: Alignment(0.0, 0.0),

                  margin: EdgeInsets.only(left: 100, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 3),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orange,
                  ),
                  child: Text(
                    'Vendor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SupplierSignupScreen(selectedRole: 'sup'),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 100,
                  alignment: Alignment(0.0, 0.0),

                  margin: EdgeInsets.only(left: 100, top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 3),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orange,
                  ),
                  child: Text(
                    'Supplier',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
