import 'package:flutter/material.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/change_password_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/login_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/show_complaints_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/update_prices_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  final LoginResponse profile;
  const VendorProfileScreen({super.key, required this.profile});

  @override
  State<VendorProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<VendorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! APp Bar
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      //! Pic +name +email
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, top: 20),
                width: 385,
                height: 150,
                child: Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40.0, top: 30),
                            child: Row(
                              children: [
                                Text(
                                  'Name : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),

                                Text(
                                  widget.profile.name,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 40.0, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Email : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  widget.profile.email,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //!  My Orders
          SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => OrdersScreen(vendorId: widget.profile),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 385,
                  height: 70,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 90),

                          Text(
                            'My Orders',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 100),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //!  Address
          SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UpdatePricesScreen(
                            vendorUserId: widget.profile.userid,
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 385,
                  height: 70,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.home,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 90),

                          Text(
                            'Update Prices',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 50),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //!  Change Password
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangePasswordScreen(
                            userId: widget.profile.userid,
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 385,
                  height: 70,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.lock,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 60),

                          Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 60),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ShowComplaintsScreen(vendorId: widget.profile),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 385,
                  height: 70,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.lock,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 60),

                          Text(
                            'See Complaints',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 60),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //!  sign out button
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
