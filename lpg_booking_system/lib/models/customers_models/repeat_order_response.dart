class RepeatOrderResponse {
  final int orderId;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String status;
  final int price;
  final RepeatCustomer customer;
  final RepeatVendor vendor;
  final List<RepeatOrderItem> items;

  RepeatOrderResponse({
    required this.orderId,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.price,
    required this.customer,
    required this.vendor,
    required this.items,
  });

  factory RepeatOrderResponse.fromJson(Map<String, dynamic> json) {
    return RepeatOrderResponse(
      orderId: json['OrderId'],
      orderDate: DateTime.parse(json['OrderDate']),
      deliveryDate:
          json['DeliveryDate'] != null && json['DeliveryDate'] != ""
              ? DateTime.parse(json['DeliveryDate'])
              : null,
      status: json['Status'] ?? "",
      price: json['Price'] ?? 0,
      customer: RepeatCustomer.fromJson(json['Customer']),
      vendor: RepeatVendor.fromJson(json['Vendor']),
      items:
          (json['Items'] as List<dynamic>)
              .map((e) => RepeatOrderItem.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "OrderId": orderId,
      "OrderDate": orderDate.toIso8601String(),
      "DeliveryDate": deliveryDate?.toIso8601String(),
      "Status": status,
      "Price": price,
      "Customer": customer.toJson(),
      "Vendor": vendor.toJson(),
      "Items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class RepeatCustomer {
  final String id;
  final String name;
  final String phone;
  final String city;

  RepeatCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
  });

  factory RepeatCustomer.fromJson(Map<String, dynamic> json) {
    return RepeatCustomer(
      id: json['Id'] ?? "",
      name: json['Name'] ?? "",
      phone: json['Phone'] ?? "",
      city: json['City'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"Id": id, "Name": name, "Phone": phone, "City": city};
  }
}

class RepeatVendor {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String address;

  RepeatVendor({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
  });

  factory RepeatVendor.fromJson(Map<String, dynamic> json) {
    return RepeatVendor(
      id: json['Id'] ?? "",
      name: json['Name'] ?? "",
      phone: json['Phone'] ?? "",
      city: json['City'] ?? "",
      address: json['Address'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "Phone": phone,
      "City": city,
      "Address": address,
    };
  }
}

class RepeatOrderItem {
  final int stockId;
  final String size;
  final int price;
  final int quantity;
  final int orderItemId;
  final List<RepeatAccessory> accessories;

  RepeatOrderItem({
    required this.stockId,
    required this.size,
    required this.price,
    required this.quantity,
    required this.orderItemId,
    required this.accessories,
  });

  factory RepeatOrderItem.fromJson(Map<String, dynamic> json) {
    return RepeatOrderItem(
      stockId: json['StockId'],
      size: json['Size'] ?? "Unknown",
      price: json['Price'] ?? 0,
      quantity: json['Quantity'] ?? 0,
      orderItemId: json['OrderItemId'] ?? 0,
      accessories:
          (json['Accessories'] as List<dynamic>)
              .map((e) => RepeatAccessory.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "StockId": stockId,
      "Size": size,
      "Price": price,
      "Quantity": quantity,
      "OrderItemId": orderItemId,
      "Accessories": accessories.map((e) => e.toJson()).toList(),
    };
  }
}

class RepeatAccessory {
  final String usagePurpose;
  final int quantity;

  RepeatAccessory({required this.usagePurpose, required this.quantity});

  factory RepeatAccessory.fromJson(Map<String, dynamic> json) {
    return RepeatAccessory(
      usagePurpose: json['UsagePurpose'] ?? "",
      quantity: json['Quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"UsagePurpose": usagePurpose, "Quantity": quantity};
  }
}
