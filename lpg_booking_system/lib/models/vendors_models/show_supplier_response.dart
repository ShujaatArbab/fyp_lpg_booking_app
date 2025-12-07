class SupplierResponse {
  final String userID;
  final String name;
  final String phone;
  final String email;
  final double longitude;
  final double latitude;
  final String city;
  final List<Plant> plants;

  SupplierResponse({
    required this.userID,
    required this.name,
    required this.phone,
    required this.email,
    required this.longitude,
    required this.latitude,
    required this.city,
    required this.plants,
  });

  factory SupplierResponse.fromJson(Map<String, dynamic> json) {
    return SupplierResponse(
      userID: json['UserID'],
      name: json['Name'],
      phone: json['Phone'],
      email: json['Email'],
      longitude: (json['Longitude'] ?? 0).toDouble(),
      latitude: (json['Latitude'] ?? 0).toDouble(),
      city: json['City'],
      plants:
          (json['Plants'] as List<dynamic>)
              .map((p) => Plant.fromJson(p))
              .toList(),
    );
  }
}

class Plant {
  final int plantID;
  final String plantName;
  final double latitude;
  final double longitude;
  final String plantCity;
  final List<Stock> stock;

  Plant({
    required this.plantID,
    required this.plantName,
    required this.latitude,
    required this.longitude,
    required this.plantCity,
    required this.stock,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      plantID: json['PlantID'],
      plantName: json['PlantName'],
      latitude: (json['Latitude'] ?? 0).toDouble(),
      longitude: (json['Longitude'] ?? 0).toDouble(),
      plantCity: json['PlantCity'],
      stock:
          (json['Stock'] as List<dynamic>)
              .map((s) => Stock.fromJson(s))
              .toList(),
    );
  }
}

class Stock {
  final int stockID;
  final int cylinderID;
  final int quantityAvailable;
  final int price;

  Stock({
    required this.stockID,
    required this.cylinderID,
    required this.quantityAvailable,
    required this.price,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockID: json['StockID'],
      cylinderID: json['CylinderID'],
      quantityAvailable: json['QuantityAvailable'],
      price: json['Price'] ?? 0,
    );
  }
}
