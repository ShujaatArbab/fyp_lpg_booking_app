import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/orderconfirm_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

// class TankItem {
//   final String size;
//   final int price;
//   int quantity;

//   TankItem({required this.price, required this.quantity, required this.size});
// }

class PlaceorderScreen extends StatefulWidget {
  final String vendorId;
  final String vendorName;
  final String vendorPhone; // ✅ add this
  final String vendorAddress;
  final String vendorcity;
  final LoginResponse customer;

  const PlaceorderScreen({
    super.key,
    required this.vendorName,
    required this.vendorId,
    required this.vendorPhone, // ✅ add here
    required this.vendorAddress,
    required this.vendorcity,
    required this.customer,
  });

  @override
  State<PlaceorderScreen> createState() => _PlaceorderScreenState();
}

class _PlaceorderScreenState extends State<PlaceorderScreen> {
  final List<String> tanksize = ['11kg', '15kg', '45kg'];
  String? selectedsize;
  int selectedIndex = 0;
  int quantity = 1;

  //! List
  List<TankItem> selecteditem = [];
  final Map<String, int> tankprices = {
    '11kg': 2780,
    '15kg': 3720,
    '45kg': 11160,
  };

  //! funtions  selectedsize
  void selectSize(String size) {
    setState(() {
      selectedsize = size;
      quantity = 1;
    });
  }

  //! funtions  increment
  void increment() {
    setState(() {
      quantity++;
    });
  }

  //! funtions  decrement
  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  //!  funtions deleteicon
  void deletecard(int index) {
    setState(() {
      selecteditem.removeAt(index);
    });
  }

  void addCylinder() {
    if (selectedsize == null) return;

    final existingIndex = selecteditem.indexWhere(
      (item) => item.size == selectedsize,
    );
    if (existingIndex != -1) {
      setState(() {
        selecteditem[existingIndex].quantity += quantity;
      });
    } else {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ShowVendorScreen(
                      customer: widget.customer,
                    ), // 👈 change screen here
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
        decoration: BoxDecoration(color: Colors.white),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Vendor Id : ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.vendorId,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Text(
                          'Vendor Name : ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.vendorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Row(
                  children: [
                    Text(
                      'Tank Size:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // 11kg
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedsize = '11kg';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedsize == '11kg'
                                ? Colors.orange
                                : Colors.white,
                        side: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '11 Kg',
                            style: TextStyle(
                              color:
                                  selectedsize == '11kg'
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs 2728',
                            style: TextStyle(
                              color:
                                  selectedsize == '11kg'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 15kg
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedsize = '15kg';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedsize == '15kg'
                                ? Colors.orange
                                : Colors.white,
                        side: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '15 Kg',
                            style: TextStyle(
                              color:
                                  selectedsize == '15kg'
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs 3720',
                            style: TextStyle(
                              color:
                                  selectedsize == '15kg'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 45kg
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedsize = '45kg';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedsize == '45kg'
                                ? Colors.orange
                                : Colors.white,
                        side: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '45 Kg',
                            style: TextStyle(
                              color:
                                  selectedsize == '45kg'
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs 11,160',
                            style: TextStyle(
                              color:
                                  selectedsize == '45kg'
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //! Quantity Label
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Row(
                  children: [
                    Text(
                      'Quantity:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              //! Quantity input
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
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
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove),
                          iconSize: 25,
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
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add),
                          iconSize: 25,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 75),

                  // !Add Cylinder Button
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: (addCylinder),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.orange, width: 2),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Add cylinder',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Order List
              Row(
                children: const [
                  Text(
                    "Your Order:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //! Use ListView inside fixed height
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
                              // 👈 passed to the card
                            );
                          },
                        ),
              ),
              SizedBox(height: 20),

              CustomButton(
                text: 'Proceed',
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => OrderconfirmationScreen(
                            selecteditem: selecteditem, // ✅ your chosen items

                            vendorName:
                                widget.vendorName, // ✅ use widget.vendorName
                            vendorPhone:
                                widget.vendorPhone, // ✅ use widget.vendorPhone
                            vendorAddress: widget.vendorAddress,
                            vendorcity: widget.vendorcity,
                            customer:
                                widget.customer, // pass customer (buyer) object
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
}
