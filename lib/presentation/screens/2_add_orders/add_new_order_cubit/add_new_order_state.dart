part of 'add_new_order_cubit.dart';

sealed class AddNewOrderState extends Equatable {
  const AddNewOrderState();

  @override
  List<Object> get props => [];
}

final class AddNewOrderInitial extends AddNewOrderState {
  const AddNewOrderInitial();
}

final class AddNewOrderLoading extends AddNewOrderState {
  const AddNewOrderLoading();
}

final class AddNewOrderError extends AddNewOrderState {
  const AddNewOrderError();
}

final class AddNewOrderPlaced extends AddNewOrderState {
  const AddNewOrderPlaced();
}

final class UserAlreadyExist extends AddNewOrderState {
  const UserAlreadyExist({required this.order});

  final ScrapOrder order;
}

final class NewUserState extends AddNewOrderState {
  const NewUserState();
}
