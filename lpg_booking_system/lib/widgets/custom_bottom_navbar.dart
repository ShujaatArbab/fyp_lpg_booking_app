import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentindex;
  final Function(int) ontap;
  const CustomBottomNavbar({
    super.key,
    required this.currentindex,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.orange,
      currentIndex: currentindex,
      onTap: ontap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),

          label: "Home",
          backgroundColor: Colors.orange,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "PLace Orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "My Orders",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
