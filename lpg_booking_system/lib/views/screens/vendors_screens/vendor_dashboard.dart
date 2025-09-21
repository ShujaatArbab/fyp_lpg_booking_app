import 'package:flutter/material.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/add_deliveryperson_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/add_shop_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class Vendordashboard extends StatefulWidget {
  final LoginResponse vendor;
  const Vendordashboard({super.key, required this.vendor});

  @override
  State<Vendordashboard> createState() => _VendordashboardState();
}

class _VendordashboardState extends State<Vendordashboard> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Vendordashboard(vendor: widget.vendor),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OrdersScreen(vendorId: widget.vendor.userid),
              ),
            );
          }
        },
      ),
      body: Column(
        children: [
          //! top header
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.orangeAccent,
            child: Container(
              margin: const EdgeInsets.only(left: 30, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! welcome text
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Row(
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //! name + notification icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.vendor.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //! userId
                  Row(
                    children: [
                      Text(
                        'UserID: ${widget.vendor.userid}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //! region
          Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Region : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.vendor.city,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AddShopScreen(loginResponse: widget.vendor),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 60,
                    height: 50,
                    child: Card(
                      child: Column(
                        children: [
                          Icon(Icons.add_business, size: 25, color: Colors.red),

                          Text(
                            'Add Shop',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AddDeliveryPersonScreen(
                              loginResponse: widget.vendor,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 60,
                    height: 50,
                    child: Card(
                      child: Column(
                        children: [
                          Icon(Icons.add_business, size: 25, color: Colors.red),

                          Text(
                            'Person',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
