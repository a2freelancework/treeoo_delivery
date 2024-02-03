import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';

class CollectedItem extends Equatable {
  const CollectedItem({
    required this.itemName,
    required this.amount,
    required this.qty,
  });

  factory CollectedItem.fromMap(DataMap map) {
    return CollectedItem(
      itemName: map['name'] as String,
      amount: double.tryParse('${map['amount']}') ?? 0,
      qty: double.tryParse('${map['qty']}') ?? 0,
    );
  }
  
  final String itemName;
  final double amount;
  final double qty;

  @override
  List<Object?> get props => [itemName];

  @override
  String toString() {
    return 'CollectedItem( itemName: $itemName, amount: $amount, qty: $qty)';
  }

  CollectedItem copyWith({
    double? amount,
    double? qty,
  }) {
    return CollectedItem(
      itemName: itemName,
      amount: amount ?? this.amount,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': itemName,
      'amount': amount,
      'qty': qty,
    };
  }
}
