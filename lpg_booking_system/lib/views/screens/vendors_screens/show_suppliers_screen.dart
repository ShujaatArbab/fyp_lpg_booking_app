import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/show_suppliers_controller.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_request.dart';
import 'package:lpg_booking_system/models/vendors_models/show_supplier_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_card.dart';

class ShowSupplierScreen extends StatefulWidget {
  final LoginResponse vendor;

  const ShowSupplierScreen({super.key, required this.vendor});

  @override
  State<ShowSupplierScreen> createState() => _ShowSupplierScreenState();
}

class _ShowSupplierScreenState extends State<ShowSupplierScreen> {
  List<SupplierResponse> supplierList = [];
  bool isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  //! fetch suppliers API call
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
          if (index == 2) {
            // 👈 assuming "My Orders" tab is at index 1
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OrdersScreen(
                      // ✅ replace with your screen
                      vendorId:
                          widget.vendor.userid, // or vendor/customer depending
                    ),
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
                "Suppliers",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          //! supplier list
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
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
                                // extract stock safely
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
                                    // TODO: vendor → supplier order screen navigation
                                    print("Order placed with ${supplier.name}");
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
