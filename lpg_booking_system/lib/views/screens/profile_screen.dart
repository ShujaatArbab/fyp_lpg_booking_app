import 'package:flutter/material.dart';
import 'package:lpg_booking_system/views/screens/login_screen.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                        children: [ListTile(leading: CircleAvatar(radius: 25))],
                      ),
                      Column(
                        children: [
                          Text(
                            'Shujaat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'shujaat11@gmail.com',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                onTap: () {},
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
                onTap: () {},
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
                              Icons.location_on,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 100),

                          Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 110),
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
                onTap: () {},
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
          //!  sign out button
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: 'Sign Out',
                onpressed: () {
                  LoginScreen();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
