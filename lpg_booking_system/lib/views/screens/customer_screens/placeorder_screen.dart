import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/orderconfirm_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

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
  int selectedIndex = 0;
  int quantity = 1;

  List<TankItem> selecteditem = [];

  final Map<String, int> tankprices = {
    '11kg': 2780,
    '15kg': 3720,
    '45kg': 11160,
  };

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void deletecard(int index) {
    setState(() {
      selecteditem.removeAt(index);
    });
  }

  void addCylinder() {
    if (selectedsize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a tank size.')),
      );
      return;
    }

    // ✅ Stock limit validation
    int availableQty = 0;
    if (selectedsize == '11kg') availableQty = widget.smallQty;
    if (selectedsize == '15kg') availableQty = widget.mediumQty;
    if (selectedsize == '45kg') availableQty = widget.largeQty;

    if (availableQty == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No stock available for $selectedsize cylinders.'),
        ),
      );
      return;
    }

    final existingIndex = selecteditem.indexWhere(
      (item) => item.size == selectedsize,
    );

    if (existingIndex != -1) {
      final currentQty = selecteditem[existingIndex].quantity;
      if (currentQty + quantity > availableQty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only $availableQty cylinders available for $selectedsize.',
            ),
          ),
        );
        return;
      }
      setState(() {
        selecteditem[existingIndex].quantity += quantity;
      });
    } else {
      if (quantity > availableQty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only $availableQty cylinders available for $selectedsize.',
            ),
          ),
        );
        return;
      }
      setState(() {
        selecteditem.add(
          TankItem(
            size: selectedsize!,
            price: tankprices[selectedsize]!,
            quantity: quantity,
          ),
        );
      });
    }

    setState(() {
      selectedsize = null;
      quantity = 1;
    });
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
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ShowVendorScreen(customer: widget.customer),
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
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //! Vendor Info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(10),
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

              //! Tank Selection
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tank Size:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _buildTankButton('11kg', 'Rs 2780', widget.smallQty),
                  _buildTankButton('15kg', 'Rs 3720', widget.mediumQty),
                  _buildTankButton('45kg', 'Rs 11,160', widget.largeQty),
                ],
              ),

              const SizedBox(height: 20),

              //! Quantity Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quantity:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    height: 55,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: increment,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addCylinder,
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange, width: 2),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add Cylinder',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              //! Order List
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Order:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 200,
                child:
                    selecteditem.isEmpty
                        ? const Center(child: Text("No cylinders added yet."))
                        : ListView.builder(
                          itemCount: selecteditem.length,
                          itemBuilder: (context, index) {
                            final cylinder = selecteditem[index];
                            return CustomCylinderCard(
                              size: cylinder.size,
                              price: cylinder.price,
                              quantity: cylinder.quantity,
                              onDelete: () => deletecard(index),
                              extraWidget: null,
                            );
                          },
                        ),
              ),
              const SizedBox(height: 20),

              //! Proceed Button
              CustomButton(
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

  Widget _buildTankButton(String size, String price, int available) {
    final bool isSelected = selectedsize == size;
    return ElevatedButton(
      onPressed:
          available > 0
              ? () {
                setState(() {
                  selectedsize = size;
                });
              }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.white,
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      child: Column(
        children: [
          Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
          Text(
            'Stock: $available',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
