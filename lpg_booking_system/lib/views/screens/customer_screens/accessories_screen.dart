import 'package:flutter/material.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';

class AccessoriesScreen extends StatefulWidget {
  final String cylindersize;
  final LoginResponse response; // Logged-in user ID

  const AccessoriesScreen({
    super.key,
    required this.cylindersize,
    required this.response,
  });

  @override
  State<AccessoriesScreen> createState() => _AccessoriesScreenState();
}

Map<String, bool> accessories = {
  'Cooking / Stove': false,
  'Heating / Water Heater': false,
  'Backup / Emergency Cylinder': false,
  'Outdoor Cooking / BBQ': false,
  'Gas Oven / Baking': false,
};

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accessories',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10),
            child: Text(
              'For which purpose you are ordering ${widget.cylindersize} cylinder',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Select Purpose',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children:
                accessories.keys.map((key) {
                  return Row(
                    children: [
                      Checkbox(
                        value: accessories[key],
                        onChanged: (bool? value) {
                          setState(() {
                            accessories[key] = value!;
                          });
                        },
                      ),
                      Text(key),
                      const SizedBox(width: 10),
                    ],
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Collect selected purposes
              List<String> selectedPurposes =
                  accessories.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

              if (selectedPurposes.isEmpty) {
                // Show error if nothing selected
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select at least one purpose.'),
                  ),
                );
                return;
              }

              // Return selected purposes to previous screen
              Navigator.pop(context, selectedPurposes);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text(
              'Select',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
