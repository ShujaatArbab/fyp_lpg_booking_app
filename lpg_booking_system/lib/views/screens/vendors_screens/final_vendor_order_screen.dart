import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'dart:ui';

import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';

class FinalVendororderconfirmScreen extends StatefulWidget {
  final int orderid;
  final List<TankItem> selecteditem;
  final String vendorName;
  final String vendorAddress;
  final String vendorPhone;
  final String vendorCity;
  final LoginResponse customer;
  final String vendorId;
  const FinalVendororderconfirmScreen({
    super.key,
    required this.orderid,
    required this.selecteditem,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorPhone,
    required this.vendorCity,
    required this.customer,
    required this.vendorId,
  });

  @override
  State<FinalVendororderconfirmScreen> createState() =>
      _FinalorderconfirmScreenState();
}

class _FinalorderconfirmScreenState
    extends State<FinalVendororderconfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // allow background to show
      body: Stack(
        children: [
          // 🔹 Dim background to dull previous screen
          Container(color: Colors.black.withOpacity(0.5)),

          // 🔹 Glassmorphism card
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // curved edges
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // blur effect
                child: Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // translucent
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4), // soft glass border
                      width: 2,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset('assets/images/tikorder.png'),

                      SizedBox(height: 15),
                      Text(
                        'Order Placed',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Row(
                          children: [
                            Text(
                              'Order No :',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              widget.orderid.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      Divider(color: Colors.white, thickness: 2),

                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      OrdersScreen(vendorId: widget.customer),
                            ),
                          );
                        },
                        child: Text(
                          'View Order',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
