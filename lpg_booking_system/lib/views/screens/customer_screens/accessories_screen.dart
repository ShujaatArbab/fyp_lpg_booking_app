import 'package:flutter/material.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';

class AccessoriesScreen extends StatefulWidget {
  final String cylindersize;
  final LoginResponse response;

  const AccessoriesScreen({
    super.key,
    required this.cylindersize,
    required this.response,
  });

  @override
  State<AccessoriesScreen> createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  // Accessories with selection and quantity
  Map<String, bool> accessorySelected = {
    'Cooking / Stove': false,
    'Heating / Water Heater': false,
    'Backup / Emergency Cylinder': false,
    'Outdoor Cooking / BBQ': false,
    'Gas Oven / Baking': false,
  };

  Map<String, int> accessoryQuantity = {
    'Cooking / Stove': 0,
    'Heating / Water Heater': 0,
    'Backup / Emergency Cylinder': 0,
    'Outdoor Cooking / BBQ': 0,
    'Gas Oven / Baking': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "For which purpose you are ordering ${widget.cylindersize} cylinder?",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Select purpose & quantity",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              children:
                  accessorySelected.keys.map((key) {
                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              value: accessorySelected[key],
                              onChanged: (value) {
                                setState(() {
                                  accessorySelected[key] = value!;
                                  if (!value) accessoryQuantity[key] = 0;
                                });
                              },
                              title: Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              activeColor: Colors.orange,
                            ),
                            if (accessorySelected[key] == true)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 28,
                                      ),
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          if (accessoryQuantity[key]! > 0) {
                                            accessoryQuantity[key] =
                                                accessoryQuantity[key]! - 1;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      accessoryQuantity[key].toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        size: 28,
                                      ),
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          accessoryQuantity[key] =
                                              accessoryQuantity[key]! + 1;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 15),
            child: ElevatedButton(
              onPressed: () {
                Map<String, int> selected = {};
                accessorySelected.forEach((key, isChecked) {
                  if (isChecked && accessoryQuantity[key]! > 0) {
                    selected[key] = accessoryQuantity[key]!;
                  }
                });

                if (selected.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least one purpose."),
                    ),
                  );
                  return;
                }

                Navigator.pop(context, selected); // Returns Map<String,int>
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                "Select",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
