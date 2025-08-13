import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String location;
  final String phone;
  final String rating;
  final VoidCallback onplaceorder;

  const CustomCard({
    super.key,
    required this.title,
    required this.location,
    required this.phone,
    required this.rating,
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
                // Title + location
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

            /// Bottom row: Phone + rating + button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    side: BorderSide(color: Colors.orange, width: 2),
                    // backgroundColor: const Color.fromARGB(255, 255, 153, 0),
                  ),
                  onPressed: () {
                    onplaceorder();
                  },
                  child: Text(
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
}
