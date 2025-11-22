class TankItem {
  final String size;
  final int price;
  int quantity;
  List<String>? accessories;

  TankItem({
    required this.price,
    required this.quantity,
    required this.size,
    this.accessories,
  });
}
