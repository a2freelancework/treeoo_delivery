import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';

part 'scrap_state.dart';

class ScrapCubit extends Cubit<ScrapState> {
  ScrapCubit() : super(const ScrapInitial());

  Future<void> fetchScraps() async {
    final result = await OrderUsecases.I.getAllScrap();
    result.fold(
      (l) => null,
      (scraps) {
        emit(ScrapsLoaded(scraps: scraps));
      },
    );
  }
}
