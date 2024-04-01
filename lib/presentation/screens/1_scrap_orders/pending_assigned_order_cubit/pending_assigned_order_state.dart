part of 'pending_assigned_order_cubit.dart';

sealed class PendingAssignedOrderState extends Equatable {
  const PendingAssignedOrderState();

  @override
  List<Object> get props => [];
}

final class PendingAssignedOrderLoading extends PendingAssignedOrderState {
  const PendingAssignedOrderLoading();
}

final class PendingAssignedOrderLoaded extends PendingAssignedOrderState {
  const PendingAssignedOrderLoaded(this.orders);

  final Iterable<ScrapOrder> orders;

  @override
  List<Iterable<ScrapOrder>> get props => [orders];
}

final class PendingAssignedOrderError extends PendingAssignedOrderState {
  const PendingAssignedOrderError(this.message);
  final String message;
  @override
  List<String> get props => [message];
}
