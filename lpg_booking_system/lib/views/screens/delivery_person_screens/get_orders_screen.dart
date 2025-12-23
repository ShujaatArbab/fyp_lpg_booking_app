import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lpg_booking_system/controllers/delivery_person_controller/get_orders_controller.dart';
import 'package:lpg_booking_system/controllers/delivery_person_controller/order_track_controller.dart';
import 'package:lpg_booking_system/models/delivery_person_models/deliver_person_login_response.dart';
import 'package:lpg_booking_system/models/delivery_person_models/get_orders_response.dart';
import 'package:lpg_booking_system/models/delivery_person_models/track_order_request.dart';

class DeliveryOrdersScreen extends StatefulWidget {
  final DeliveryLoginResponse response;

  const DeliveryOrdersScreen({Key? key, required this.response})
    : super(key: key);

  @override
  _DeliveryOrdersScreenState createState() => _DeliveryOrdersScreenState();
}

class _DeliveryOrdersScreenState extends State<DeliveryOrdersScreen> {
  late Future<List<DeliveryOrderResponse>> _ordersFuture;
  final DeliveryOrderController _controller = DeliveryOrderController();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _controller.getDeliveryOrders(widget.response.dpName);
  }

  void _openMapAndSelectLocation(int orderId, String deliveryPersonName) {
    LatLng? selectedLocation;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(33.64098, 73.07782),
                      zoom: 14,
                    ),
                    onTap: (LatLng location) {
                      setModalState(() {
                        selectedLocation = location;
                      });
                    },
                    markers:
                        selectedLocation == null
                            ? {}
                            : {
                              Marker(
                                markerId: const MarkerId("selected"),
                                position: selectedLocation!,
                              ),
                            },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                  ),

                  if (selectedLocation != null)
                    Positioned(
                      bottom: 20,
                      left: 50,
                      right: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () async {
                          if (selectedLocation == null) return;

                          final model = OrderTrackingRequest(
                            orderId: orderId,
                            deliveryPersonName: deliveryPersonName,
                            latitude: selectedLocation!.latitude,
                            longitude: selectedLocation!.longitude,
                          );

                          bool success =
                              await OrderTrackingService.saveLocation(model);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Location saved successfully"),
                              ),
                            );
                            Navigator.pop(context); // close modal
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Failed to save location"),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Save Location",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Delivery person info card
          Container(
            width: double.infinity,
            height: 145,
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.orange, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Delivery Person Information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          "Name : ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.response.dpName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Phone : ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.response.dpPhone,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Vendor ID : ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.response.vendorId,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Orders list
          Expanded(
            child: FutureBuilder<List<DeliveryOrderResponse>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No orders assigned"));
                }

                final orders = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${order.orderId}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Customer: ${order.customerName}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Vendor: ${order.vendorName}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  _openMapAndSelectLocation(
                                    order.orderId,
                                    widget.response.dpName,
                                  );
                                },
                                child: const Text(
                                  "Start",
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
