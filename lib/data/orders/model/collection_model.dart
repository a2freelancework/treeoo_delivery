import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/model/collected_item.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';

class CollectionModel extends MyCollection {
  const CollectionModel({
    required super.id,
    required super.date,
    required super.totalPaidAmt,
    required super.totalQty,
    required super.totalServiceCharge,
    required super.totalRoundOff,
    required super.items,
  });

  factory CollectionModel.fromMap(DataMap map) {
    final list = map['items'] as List?;
    return CollectionModel(
      id: map['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      totalPaidAmt: double.tryParse('${map['total_paid_amt']}') ?? 0,
      totalQty: double.tryParse('${map['total_qty']}') ?? 0,
      totalServiceCharge:
          double.tryParse('${map['total_service_charge']}') ?? 0,
      totalRoundOff: double.tryParse('${map['total_round_off']}') ?? 0,
      items: (list ?? [])
          .map((map) => map as DataMap)
          .map(CollectedItem.fromMap)
          .toList(),
    );
  }
  factory CollectionModel.fromQueryMap(QueryMap qMap) {
    final map = qMap.data();
        
    return CollectionModel(
      id: qMap.id,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      totalPaidAmt: double.tryParse('${map['total_paid_amt']}') ?? 0,
      totalQty: double.tryParse('${map['total_qty']}') ?? 0,
      totalServiceCharge:
          double.tryParse('${map['total_service_charge']}') ?? 0,
      totalRoundOff: double.tryParse('${map['total_round_off']}') ?? 0,
      items: (map['items'] as List)
          .map((e) => e as DataMap)
          .map(CollectedItem.fromMap)
          .toList(),
    );
  }

  CollectionModel copyWith({
    double? totalPaidAmt,
    double? totalQty,
    double? totalRoundOff,
    double? totalServiceCharge,
  }) {
    return CollectionModel(
      id: id,
      date: date,
      totalPaidAmt: totalPaidAmt ?? this.totalPaidAmt,
      totalQty: totalQty ?? this.totalQty,
      totalRoundOff: totalRoundOff ?? this.totalRoundOff,
      totalServiceCharge: totalServiceCharge ?? this.totalServiceCharge,
      items: items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'total_paid_amt': totalPaidAmt,
      'total_qty': totalQty,
      'total_service_charge': totalServiceCharge,
      'total_round_off': totalRoundOff,
      'items': items.map((itm) => itm.toMap()).toList(),
    };
  }
}
