import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/notifications_controller.dart';
import 'package:lpg_booking_system/controllers/customer_controller/showvendor_conroller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/showvendor_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/my_orders_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/notifications_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/placeorder_screen.dart';
import 'package:lpg_booking_system/views/screens/profile_screen.dart';
import 'package:lpg_booking_system/widgets/custom_card.dart';
import 'package:lpg_booking_system/widgets/customer_navbar.dart';

class ShowVendorScreen extends StatefulWidget {
  final LoginResponse customer;

  const ShowVendorScreen({super.key, required this.customer});

  @override
  State<ShowVendorScreen> createState() => _ShowVendorScreenState();
}

class _ShowVendorScreenState extends State<ShowVendorScreen> {
  int selectedIndex = 0;
  int unreadCount = 0;
  List<VendorResponse> vendorList = [];
  List<VendorResponse> filteredVendorList = [];
  bool isLoading = true;
  double selectedRating = 0; // ⭐ selected rating for filter

  @override
  void initState() {
    super.initState();
    fetchVendors();
    fetchUnreadNotifications();
  }

  //! fetch unread notification
  Future<void> fetchUnreadNotifications() async {
    try {
      final count = await NotificationController().fetchUnreadCount(
        widget.customer.userid,
      );
      setState(() {
        unreadCount = count;
      });
    } catch (e) {
      print('❌ Error fetching unread count: $e');
    }
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
        filteredVendorList = List.from(vendorList);
        isLoading = false; // ✅ stop loader
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  //! ⭐ show filter bottom sheet
  void showRatingFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double tempSelectedRating =
            selectedRating; // local temp for bottom sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter by Rating",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Rating:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        int star = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedRating = star.toDouble();
                            });
                          },
                          child: Icon(
                            Icons.star,
                            size: 40,
                            color:
                                (tempSelectedRating >= star)
                                    ? Colors.orange
                                    : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = tempSelectedRating;
                          // sort vendors by nearest rating
                          filteredVendorList = List.from(vendorList);
                          if (selectedRating > 0) {
                            filteredVendorList.sort((a, b) {
                              double diffA =
                                  (a.averageRating - selectedRating).abs();
                              double diffB =
                                  (b.averageRating - selectedRating).abs();
                              return diffA.compareTo(diffB);
                            });
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! bottom navbar
      bottomNavigationBar: CustomerNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
          if (index == 0) return;
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyOrdersScreen(buyerId: widget.customer),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(profile: widget.customer),
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
            color: Colors.orangeAccent,
            padding: const EdgeInsets.only(
              left: 30,
              top: 30,
              bottom: 15,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                      margin: const EdgeInsets.only(right: 10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => NotificationsScreen(
                                        customer: widget.customer,
                                      ),
                                ),
                              );
                              await fetchUnreadNotifications();
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
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

          //! region & filter
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
                  onPressed: showRatingFilterSheet, // ⭐ Added filter
                  icon: const Icon(
                    Icons.filter_alt,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              "Vendors",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          //! vendor card list
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount:
                          filteredVendorList
                              .where((v) => v.shops.isNotEmpty)
                              .length,
                      itemBuilder: (context, index) {
                        final vendorsWithShops =
                            filteredVendorList
                                .where((v) => v.shops.isNotEmpty)
                                .toList();
                        final vendor = vendorsWithShops[index];

                        return Column(
                          children:
                              vendor.shops.map((shop) {
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
                                  rating: vendor.averageRating.toStringAsFixed(
                                    1,
                                  ),
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
                                              smallQty: smallQty,
                                              mediumQty: mediumQty,
                                              largeQty: largeQty,
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
