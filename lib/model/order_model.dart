class Order {
  final int totalQuantity;
  final double totalPrice;
  final DateTime orderDate;
  final String name; // Имя
  final String address; // Адрес доставки
  final String phone; // Контактный телефон

  Order({
    required this.totalQuantity,
    required this.totalPrice,
    required this.orderDate,
    required this.name,
    required this.address,
    required this.phone,
  });
}