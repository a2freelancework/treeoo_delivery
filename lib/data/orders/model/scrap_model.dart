// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';

class ScrapModel extends Equatable {
  const ScrapModel({
    required this.scrapName,
    required this.icon,
    required this.price,
    required this.qty,
  });

  ScrapModel.fromMap(DataMap map) : this(
    price: double.tryParse('${map['price']}') ?? 0,
    qty: double.tryParse('${map['qty']}') ?? 0,
    icon: map['scrap_icon'] as String,
    scrapName: map['scrap_name'] as String,
  );

  ScrapModel.fromQueryMap(QueryMap map) : this(
    price: double.tryParse('${map.data()['price']}') ?? 0,
    qty: double.tryParse('${map.data()['qty']}') ?? 0,
    icon: map.data()['scrap_icon'] as String,
    scrapName: map.data()['scrap_name'] as String,
  );
  
  final double price;
  final double qty;
  final String icon;
  final String scrapName;

  @override
  List<Object?> get props => [scrapName];

  ScrapModel copyWith({
    double? price,
    double? qty,
  }){
    return ScrapModel(
      scrapName: scrapName, 
      icon: icon, 
      price: price ?? this.price, 
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() {
    return 'ScrapModel( scrapName: $scrapName, price: $price, qty: $qty, icon: $icon';
  }

  Map<String, dynamic> toMap() {
    return {
      'scrap_name': scrapName,
      'scrap_icon': icon,
      'price': price,
      'qty': qty,
    };
  }
}
