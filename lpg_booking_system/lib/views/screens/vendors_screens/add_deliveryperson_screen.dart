import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controllers/add_deliveryperson_controller.dart';

import 'package:lpg_booking_system/models/login_response.dart'; // ✅ import LoginResponse
import 'package:lpg_booking_system/models/vendors_models/add_deliveryperson_request.dart';
import 'package:lpg_booking_system/models/vendors_models/add_deliveryperson_response.dart';
import 'package:lpg_booking_system/widgets/custom_button.dart';

class AddDeliveryPersonScreen extends StatefulWidget {
  final LoginResponse loginResponse; // ✅ take login response

  const AddDeliveryPersonScreen({super.key, required this.loginResponse});

  @override
  State<AddDeliveryPersonScreen> createState() =>
      _AddDeliveryPersonScreenState();
}

class _AddDeliveryPersonScreenState extends State<AddDeliveryPersonScreen> {
  final TextEditingController dpNameController = TextEditingController();
  final TextEditingController dpPhoneController = TextEditingController();

  String errorDPName = "";
  String errorDPPhone = "";

  bool isLoading = false;

  final AddDPController _controller = AddDPController();

  bool validateInputs() {
    setState(() {
      errorDPName =
          dpNameController.text.isEmpty ? "Enter delivery person name" : "";
      errorDPPhone = dpPhoneController.text.isEmpty ? "Enter phone number" : "";
    });

    return errorDPName.isEmpty && errorDPPhone.isEmpty;
  }

  void saveDeliveryPerson() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    final request = AddDPRequest(
      dpName: dpNameController.text,
      dpPhone: dpPhoneController.text,
      vendorId: widget.loginResponse.userid, // ✅ use login userid (vendor id)
    );

    AddDPResponse? response = await _controller.addDeliveryPerson(request);

    setState(() {
      isLoading = false;
    });

    if (response != null && response.data != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      dpNameController.clear();
      dpPhoneController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?.message ?? "Failed to add delivery person"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Delivery Person',
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
              controller: dpNameController,
              decoration: InputDecoration(
                labelText: "Delivery Person Name",
                errorText: errorDPName.isNotEmpty ? errorDPName : null,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: dpPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                errorText: errorDPPhone.isNotEmpty ? errorDPPhone : null,
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(text: 'Add', onpressed: saveDeliveryPerson),
          ],
        ),
      ),
    );
  }
}
