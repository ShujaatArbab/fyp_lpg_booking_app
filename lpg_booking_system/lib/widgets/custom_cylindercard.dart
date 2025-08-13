import 'package:flutter/material.dart';

class CustomCylinderCard extends StatelessWidget {
  final String size;
  final int price;
  final int quantity;
  final VoidCallback onDelete;
  final Widget? extraWidget;

  const CustomCylinderCard({
    super.key,
    required this.size,
    required this.price,
    required this.quantity,
    required this.onDelete,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    int tprice = price * quantity;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safe icon replacement
            const Icon(
              Icons.local_fire_department,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(width: 12),

            // Texts + button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$size Cylinder",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text("Rs $tprice", style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text(
                    "Quantity: $quantity",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (extraWidget != null) ...[
                    const SizedBox(height: 8),
                    extraWidget!,
                  ],
                ],
              ),
            ),

            // Delete button
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 228, 19, 4),
                size: 28,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
