class Order {
  final int totalQuantity;
  final double totalPrice;
  final DateTime orderDate;
  final String name; 
  final String address; 
  final String phone; 

  Order({
    required this.totalQuantity,
    required this.totalPrice,
    required this.orderDate,
    required this.name,
    required this.address,
    required this.phone,
  });
}