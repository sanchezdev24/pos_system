import '../../domain/entities/sale_item.dart';

class SaleItemModel extends SaleItem {
  const SaleItemModel({
    required super.id,
    required super.saleId,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      id: json['id'],
      saleId: json['sale_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }

  factory SaleItemModel.fromEntity(SaleItem saleItem) {
    return SaleItemModel(
      id: saleItem.id,
      saleId: saleItem.saleId,
      productId: saleItem.productId,
      productName: saleItem.productName,
      quantity: saleItem.quantity,
      unitPrice: saleItem.unitPrice,
      totalPrice: saleItem.totalPrice,
    );
  }
}