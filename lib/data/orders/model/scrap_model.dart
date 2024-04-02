// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';

class ScrapModel extends Equatable {
  const ScrapModel({
    required this.scrapName,
    required this.icon,
    required this.price,
    required this.qty,
    required this.unit,
    this.type,
  });

  factory ScrapModel.fromMap(DataMap map) {
    final tp = map['type'] as String?;
    return ScrapModel(
      price: double.tryParse('${map['price']}') ?? 0,
      qty: double.tryParse('${map['qty']}') ?? 0,
      icon: map['scrap_icon'] as String,
      unit: map['unit'] as String,
      type: tp?.toScrapType(),
      scrapName: map['scrap_name'] as String,
    );
  }

  factory ScrapModel.fromQueryMap(QueryMap map) {
    final place = UserAuth.I.currentUser?.pickupLocation?.name ?? '';
    final tp = map.data()['type'] as String?;
    return ScrapModel(
      price: double.tryParse('${(map.data()['price'] as DataMap)[place]}') ?? 0,
      qty: double.tryParse('${map.data()['qty']}') ?? 0,
      icon: map.data()['scrap_icon'] as String,
      unit: map.data()['unit'] as String,
      type: tp?.toScrapType(),
      scrapName: map.data()['scrap_name'] as String,
    );
  }

  final double price;
  final double qty;
  final String icon;
  final String unit;
  final ScrapType? type;
  final String scrapName;

  @override
  List<Object?> get props => [scrapName];

  ScrapModel copyWith({
    double? price,
    double? qty,
  }) {
    return ScrapModel(
      scrapName: scrapName,
      icon: icon,
      unit: unit,
      price: price ?? this.price,
      type: type,
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() {
    return 'ScrapModel( scrapName: $scrapName, price: $price, qty: $qty, '
        'icon: $icon, unit: $unit, type: $type';
  }

  Map<String, dynamic> toMap() {
    return {
      'scrap_name': scrapName,
      'scrap_icon': icon,
      'unit': unit,
      'price': price,
      'qty': qty,
      if (type != null) 'type': type!.toText,
    };
  }
}
