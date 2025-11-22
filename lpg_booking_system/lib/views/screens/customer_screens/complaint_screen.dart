import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/controllers/customer_controller/complaint_controller.dart';
import 'package:lpg_booking_system/models/customers_models/complaint_reponse.dart';
import 'package:lpg_booking_system/models/customers_models/complaint_request.dart';

import 'package:lpg_booking_system/models/customers_models/login_response.dart';

class ComplaintScreen extends StatefulWidget {
  final orderid;
  final vendorname;
  final LoginResponse customer;

  const ComplaintScreen({
    super.key,
    required this.orderid,
    required this.vendorname,
    required this.customer,
  });

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

TextEditingController complaintcontroller = TextEditingController();

class _ComplaintScreenState extends State<ComplaintScreen> {
  final ComplaintService complaintService = ComplaintService();

  Future<void> submitComplaint() async {
    if (complaintcontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Write something before submitting")),
      );
      return;
    }

    try {
      ComplaintRequest request = ComplaintRequest(
        orderId: widget.orderid,
        complaintText: complaintcontroller.text.trim(),
      );

      ComplaintResponse response = await complaintService.submitComplaint(
        request,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pop(context); // go back after success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaints',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Order ID: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.orderid}'),
                SizedBox(width: 20),
                Text(
                  'Complaint Against: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.vendorname}'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(left: 50),
            child: Row(
              children: [
                Text(
                  'Complaint By: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${widget.customer.name}'),
              ],
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: TextField(
              controller: complaintcontroller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write Complaint here',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: submitComplaint,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(
              'Submit',
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
