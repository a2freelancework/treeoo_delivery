import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';

class GetInvoicedScrapData {
  const GetInvoicedScrapData(this._repo);

  final ScrapOrderRepo _repo;

  Future<Either<Failure, InvoicedScrap>> call(String id) 
    => _repo.getInvoicedScrapData(id);
}
