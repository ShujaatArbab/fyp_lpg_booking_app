import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lpg_booking_system/global/global_ip.dart';
import 'package:lpg_booking_system/models/customers_models/notifications_response.dart';

class NotificationController {
  //! Fetch notifications for a specific customer
  Future<List<NotificationResponse>> fetchNotifications(
    String customerId,
  ) async {
    final url = Uri.parse(
      '$baseurl/Notifications/GetNotifications/$customerId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => NotificationResponse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  //! Mark all notifications as read for a specific customer
  Future<bool> markAllAsRead(String customerId) async {
    final url = Uri.parse(
      '$baseurl/Notifications/MarkAsRead?customerId=$customerId',
    );

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print("✅ All notifications marked as read for $customerId");
      return true;
    } else {
      print("❌ Failed to mark notifications as read: ${response.statusCode}");
      return false;
    }
  }

  //! fetch unread count notification
  Future<int> fetchUnreadCount(String customerId) async {
    final url = Uri.parse('$baseurl/Notifications/GetUnreadCount/$customerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return int.tryParse(response.body) ?? 0;
    } else {
      throw Exception('Failed to fetch unread count');
    }
  }
}
