import 'package:flutter/material.dart';
import 'package:lpg_booking_system/views/screens/signup_screen.dart';

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
              Container(
                width: 300,
                height: 200,
                alignment: Alignment(0.0, 0.0),

                margin: EdgeInsets.only(left: 50, top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SignupScreen(selectedRole: 'cust'),
                      ),
                    );
                  },
                  child: Text(
                    'Customer',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //!  vendor
          SizedBox(height: 30),
          Row(
            children: [
              Container(
                width: 300,
                height: 200,
                alignment: Alignment(0.0, 0.0),

                margin: EdgeInsets.only(left: 50, top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(selectedRole: 'ven'),
                      ),
                    );
                  },
                  child: Text(
                    'Vendor',
                    style: TextStyle(
                      color: Colors.orangeAccent,
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
