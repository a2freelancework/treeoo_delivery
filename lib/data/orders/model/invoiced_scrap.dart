import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';

class InvoicedScrap extends Equatable {
  const InvoicedScrap({
    required this.scrapRefId,
    required this.scraps,
    required this.invoiceId,
  });

  InvoicedScrap.fromMap(DataMap map)
      : this(
          scrapRefId: map['scrapRefId'] as String,
          invoiceId: map['invoiceId'] as String,
          scraps: (map['scrap_list'] as List<Map<String, dynamic>>)
              .map(ScrapModel.fromMap)
              .toList(),
        );

  factory InvoicedScrap.fromDocMap(DocMap data) {
    final map = data.data()!;
    return InvoicedScrap(
      scrapRefId: data.id,
      invoiceId: map['invoiceId'] as String,
      scraps: (map['scrap_list'] as List)
          .map((map) => map as DataMap)
          .map(ScrapModel.fromMap)
          .toList(),
    );
  }

  final String scrapRefId;
  final String invoiceId;
  final List<ScrapModel> scraps;

  @override
  List<Object?> get props => [scrapRefId];

  @override
  String toString() {
    return 'InvoicedScrap(scrapRefId: $scrapRefId, scraps: $scraps,'
        ' invoiceId: $invoiceId';
  }

  Map<String, dynamic> toMap() {
    return {
      'scrapRefId': scrapRefId,
      'invoiceId': invoiceId,
      'scrap_list': scraps.map((sp) => sp.toMap()).toList(),
    };
  }

  InvoicedScrap clone() {
    return InvoicedScrap(
      scrapRefId: scrapRefId,
      scraps: List.from(scraps),
      invoiceId: invoiceId,
    );
  }
}
