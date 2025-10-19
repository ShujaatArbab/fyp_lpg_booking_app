import 'package:flutter/material.dart';
import 'package:lpg_booking_system/controllers/customer_controller/notifications_controller.dart';
import 'package:lpg_booking_system/models/customers_models/login_response.dart';
import 'package:lpg_booking_system/models/customers_models/notifications_response.dart';

class NotificationsScreen extends StatefulWidget {
  final LoginResponse customer;

  const NotificationsScreen({super.key, required this.customer});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController =
      NotificationController();
  List<NotificationResponse> _notifications = [];
  bool _isLoading = true;
  bool _isMarking = false;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final result = await _notificationController.fetchNotifications(
        widget.customer.userid,
      );
      setState(() {
        _notifications = result;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading notifications: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    setState(() => _isMarking = true);
    final success = await _notificationController.markAllAsRead(
      widget.customer.userid,
    );
    setState(() => _isMarking = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ All notifications marked as read")),
      );
      _fetchNotifications();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to mark notifications")),
      );
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
                itemCount: _notifications.length + 1, // extra for button
                itemBuilder: (context, index) {
                  if (index < _notifications.length) {
                    final notif = _notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications_active,
                          color: Colors.orange,
                        ),
                        title: Text(
                          notif.message,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Date: ${notif.createdOn.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // ✅ "Got it" button after list
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isMarking ? null : _markAllAsRead,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.orange, width: 2),
                            ),
                          ),
                          child:
                              _isMarking
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    "Got it",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 20,
                                    ),
                                  ),
                        ),
                      ),
                    );
                  }
                },
              ),
    );
  }
}
