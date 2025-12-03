import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/order_details_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/order_details_response.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/complaint_screen.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/showvendor_screen.dart';
import 'package:lpg_booking_system/widgets/customer_navbar.dart';

class CustomerOrderDetails extends StatefulWidget {
  final int orderId;
  final LoginResponse customer;

  const CustomerOrderDetails({
    super.key,
    required this.orderId,
    required this.customer,
  });

  @override
  State<CustomerOrderDetails> createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  final OrderDetailsController controller = OrderDetailsController();
  OrderDetailsResponse? orderDetails;
  bool isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    setState(() => isLoading = true);
    final response = await controller.fetchOrderDetails(widget.orderId);
    if (response != null) {
      setState(() {
        orderDetails = response;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load order details")));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() => selectedIndex = index);
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
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
              : orderDetails == null
              ? const Center(child: Text("No order details found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    orderDetails!.seller.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),
                              Row(children: [Text(orderDetails!.seller.city)]),
                              const SizedBox(height: 5),
                              Row(children: [Text(orderDetails!.seller.phone)]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Total Items
                    Text(
                      'Total Items (${orderDetails!.items.length.toString().padLeft(2, '0')})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Ordered Items
                    ...orderDetails!.items.map((item) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red, width: 2),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                              size: 40,
                            ),
                            title: Text(
                              item.cylinderType, // Small / Medium / Large
                            ),
                            subtitle: Text('Quantity: ${item.quantity}'),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Order Details Info
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildInfoRow('Order ID', orderDetails!.orderId.toString()),
                    _buildInfoRow('Buyer Name', orderDetails!.buyer.name),
                    _buildInfoRow('Seller Name', orderDetails!.seller.name),
                    _buildInfoRow('Vendor City', orderDetails!.seller.city),
                    _buildInfoRow('Vendor Phone', orderDetails!.seller.phone),
                    const SizedBox(height: 30),

                    // Complaint Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ComplaintScreen(
                                    orderid: orderDetails!.orderId,
                                    vendorname: orderDetails!.seller.name,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Complaint',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(left: 30, bottom: 5),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
