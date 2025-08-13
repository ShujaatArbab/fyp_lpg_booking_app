import 'package:flutter/material.dart';
import 'package:lpg_booking_system/views/screens/placeorder_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

class OrderconfirmationScreen extends StatefulWidget {
  final List<TankItem> selecteditem;

  const OrderconfirmationScreen({super.key, required this.selecteditem});

  @override
  State<OrderconfirmationScreen> createState() =>
      _OrderconfirmationScreenState();
}

class _OrderconfirmationScreenState extends State<OrderconfirmationScreen> {
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
  void selectSize(String size) {
    setState(() {
      selectedsize = size;
      quantity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //!bottom bar
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      //!  title appbar
      appBar: AppBar(
        title: Text(
          'Order Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            width: 500,
            height: 100,
            padding: EdgeInsets.only(left: 10, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            //!  vendor
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vendor address: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      //!  my address
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'My address: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //!  products
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Products: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 320,
            child: Expanded(
              child:
                  widget.selecteditem.isEmpty
                      ? Center(child: Text("No products added"))
                      : ListView.builder(
                        itemCount: widget.selecteditem.length,
                        itemBuilder: (context, index) {
                          final cylinder = widget.selecteditem[index];
                          return CustomCylinderCard(
                            size: cylinder.size,
                            price: cylinder.price,
                            quantity: cylinder.quantity,

                            onDelete: () {
                              // optional delete in confirmation
                              setState(() {
                                widget.selecteditem.removeAt(index);
                              });
                            },
                            extraWidget: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Schedule',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 50),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Phone:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 90),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text(
                          'Place Order',

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
