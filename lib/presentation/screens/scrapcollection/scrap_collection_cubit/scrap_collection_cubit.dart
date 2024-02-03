import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';
import 'package:treeo_delivery/domain/orders/usecase/get_my_collection.dart';

part 'scrap_collection_state.dart';

class ScrapCollectionCubit extends Cubit<ScrapCollectionState> {
  ScrapCollectionCubit({
    required GetMyCollection getMyCollection,
  })  : _getMyCollection = getMyCollection,
        super(const ScrapCollectionLoading());

  final GetMyCollection _getMyCollection;

  Future<void> getMyCollection() async {
    emit(const ScrapCollectionLoading());
    
    final result = await _getMyCollection();

    result.fold(
      (failure) => emit(ScrapCollectionError(failure.errorMessage)),
      (collection) => emit(ScrapCollectionLoaded(collection)),
    );
  }
}
