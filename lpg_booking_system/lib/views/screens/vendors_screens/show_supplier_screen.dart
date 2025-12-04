import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/notifications_controller.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/show_suppliers_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_request.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/add_deliveryperson_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/add_shop_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/ven_place_order_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/vendor_dashboard_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/notifications_screen.dart'; // import notifications screen
import 'package:lpg_booking_system/views/screens/vendors_screens/vendor_profile.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_card.dart';

class Showsupplierscreen extends StatefulWidget {
  final LoginResponse vendor;
  const Showsupplierscreen({super.key, required this.vendor});

  @override
  State<Showsupplierscreen> createState() => _ShowsupplierscreenState();
}

class _ShowsupplierscreenState extends State<Showsupplierscreen> {
  int selectedIndex = 0;
  bool isLoading = true;
  List<SupplierResponse> supplierList = [];
  int unreadCount = 0; // ⭐ unread notification count

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
    fetchUnreadNotifications();
  }

  //! fetch unread notifications for this vendor
  Future<void> fetchUnreadNotifications() async {
    try {
      final count = await NotificationController().fetchUnreadCount(
        widget.vendor.userid,
      );
      setState(() {
        unreadCount = count;
      });
    } catch (e) {
      print('❌ Error fetching unread count: $e');
    }
  }

  //! fetch suppliers API
  Future<void> fetchSuppliers() async {
    try {
      final response = await SupplierController().getSuppliersByCity(
        SupplierRequest(city: widget.vendor.city, role: "ven"),
      );

      setState(() {
        supplierList = response;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
                builder:
                    (context) => VendorDashboardScreen(vendor: widget.vendor),
              ),
            );
          }
          if (index == 1) return;
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersScreen(vendorId: widget.vendor),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VendorProfileScreen(profile: widget.vendor),
              ),
            );
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! Top Header
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.orangeAccent,
            padding: const EdgeInsets.only(left: 30, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      margin: const EdgeInsets.only(right: 10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 40, // ensure enough height
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () async {
                                // open notifications screen
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => NotificationsScreen(
                                          customer:
                                              widget.vendor, // vendor as user
                                        ),
                                  ),
                                );
                                // refresh unread count after returning
                                await fetchUnreadNotifications();
                              },
                            ),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
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
                Text(
                  'UserID: ${widget.vendor.userid}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          //! Region + Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: const EdgeInsets.only(top: 10),
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
                Row(
                  children: [
                    //! Add Shop
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
                        width: 60,
                        height: 50,
                        margin: const EdgeInsets.only(right: 10),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_business,
                                size: 22,
                                color: Colors.red,
                              ),
                              Text(
                                'Add Shop',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //! Add Delivery Person
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
                      child: SizedBox(
                        width: 60,
                        height: 50,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.person_add,
                                size: 22,
                                color: Colors.red,
                              ),
                              Text(
                                'Person',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          //! Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Center(
              child: Text(
                "Suppliers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          //! Supplier List
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount:
                          supplierList.where((s) => s.plants.isNotEmpty).length,
                      itemBuilder: (context, index) {
                        final suppliersWithPlants =
                            supplierList
                                .where((s) => s.plants.isNotEmpty)
                                .toList();
                        final supplier = suppliersWithPlants[index];

                        return Column(
                          children:
                              supplier.plants.map((plant) {
                                int smallQty =
                                    plant.stock
                                        .firstWhere(
                                          (s) => s.cylinderID == 1,
                                          orElse:
                                              () => Stock(
                                                stockID: 0,
                                                cylinderID: 1,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                int mediumQty =
                                    plant.stock
                                        .firstWhere(
                                          (s) => s.cylinderID == 2,
                                          orElse:
                                              () => Stock(
                                                stockID: 0,
                                                cylinderID: 2,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                int largeQty =
                                    plant.stock
                                        .firstWhere(
                                          (s) => s.cylinderID == 3,
                                          orElse:
                                              () => Stock(
                                                stockID: 0,
                                                cylinderID: 3,
                                                quantityAvailable: 0,
                                              ),
                                        )
                                        .quantityAvailable;

                                return CustomCard(
                                  title: supplier.name,
                                  location: 'Location: ${supplier.city}',
                                  phone: supplier.phone,
                                  rating: '4.5',
                                  shopName: plant.plantName,
                                  shopCity: plant.plantCity,
                                  smallQty: smallQty,
                                  mediumQty: mediumQty,
                                  largeQty: largeQty,
                                  onplaceorder: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => VendorPlaceorderScreen(
                                              supplierId: supplier.userID,
                                              supplierName: supplier.name,
                                              supplierPhone: supplier.phone,
                                              supplierAddress: supplier.city,
                                              supplierCity: supplier.city,
                                              vendor: widget.vendor,
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
