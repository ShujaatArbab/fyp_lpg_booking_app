import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/rating_controller.dart';

import 'package:lpg_booking_system/models/customers_models/rating_request.dart';
import 'package:lpg_booking_system/models/customers_models/rating_response.dart';

class RatingScreen extends StatefulWidget {
  final int orderId;
  const RatingScreen({super.key, required this.orderId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 0;
  final RatingController ratingController = RatingController();

  void submitRating() async {
    final request = RatingRequest(
      orderId: widget.orderId,
      rating: selectedRating.toDouble(),
    );

    final result = await ratingController.submitRating(request);

    if (result == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rating submitted successfully")),
      );
      Navigator.pop(context);
    } else if (result == "already_rated") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rating Failed, Order is already rated")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit rating")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 379,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Would you mind rating us?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () => setState(() => selectedRating = index + 1),
                  child: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
