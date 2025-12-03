import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/orders.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/ven_orderconfirm_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/vendor_dashboard_screen.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/vendor_profile.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

class VendorPlaceorderScreen extends StatefulWidget {
  final String supplierId;
  final String supplierName;
  final String supplierPhone;
  final String supplierAddress;
  final String supplierCity;
  final LoginResponse vendor;
  final int smallQty; // 11kg stock
  final int mediumQty; // 15kg stock
  final int largeQty; // 45kg stock

  const VendorPlaceorderScreen({
    super.key,
    required this.supplierId,
    required this.supplierName,
    required this.supplierPhone,
    required this.supplierAddress,
    required this.supplierCity,
    required this.vendor,
    required this.smallQty,
    required this.mediumQty,
    required this.largeQty,
  });

  @override
  State<VendorPlaceorderScreen> createState() => _VendorPlaceorderScreenState();
}

class _VendorPlaceorderScreenState extends State<VendorPlaceorderScreen> {
  String? selectedSize;
  int quantity = 1;
  int selectedIndex = 0;
  List<TankItem> selectedItems = [];

  final Map<String, int> tankPrices = {
    '11kg': 2780,
    '15kg': 3720,
    '45kg': 11160,
  };

  int getStock(String size) {
    switch (size) {
      case '11kg':
        return widget.smallQty;
      case '15kg':
        return widget.mediumQty;
      case '45kg':
        return widget.largeQty;
      default:
        return 0;
    }
  }

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
      quantity = 1;
    });
  }

  void increment() {
    if (selectedSize != null && quantity < getStock(selectedSize!)) {
      setState(() {
        quantity++;
      });
    }
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void deleteCard(int index) {
    setState(() {
      selectedItems.removeAt(index);
    });
  }

  void addCylinder() {
    if (selectedSize == null) return;
    final stock = getStock(selectedSize!);
    if (quantity > stock || stock == 0) return;

    final existingIndex = selectedItems.indexWhere(
      (item) => item.size == selectedSize,
    );
    if (existingIndex != -1) {
      setState(() {
        selectedItems[existingIndex].quantity += quantity;
      });
    } else {
      setState(() {
        selectedItems.add(
          TankItem(
            size: selectedSize!,
            price: tankPrices[selectedSize!]!,
            quantity: quantity,
          ),
        );
      });
    }

    setState(() {
      selectedSize = null;
      quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VendorDashboardScreen(vendor: widget.vendor),
              ),
            );
          }
          if (index == 1) {
            return;
          }
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
      appBar: AppBar(
        title: const Text(
          'Place Order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Info
            Container(
              width: 800,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Supplier ID: ${widget.supplierId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Supplier Name: ${widget.supplierName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Phone: ${widget.supplierPhone}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'City: ${widget.supplierCity}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tank Size Selection
            const Text(
              'Tank Size:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                tankButton('11kg'),
                const SizedBox(width: 10),
                tankButton('15kg'),
                const SizedBox(width: 10),
                tankButton('45kg'),
              ],
            ),
            const SizedBox(height: 20),

            // Quantity Selection
            const Text(
              'Quantity:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: decrement,
                        icon: const Icon(Icons.remove),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: increment,
                        icon: const Icon(Icons.add),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  margin: EdgeInsets.only(left: 80),
                  child: ElevatedButton(
                    onPressed: addCylinder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Add Cylinder',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Selected Items List
            const Text(
              'Your Order:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Center(
              child:
                  selectedItems.isEmpty
                      ? const Text('No cylinders added yet.')
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedItems.length,
                        itemBuilder: (context, index) {
                          final item = selectedItems[index];
                          return CustomCylinderCard(
                            size: item.size,
                            price: item.price,
                            quantity: item.quantity,
                            onDelete: () => deleteCard(index),
                            extraWidget: null,
                          );
                        },
                      ),
            ),

            const SizedBox(height: 20),

            // Proceed Button
            Center(
              child: CustomButton(
                text: 'Proceed',
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VendorOrderConfirmationScreen(
                            selectedItems: selectedItems,
                            supplierName: widget.supplierName,
                            supplierPhone: widget.supplierPhone,
                            supplierAddress: widget.supplierAddress,
                            supplierCity: widget.supplierCity,
                            vendor: widget.vendor,
                            supplierId: widget.supplierId,
                          ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tankButton(String size) {
    final stock = getStock(size);
    return ElevatedButton(
      onPressed: stock > 0 ? () => selectSize(size) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSize == size ? Colors.orange : Colors.white,
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          Text(
            size,
            style: TextStyle(
              color: selectedSize == size ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Rs ${tankPrices[size]}',
            style: TextStyle(
              color: selectedSize == size ? Colors.white : Colors.black,
            ),
          ),
          Text(
            'Stock: $stock',
            style: TextStyle(
              color: selectedSize == size ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
