
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';

//SINGLETONE
class UserAuth {
  UserAuth._internal();
  static final UserAuth _inst = UserAuth._internal();
  static final  UserAuth I = _inst;


  PickupUser? _user; 

  PickupUser? get currentUser => _user;

  // ignore: avoid_setters_without_getters
  set setUser(PickupUser user) => _user = user;

  void reset(){
    _user = null;
  }
}
