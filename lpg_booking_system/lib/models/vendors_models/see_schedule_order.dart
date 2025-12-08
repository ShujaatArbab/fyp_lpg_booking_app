// vendor_scheduled_order_model.dart
class VendorScheduledOrder {
  final int scheduleId;
  final int orderId;
  final DateTime scheduledDate;
  final String customerId;
  final String customerName;
  final List<VendorScheduledOrderItem> items;

  VendorScheduledOrder({
    required this.scheduleId,
    required this.orderId,
    required this.scheduledDate,
    required this.customerId,
    required this.customerName,
    required this.items,
  });

  factory VendorScheduledOrder.fromJson(Map<String, dynamic> json) {
    return VendorScheduledOrder(
      scheduleId: json['ScheduleId'],
      orderId: json['OrderId'],
      scheduledDate: DateTime.parse(json['ScheduledDate']),
      customerId: json['CustomerId'],
      customerName: json['CustomerName'],
      items:
          (json['Items'] as List)
              .map((e) => VendorScheduledOrderItem.fromJson(e))
              .toList(),
    );
  }
}

class VendorScheduledOrderItem {
  final int cylinderId;
  final int cylinderWeight;
  final int quantity;

  VendorScheduledOrderItem({
    required this.cylinderId,
    required this.cylinderWeight,
    required this.quantity,
  });

  factory VendorScheduledOrderItem.fromJson(Map<String, dynamic> json) {
    return VendorScheduledOrderItem(
      cylinderId: json['CylinderId'],
      cylinderWeight: json['CylinderWeight'],
      quantity: json['Quantity'],
    );
  }
}
