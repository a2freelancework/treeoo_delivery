import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/data/orders/model/collected_item.dart';

class MyCollection extends Equatable{
  const MyCollection({
    required this.id, 
    required this.totalPaidAmt, 
    required this.totalQty, 
    required this.totalServiceCharge,
    required this.totalRoundOff,
    required this.items,
    required this.date, 
  });

  
  final String id;
  final DateTime date;
  final double totalPaidAmt;
  final double totalQty;
  final double totalServiceCharge;
  final double totalRoundOff;
  final List<CollectedItem> items;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'MyCollection( id: $id, totalPaidAmt: $totalPaidAmt, '
    'totalQty: $totalQty, totalServiceCharge: $totalServiceCharge, '
    'totalRoundOff: $totalRoundOff, items: $items)';
  }
}
