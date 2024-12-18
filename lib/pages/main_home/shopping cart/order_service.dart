import 'package:pcs_12/model/order_model.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();

  factory OrderService() {
    return _instance;
  }

  OrderService._internal();

  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
  }
}