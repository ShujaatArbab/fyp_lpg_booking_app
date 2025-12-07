import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title; // Vendor name
  final String location; // Vendor city
  final String phone;
  final String rating;
  final String shopName; // Shop name
  final String shopCity; // Shop city
  final int smallQty; // Available small cylinders
  final int mediumQty; // Available medium cylinders
  final int largeQty; // Available large cylinders
  final double smallPrice; // Small cylinder price
  final double mediumPrice; // Medium cylinder price
  final double largePrice; // Large cylinder price
  final VoidCallback onplaceorder;

  const CustomCard({
    super.key,
    required this.title,
    required this.location,
    required this.phone,
    required this.rating,
    required this.shopName,
    required this.shopCity,
    required this.smallQty,
    required this.mediumQty,
    required this.largeQty,
    required this.smallPrice,
    required this.mediumPrice,
    required this.largePrice,
    required this.onplaceorder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top row: Vendor Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Shop details
            Text(
              "Shop: $shopName",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              "City: $shopCity",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            /// Cylinder availability with prices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCylinderInfo("Small", smallQty, smallPrice),
                _buildCylinderInfo("Medium", mediumQty, mediumPrice),
                _buildCylinderInfo("Large", largeQty, largePrice),
              ],
            ),

            const SizedBox(height: 12),

            /// Bottom row: Phone + rating + button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.orange, width: 2),
                  ),
                  onPressed: onplaceorder,
                  child: const Text(
                    "Place Order",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
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

  /// Helper widget for cylinder info with price
  Widget _buildCylinderInfo(String label, int qty, double price) {
    return Column(
      children: [
        Text(
          "$qty",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          "\Rs ${price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 244, 16, 0),
          ),
        ),
      ],
    );
  }
}
