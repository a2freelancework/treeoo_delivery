import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';

part 'pending_assigned_order_state.dart';

class PendingAssignedOrderCubit extends Cubit<PendingAssignedOrderState> {
  PendingAssignedOrderCubit(
    // required GetAllPendingAssignedOrder getAllPendingAssignedOrder,
  )  : 
  // _getAllPendingAssignedOrder = getAllPendingAssignedOrder,
        super(const PendingAssignedOrderLoading());

  // final GetAllPendingAssignedOrder _getAllPendingAssignedOrder;

  Future<void> getAllPendingAssignedOrders() async {
    // emit(const PendingAssignedOrderLoading());
    // final result = await _getAllPendingAssignedOrder();
    // result.fold(
    //   (failure) => emit(PendingAssignedOrderError(failure.errorMessage)),
    //   (orders) => emit(PendingAssignedOrderLoaded(orders)),
    // );
  }
}
