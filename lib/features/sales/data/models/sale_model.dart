import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_item.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.id,
    required super.items,
    required super.total,
    required super.subtotal,
    required super.tax,
    required super.date,
    required super.createdAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json, List<SaleItem> items) {
    return SaleModel(
      id: json['id'],
      items: items,
      total: json['total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total': total,
      'subtotal': subtotal,
      'tax': tax,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SaleModel.fromEntity(Sale sale) {
    return SaleModel(
      id: sale.id,
      items: sale.items,
      total: sale.total,
      subtotal: sale.subtotal,
      tax: sale.tax,
      date: sale.date,
      createdAt: sale.createdAt,
    );
  }
}