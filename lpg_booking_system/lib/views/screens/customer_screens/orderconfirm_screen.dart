import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/placeorder_controller.dart';
import 'package:lpg_booking_system/controllers/stock_services_controller.dart';
import 'package:lpg_booking_system/global/tank_item.dart';
import 'package:lpg_booking_system/models/login_response.dart';
import 'package:lpg_booking_system/models/placeorder_request.dart';
import 'package:lpg_booking_system/views/screens/customer_screens/finalorderconfirm_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_cylindercard.dart';

class OrderconfirmationScreen extends StatefulWidget {
  final List<TankItem> selecteditem;
  final String vendorName;
  final String vendorAddress;
  final String vendorPhone;
  final String vendorcity;
  final LoginResponse customer;
  final String vendorId;

  const OrderconfirmationScreen({
    super.key,
    required this.selecteditem,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorPhone,
    required this.vendorId,
    required this.vendorcity,
    required this.customer,
  });

  @override
  State<OrderconfirmationScreen> createState() =>
      _OrderconfirmationScreenState();
}

class _OrderconfirmationScreenState extends State<OrderconfirmationScreen> {
  Map<String, int> stockMap = {};

  bool _isLoading = false;
  Future<void> _placeOrder() async {
    final buyerId = widget.customer.userid;
    if (widget.selecteditem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one cylinder")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final sellerId = widget.vendorId; // seller ID from previous screen
    final items = <OrderItemRequest>[];

    for (var c in widget.selecteditem) {
      final stockId = stockMap[c.size];
      if (stockId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Stock  not found for ${c.size}")),
        );
        setState(() => _isLoading = false);
        return;
      }
      items.add(OrderItemRequest(stockId: stockId, quantity: c.quantity));
    }

    // API returned Seller ID
    try {
      // Build request model
      final request = OrderRequest(
        buyerId: buyerId,
        sellerId: sellerId,
        city: widget.vendorcity,
        items:
            widget.selecteditem.map((c) {
              return OrderItemRequest(
                stockId: stockMap[c.size]!,
                quantity: c.quantity,
              );
            }).toList(),
      );

      // Call API
      final response = await OrderController().placeOrder(request);
      final orderId = response.orderId;
      // ✅ Success → Navigate to final order confirmation
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5), // dim background
        barrierDismissible: false,
        builder: (_) => FinalorderconfirmScreen(orderid: orderId),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to place order: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Map tank size to stock_id
  Future<void> loadStock(String vendorId) async {
    try {
      final map = await StockService.getStockMap(vendorId);
      setState(() {
        stockMap = map; // e.g. { "11kg": 10, "15kg": 1017, "45kg": 1019 }
      });
    } catch (e) {
      print("Error loading stock: $e");
    }
  }

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
  void initState() {
    super.initState();
    loadStock(widget.vendorId);
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
                          Expanded(child: Text(widget.vendorAddress)),
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
                          Text(widget.customer.city),
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
                      'Location :  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(widget.vendorcity),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Phone :  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(widget.vendorPhone),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 90),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: stockMap.isEmpty ? null : _placeOrder,

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
