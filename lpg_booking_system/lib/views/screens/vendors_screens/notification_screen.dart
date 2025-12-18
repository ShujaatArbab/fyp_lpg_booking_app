import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/notifications_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/notifications_response.dart';
import 'package:lpg_booking_system/views/screens/vendors_screens/show_supplier_screen.dart';

class VendorNotificationsScreen extends StatefulWidget {
  final LoginResponse customer;

  const VendorNotificationsScreen({super.key, required this.customer});

  @override
  State<VendorNotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<VendorNotificationsScreen> {
  final NotificationController _notificationController =
      NotificationController();

  List<NotificationResponse> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndMarkNotifications();
  }

  Future<void> _fetchAndMarkNotifications() async {
    try {
      final result = await _notificationController.fetchNotifications(
        widget.customer.userid,
      );

      setState(() {
        _notifications = result;
        _isLoading = false;
      });

      if (result.isNotEmpty) {
        await _notificationController.markAllAsRead(widget.customer.userid);
      }
    } catch (e) {
      print("❌ Error loading notifications: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _notifications.isEmpty
              ? const Center(child: Text('No notifications found.'))
              : ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.notifications_active,
                              color: Colors.orange,
                            ),
                            title: Text(
                              notif.message,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Date: ${notif.createdOn.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// 🔘 Reorder Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed:
                                  () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => Showsupplierscreen(
                                              vendor: widget.customer,
                                            ),
                                      ),
                                    ),
                                  },

                              label: const Text(
                                "Reorder",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
