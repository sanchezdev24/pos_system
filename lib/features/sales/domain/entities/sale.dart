import 'package:equatable/equatable.dart';
import 'sale_item.dart';

class Sale extends Equatable {
  final String id;
  final List<SaleItem> items;
  final double total;
  final double subtotal;
  final double tax;
  final DateTime date;
  final DateTime createdAt;

  const Sale({
    required this.id,
    required this.items,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, items, total, subtotal, tax, date, createdAt];
}