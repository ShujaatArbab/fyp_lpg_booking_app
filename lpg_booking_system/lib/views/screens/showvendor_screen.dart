import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/showvendor_controller.dart';
import 'package:lpg_booking_system/models/showvendor_response.dart';
import 'package:lpg_booking_system/views/screens/placeorder_screen.dart';
import 'package:lpg_booking_system/widgets/custom_bottom_navbar.dart';
import 'package:lpg_booking_system/widgets/custom_card.dart';

class ShowVendorScreen extends StatefulWidget {
  final String city;
  final String userId;
  final String name;
  const ShowVendorScreen({
    super.key,
    required this.city,
    required this.name,
    required this.userId,
  });

  @override
  State<ShowVendorScreen> createState() => _ShowVendorScreenState();
}

class _ShowVendorScreenState extends State<ShowVendorScreen> {
  int selectedIndex = 0;
  List<VendorResponse> vendorList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  //!  function
  Future<void> fetchVendors() async {
    try {
      final response = await VendorController().fetchVendorsByCity(
        widget.city,
        "cust",
      );

      setState(() {
        vendorList = response;
        isLoading = false; // ✅ Stop loading after response
      });
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //!bottom navbar
      bottomNavigationBar: CustomBottomNavbar(
        currentindex: selectedIndex,
        ontap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,

            color: Colors.orangeAccent,

            child: Container(
              margin: EdgeInsets.only(left: 30, top: 20),
              child: Column(
                //!welcome
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //!  name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  //!  userid
                  Row(
                    children: [
                      Text(
                        'UserID:${widget.userId}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //!  region
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Region : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.city,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.filter_alt, color: Colors.orangeAccent),
                ),
              ],
            ),
          ),
          //!  card
          Expanded(
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      itemCount: vendorList.length,
                      itemBuilder: (context, index) {
                        final vendor = vendorList[index];
                        return CustomCard(
                          title: vendor.name,
                          location: 'Location: ${vendor.city}',
                          phone: vendor.phone,
                          rating: '4.0',
                          onplaceorder: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PlaceorderScreen(
                                      vendorId: vendor.userID,
                                      vendorName: vendor.name,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
