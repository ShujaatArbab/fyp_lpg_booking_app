import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/showvendor_controller.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/models/showvendor_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/placeorder_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_card.dart';

class ShowVendorScreen extends StatefulWidget {
  final LoginResponse customer;

  const ShowVendorScreen({super.key, required this.customer});

  @override
  State<ShowVendorScreen> createState() => _ShowVendorScreenState();
}

class _ShowVendorScreenState extends State<ShowVendorScreen> {
  int selectedIndex = 0;
  List<VendorResponse> vendorList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  //! fetch vendor API call
  Future<void> fetchVendors() async {
    try {
      final response = await VendorController().fetchVendorsByCity(
        widget.customer.city,
        "cust",
      );

      setState(() {
        vendorList = response;
        isLoading = false; // ✅ stop loader
      });
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! bottom navbar
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
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
                        widget.customer.name,
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
                        'UserID: ${widget.customer.userid}',
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
                      widget.customer.city,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_alt,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              child: const Text(
                "Vendors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          //! card list
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      // ✅ only vendors with shops will be shown
                      itemCount:
                          vendorList.where((v) => v.shops.isNotEmpty).length,
                      itemBuilder: (context, index) {
                        final vendorsWithShops =
                            vendorList
                                .where((v) => v.shops.isNotEmpty)
                                .toList();
                        final vendor = vendorsWithShops[index];

                        // ✅ show all shops for this vendor
                        return Column(
                          children:
                              vendor.shops.map((shop) {
                                // extract stock safely
                                int smallQty =
                                    shop.stock
                                        .firstWhere(
                                          (s) => s.cylinderId == 1,
                                          orElse:
                                              () => Stock(
                                                stockId: 0,
                                                cylinderId: 1,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                int mediumQty =
                                    shop.stock
                                        .firstWhere(
                                          (s) => s.cylinderId == 2,
                                          orElse:
                                              () => Stock(
                                                stockId: 0,
                                                cylinderId: 2,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                int largeQty =
                                    shop.stock
                                        .firstWhere(
                                          (s) => s.cylinderId == 3,
                                          orElse:
                                              () => Stock(
                                                stockId: 0,
                                                cylinderId: 3,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                return CustomCard(
                                  title: vendor.name,
                                  location: 'Location: ${vendor.city}',
                                  phone: vendor.phone,
                                  rating: '4.0',
                                  shopName: shop.shopName,
                                  shopCity: shop.city,
                                  smallQty: smallQty,
                                  mediumQty: mediumQty,
                                  largeQty: largeQty,
                                  onplaceorder: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PlaceorderScreen(
                                              vendorId: vendor.userID,
                                              vendorName: vendor.name,
                                              vendorPhone: vendor.phone,
                                              vendorAddress:
                                                  "${shop.shopName}, ${shop.city}",
                                              vendorcity: vendor.city,
                                              customer: widget.customer,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
