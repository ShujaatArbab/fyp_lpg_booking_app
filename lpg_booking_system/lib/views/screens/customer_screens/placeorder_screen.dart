import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/accessories_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/my_orders_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/orderconfirm_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/views/screens/profile_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';
import 'package:lpg_booking_system/widgets/customer_navbar.dart';

class PlaceorderScreen extends StatefulWidget {
  final int smallQty;
  final int mediumQty;
  final int largeQty;
  final String vendorId;
  final String vendorName;
  final String vendorPhone;
  final String vendorAddress;
  final String vendorcity;
  final LoginResponse customer;

  const PlaceorderScreen({
    super.key,
    required this.vendorName,
    required this.vendorId,
    required this.vendorPhone,
    required this.vendorAddress,
    required this.vendorcity,
    required this.customer,
    required this.smallQty,
    required this.mediumQty,
    required this.largeQty,
  });

  @override
  State<PlaceorderScreen> createState() => _PlaceorderScreenState();
}

class _PlaceorderScreenState extends State<PlaceorderScreen> {
  final List<String> tanksize = ['11kg', '15kg', '45kg'];
  String? selectedsize;
  int quantity = 1;
  List<TankItem> selecteditem = [];

  final Map<String, int> tankprices = {
    '11kg': 2780,
    '15kg': 3720,
    '45kg': 11160,
  };

  void increment() => setState(() => quantity++);
  void decrement() {
    if (quantity > 1) setState(() => quantity--);
  }

  void deletecard(int index) {
    setState(() => selecteditem.removeAt(index));
  }

  Future<void> onTankClick(String size) async {
    setState(() {
      selectedsize = size;
    });

    // Navigate to AccessoriesScreen
    final selectedAccessories = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AccessoriesScreen(
              cylindersize: size,
              response: widget.customer,
            ),
      ),
    );

    if (selectedAccessories == null ||
        (selectedAccessories as Map<String, int>).isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No purposes selected.')));
      return;
    }

    final accessoriesMap = selectedAccessories as Map<String, int>;

    // Determine available quantity
    int availableQty = 0;
    if (size == '11kg') availableQty = widget.smallQty;
    if (size == '15kg') availableQty = widget.mediumQty;
    if (size == '45kg') availableQty = widget.largeQty;

    if (availableQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No stock available for $size cylinders.')),
      );
      return;
    }

    final existingIndex = selecteditem.indexWhere((item) => item.size == size);
    if (existingIndex != -1) {
      final currentQty = selecteditem[existingIndex].quantity;
      if (currentQty + quantity > availableQty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Only $availableQty cylinders available for $size.'),
          ),
        );
        return;
      }
      setState(() {
        selecteditem[existingIndex].quantity += quantity;
        selecteditem[existingIndex].accessories =
            accessoriesMap.entries.map((e) => "${e.key} x${e.value}").toList();
      });
    } else {
      setState(() {
        selecteditem.add(
          TankItem(
            size: size,
            price: tankprices[size]!,
            quantity: quantity,
            accessories:
                accessoriesMap.entries
                    .map((e) => "${e.key} x${e.value}")
                    .toList(),
          ),
        );
      });
    }

    // Reset quantity and selection
    setState(() {
      selectedsize = null;
      quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerNavbar(
        currentindex: 0,
        ontap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ShowVendorScreen(customer: widget.customer),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        MyOrdersScreen(buyerId: widget.customer.userid),
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
      appBar: AppBar(
        title: const Text(
          'Place Order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor Info at top
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('Vendor ID', widget.vendorId),
                    _infoRow('Vendor Name', widget.vendorName),
                    _infoRow('Phone', widget.vendorPhone),
                    _infoRow('Address', widget.vendorAddress),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cylinder Quantity Selector
              const Text(
                'Select Cylinder Quantity:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: increment,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tank Selection Buttons
              const Text(
                'Select Cylinder:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children:
                    tanksize.map((size) {
                      int available =
                          (size == '11kg')
                              ? widget.smallQty
                              : (size == '15kg')
                              ? widget.mediumQty
                              : widget.largeQty;

                      return ElevatedButton(
                        onPressed:
                            available > 0 ? () => onTankClick(size) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedsize == size
                                  ? Colors.orange
                                  : Colors.white,
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              size,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    selectedsize == size
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            Text(
                              'Rs ${tankprices[size]}',
                              style: TextStyle(
                                color:
                                    selectedsize == size
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            Text(
                              'Stock: $available',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    selectedsize == size
                                        ? Colors.white
                                        : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Selected Cylinders List
              const Text(
                "Your Order:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              selecteditem.isEmpty
                  ? const Text("No cylinders added yet.")
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selecteditem.length,
                    itemBuilder: (context, index) {
                      final cylinder = selecteditem[index];
                      return CustomCylinderCard(
                        size: cylinder.size,
                        price: cylinder.price,
                        quantity: cylinder.quantity,
                        onDelete: () => deletecard(index),
                        extraWidget:
                            cylinder.accessories != null
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      cylinder.accessories!
                                          .map(
                                            (acc) => Text(
                                              acc,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                )
                                : null,
                      );
                    },
                  ),
              const SizedBox(height: 20),

              // Proceed Button
              Center(
                child: CustomButton(
                  text: 'Proceed',
                  onpressed: () {
                    if (selecteditem.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add at least one cylinder.'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => OrderconfirmationScreen(
                              selecteditem: selecteditem,
                              vendorName: widget.vendorName,
                              vendorPhone: widget.vendorPhone,
                              vendorAddress: widget.vendorAddress,
                              vendorcity: widget.vendorcity,
                              customer: widget.customer,
                              vendorId: widget.vendorId,
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
