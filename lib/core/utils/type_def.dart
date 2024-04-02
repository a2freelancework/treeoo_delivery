


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';

typedef FutureScrapOrders = Future<Either<Failure, Iterable<ScrapOrder>>>;

typedef StreamCollections = Stream<Iterable<MyCollection>>;

typedef FutureVoid = Future<Either<Failure, void>>;

typedef QueryMap = QueryDocumentSnapshot<Map<String, dynamic>>;
typedef DocMap = DocumentSnapshot<Map<String, dynamic>>;

typedef DataMap = Map<String, dynamic>;

typedef ScrapOrderStream = Stream<Iterable<ScrapOrder>>;

typedef FutureScrapModels = Future<Either<Failure, List<ScrapModel>>>;
