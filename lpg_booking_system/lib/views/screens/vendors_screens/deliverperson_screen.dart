import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/deliveryperson_controller.dart';

import 'package:lpg_booking_system/models/vendororders_response.dart';
import 'package:lpg_booking_system/models/vendors_models/deliveryperson_response.dart';

class DeliveryPersonListScreen extends StatefulWidget {
  final String vendorId;

  const DeliveryPersonListScreen({
    super.key,
    required this.vendorId,
    required Order order,
  });

  @override
  State<DeliveryPersonListScreen> createState() =>
      _DeliveryPersonListScreenState();
}

class _DeliveryPersonListScreenState extends State<DeliveryPersonListScreen> {
  late Future<List<DeliveryPerson>> futureDeliveryPersons;
  int? selectedDpId;

  @override
  void initState() {
    super.initState();
    futureDeliveryPersons = DeliveryPersonService.getDeliveryPersons(
      widget.vendorId,
    );
  }

  void _selectDeliveryPerson(DeliveryPerson dp) {
    setState(() {
      selectedDpId = dp.dpId;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${dp.name} selected")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery Persons",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<DeliveryPerson>>(
        future: futureDeliveryPersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No delivery persons found"));
          }

          final deliveryPersons = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ListView.builder(
              itemCount: deliveryPersons.length,
              itemBuilder: (context, index) {
                final dp = deliveryPersons[index];
                final isSelected = selectedDpId == dp.dpId;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? Colors.orange : Colors.black12,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Name & Phone
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dp.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(dp.phone),
                            ],
                          ),
                        ),
                        // Select button
                        ElevatedButton(
                          onPressed:
                              dp.isAvailable
                                  ? () => _selectDeliveryPerson(dp)
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dp.isAvailable ? Colors.orange : Colors.grey,
                          ),
                          child: const Text(
                            "Select",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
