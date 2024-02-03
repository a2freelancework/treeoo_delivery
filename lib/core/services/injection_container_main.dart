// ignore_for_file: lines_longer_than_80_chars

part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final pref = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => pref)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => UserAuth.I);
  await authInit();
  await orderInit();
}

Future<void> authInit() async {
  sl
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userRegister: sl(),
        signIn: sl(),
        forgotPassword: sl(),
        signOut: sl(),
        getPickupUserFromCache: sl(),
      ),
    )
    ..registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(sl(), sl()),
    )
    ..registerLazySingleton<AuthDataSrc>(
      () => AuthDataSrcImpl(sl()),
    )
    ..registerLazySingleton(
      () => GetVehicles(sl()),
    )
    ..registerLazySingleton(
      () => SaveSelectedVehicles(sl()),
    )
    ..registerLazySingleton(
      () => GetPickupUserFromCache(sl()),
    )
    // ..registerLazySingleton(() => GetPickupUserFromServer(sl()),)
    ..registerLazySingleton(
      () => SignOutUser(sl()),
    )
    ..registerLazySingleton<UserRegister>(
      () => UserRegister(sl()),
    )
    ..registerLazySingleton<SignIn>(
      () => SignIn(sl()),
    )
    ..registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(sl()),
    )
    ..registerLazySingleton<SignOut>(
      () => SignOut(sl()),
    )
    ..registerLazySingleton<EmailPasswordAuth>(
      () => EmailPasswordAuthImpl(auth: sl(), firestore: sl()),
    );
}

Future<void> orderInit() async {
  sl
    ..registerLazySingleton<ScrapOrderRepo>(
      () => ScrapOrderRepoImpl(
        remoteDataSrc: sl(),
        localDataSrc: sl(),
      ),
    )
    ..registerLazySingleton<OrderRemoteDataSrc>(
      () => OrderRemoteDataSrcImpl(
        fireStore: sl(),
        userAuth: sl(),
      ),
    )
    ..registerLazySingleton<OrderLocalDataSrc>(
      () => OrderLocalDataSrcImpl(sl()),
    )
    
    // ..registerLazySingleton(() => GetTodaysPendingOrder(sl()))
    // ..registerLazySingleton(() => GetAllPendingAssignedOrder(sl()))
    ..registerLazySingleton(() => GetInvoicedScrapData(sl()))
    ..registerLazySingleton(() => GetMyCollection(sl()))
    ..registerLazySingleton(() => CompleteOrder(sl()))
    ..registerFactory(
      PendingAssignedOrderCubit.new,
    )
    ..registerFactory(
      () => ScrapCollectionCubit(
        getMyCollection: sl(),
      ),
    );
}

class AppReset {
  static Future<bool> reset() async {
    return sl<SharedPreferences>().clear();
  }
}

class DP {
  const DP._();

  static final EmailPasswordAuth emailPasswordAuth =
      GetIt.I.get<EmailPasswordAuth>();
}

final authBloc = GetIt.I.get<AuthBloc>();
