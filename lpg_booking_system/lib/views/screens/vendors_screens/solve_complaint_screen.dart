import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/vendor_controller/solve_complaint_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/vendors_models/solve_complaint_request.dart';
import 'package:lpg_booking_system/models/vendors_models/solve_complaint_response.dart';

class SolveComplaintScreen extends StatefulWidget {
  final LoginResponse vendorId;
  final int orderId;

  const SolveComplaintScreen({
    super.key,
    required this.vendorId,
    required this.orderId,
  });

  @override
  State<SolveComplaintScreen> createState() => _SolveComplaintScreenState();
}

class _SolveComplaintScreenState extends State<SolveComplaintScreen> {
  final TextEditingController _responseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _resultMessage = "";

  ComplaintsApi api = ComplaintsApi();

  void _submitResponse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _resultMessage = "";
    });

    try {
      VendorComplaintRequest request = VendorComplaintRequest(
        orderId: widget.orderId,
        vendorId: widget.vendorId.userid,
        sellerResponse: _responseController.text.trim(),
      );

      VendorComplaintResponse response = await api.respondToComplaint(request);

      setState(() {
        _isLoading = false;
        _resultMessage = response.message;
      });

      // Optional: show dialog
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Response"),
              content: Text(response.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    if (response.status == "Resolved") {
                      Navigator.pop(context); // go back to previous screen
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _resultMessage = "Error: $e";
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solve Complaint',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Write your response to the complaint",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    controller: _responseController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Type your response here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a response";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitResponse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                "Submit Response",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (_resultMessage.isNotEmpty)
                    Text(
                      _resultMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
