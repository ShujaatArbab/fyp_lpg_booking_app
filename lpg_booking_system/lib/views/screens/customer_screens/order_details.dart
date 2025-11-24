import 'package:flutter/material.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/complaint_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';

class CustomerOrderDetails extends StatefulWidget {
  final int orderid;
  final List<TankItem> selecteditem;
  final String vendorName;
  final String vendorAddress;
  final String vendorPhone;
  final String vendorCity;
  final LoginResponse customer;
  final String vendorId;

  const CustomerOrderDetails({
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
  State<CustomerOrderDetails> createState() => _OrderDetailsState();
}

int selectedIndex = 0;

class _OrderDetailsState extends State<CustomerOrderDetails> {
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

      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor Info
            SizedBox(
              width: 500,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vendorName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(widget.vendorAddress),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Total Items
            Text(
              'Total Items (${widget.selecteditem.length.toString().padLeft(2, '0')})',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),

            // Ordered Cylinders
            ...widget.selecteditem.map((item) {
              IconData iconData;
              Color iconColor;

              String getWeight(String size) {
                switch (size.toLowerCase()) {
                  case 'small':
                    return '11';
                  case 'medium':
                    return '15';
                  case 'large':
                    return '45';
                  default:
                    return '';
                }
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red, width: 2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: Icon(
                    Icons.local_fire_department, // or choose icon based on size
                    color: Colors.red,
                    size: 40,
                  ),
                  title: Text('Cylinder ${item.size} ${getWeight(item.size)} '),
                  subtitle: Text('RS ${item.price}'),
                  trailing: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('${item.quantity}'),
                  ),
                ),
              );
            }),

            SizedBox(height: 20),

            // Order Details
            Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    'Order ID: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.orderid.toString()),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    'Seller Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.vendorName),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    'Buyer Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.customer.name),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    'Vendor CIty: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.vendorCity),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text(
                    'Vendor Phone: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.vendorPhone),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ComplaintScreen(
                              orderid: widget.orderid,
                              vendorname: widget.vendorName,
                              customer: widget.customer,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),

                  child: Text(
                    'Complaint',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
