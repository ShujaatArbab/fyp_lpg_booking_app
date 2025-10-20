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

  @override
  void initState() {
    super.initState();
    _fetchAndMarkNotifications();
  }

  Future<void> _fetchAndMarkNotifications() async {
    try {
      // 1️⃣ Fetch notifications (so we can display them)
      final result = await _notificationController.fetchNotifications(
        widget.customer.userid,
      );

      setState(() {
        _notifications = result;
        _isLoading = false;
      });

      // 2️⃣ Once displayed, mark them as read (IsRead = 1)
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
                },
              ),
    );
  }
}
