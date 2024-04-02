// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/pending_assigned_order_cubit/new_user_and_order_datasource.dart';

part 'add_new_order_state.dart';

class AddNewOrderCubit extends Cubit<AddNewOrderState> {
  AddNewOrderCubit() : super(const AddNewOrderInitial());
  final AddOrderBackend _newOrderHelper = AddOrderBackend();

  Future<void> verifyUser({
    required String phone,
    required ScrapType type,
  }) async {
    emit(const AddNewOrderLoading());
    try {
      final user = await _newOrderHelper.checkUserAlreadyExist(
        phone: phone,
      );
      if (user != null) {
        _createOrderForExistingUser(user, type);
      } else {
        emit(const NewUserState());
      }
    } catch (e) {
      // print(' *** *** *** *** ** *$e');
      emit(const AddNewOrderError());
    }
  }

  Future<void> createOrder({
    required String name,
    required String phone,
    required String address,
    required DateTime pickupDate,
    required ScrapType type,
  }) async {
    emit(const AddNewOrderLoading());

    try {
      final user = {
        'phone': phone,
        'name': name,
        'email': '',
        'profilePic': null,
        'address': address,
        'uid': phone,
      };

      final order = ScrapOrderModel(
        id: 'UNKNOWN',
        orderId: 'UNKNOWN',
        customerName: name,
        phone: phone,
        address: address,
        pickupDate: DateTime(pickupDate.year, pickupDate.month, pickupDate.day),
        amtPayable: 0,
        roundOffAmt: 0,
        serviceCharge: 0,
        status: pickupDate.isToday
            ? OrderStatusConst.PROCESSING
            : OrderStatusConst.PENDING,
        note: '',
        type: type,
        assignedStaffId: UserAuth.I.currentUser!.staffId,
        createdAt: DateTime.now(),
        uid: phone,
      );

      await _newOrderHelper.createUserAndOrder(
        user: user,
        scrapModel: order,
      );
      emit(const AddNewOrderPlaced());
    } catch (e) {
      emit(const AddNewOrderError());
    }
  }

  // it wii call when click popup, to continue to create order.
  Future<void> addOrderForExistingUser(ScrapOrder order) async {
    try {
      await _newOrderHelper
          .createOrderForExistingUser(order as ScrapOrderModel);
      emit(const AddNewOrderPlaced());
    } catch (e) {
      emit(const AddNewOrderError());
    }
  }

  // It just create ScrapOrderModel only and it emit to UI
  void _createOrderForExistingUser(Map<String, dynamic> user, ScrapType type) {
    final date = DateTime.now();
    final order = ScrapOrderModel(
      id: 'UNKNOWN',
      orderId: 'unknown',
      customerName: user['name'] as String,
      phone: user['phone'] as String,
      address: user['address'] as String,
      pickupDate: DateTime(date.year, date.month, date.day),
      amtPayable: 0,
      roundOffAmt: 0,
      serviceCharge: 0,
      note: '',
      type: type,
      status: OrderStatusConst.PROCESSING,
      assignedStaffId: UserAuth.I.currentUser!.staffId,
      createdAt: date,
      uid: user['uid'] as String,
    );
    emit(UserAlreadyExist(order: order));
  }
}
