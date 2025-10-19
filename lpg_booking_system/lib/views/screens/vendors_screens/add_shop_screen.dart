import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/add_shop_controller.dart';
import 'package:lpg_booking_system/models/vendors_models/add_shop_response.dart';
import 'package:lpg_booking_system/models/vendors_models/addshop_request.dart';
import 'package:lpg_booking_system/models/login_response.dart'; // import your LoginResponse
import 'package:lpg_booking_system/widgets/custom_button.dart';

class AddShopScreen extends StatefulWidget {
  final LoginResponse loginResponse; // ✅ take login response

  const AddShopScreen({super.key, required this.loginResponse});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopCityController = TextEditingController();
  final TextEditingController openTimeController = TextEditingController();
  final TextEditingController closeTimeController = TextEditingController();

  String errorShopName = "";
  String errorShopCity = "";
  String errorOpenTime = "";
  String errorCloseTime = "";

  bool isLoading = false;

  final AddShopController _controller = AddShopController();

  bool validateInputs() {
    setState(() {
      errorShopName = shopNameController.text.isEmpty ? "Enter shop name" : "";
      errorShopCity = shopCityController.text.isEmpty ? "Enter shop city" : "";
      errorOpenTime = openTimeController.text.isEmpty ? "Enter open time" : "";
      errorCloseTime =
          closeTimeController.text.isEmpty ? "Enter close time" : "";
    });

    return errorShopName.isEmpty &&
        errorShopCity.isEmpty &&
        errorOpenTime.isEmpty &&
        errorCloseTime.isEmpty;
  }

  void saveShop() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    final request = AddShopRequest(
      shopName: shopNameController.text,
      shopCity: shopCityController.text,
      openTime: openTimeController.text,
      closeTime: closeTimeController.text,
      userId: widget.loginResponse.userid, // ✅ use login userid
    );

    AddShopResponse? response = await _controller.addShop(request);

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      shopNameController.clear();
      shopCityController.clear();
      openTimeController.clear();
      closeTimeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?.message ?? "Failed to add shop")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Shop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(
                labelText: "Shop Name",
                errorText: errorShopName.isNotEmpty ? errorShopName : null,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: shopCityController,
              decoration: InputDecoration(
                labelText: "Shop City",
                errorText: errorShopCity.isNotEmpty ? errorShopCity : null,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: openTimeController,
              decoration: InputDecoration(
                labelText: "Open Time (HH:mm)",
                hintText: "e.g. 09:00",
                errorText: errorOpenTime.isNotEmpty ? errorOpenTime : null,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: closeTimeController,
              decoration: InputDecoration(
                labelText: "Close Time (HH:mm)",
                hintText: "e.g. 21:00",
                errorText: errorCloseTime.isNotEmpty ? errorCloseTime : null,
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: 'Add', onpressed: saveShop),
          ],
        ),
      ),
    );
  }
}
