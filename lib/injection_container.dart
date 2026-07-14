import 'package:checkmate/features/address/data/data_sources/user_ds.dart';
import 'package:checkmate/features/address/data/repository/user_repo_impl.dart';
import 'package:checkmate/features/address/domain/repository/user_repo.dart';
import 'package:checkmate/features/address/domain/usecases/add_address_uc.dart';
import 'package:checkmate/features/address/domain/usecases/create_user_uc.dart';
import 'package:checkmate/features/address/presentation/bloc/user_bloc.dart';
import 'package:checkmate/features/auth/data/data_sources/auth_datasource.dart';
import 'package:checkmate/features/auth/data/repository/auth_impl.dart';
import 'package:checkmate/features/auth/domain/repository/auth_repository.dart';
import 'package:checkmate/features/auth/domain/usecases/add_otp_to_db.dart';
import 'package:checkmate/features/auth/domain/usecases/delete_existing_otp_fr_db.dart';
import 'package:checkmate/features/auth/domain/usecases/verify_otp.dart';
import 'package:checkmate/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:checkmate/features/news/data/data_sources/remote/news_api_service.dart';
import 'package:checkmate/features/news/data/repository/article_repo_impl.dart';
import 'package:checkmate/features/news/domain/repository/article_repo.dart';
import 'package:checkmate/features/news/domain/usecases/get_article.dart';
import 'package:checkmate/features/news/presentation/bloc/article/article_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:checkmate/core/services/local_storage_service.dart';
import 'package:checkmate/features/bookings/data/data_sources/lab_datasource.dart';
import 'package:checkmate/features/bookings/data/repository/labs_repository_impl.dart';
import 'package:checkmate/features/bookings/domain/repository/labs_repository.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_tests_by_pincode_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_labs_by_testid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/get_slots_by_labid_uc.dart';
import 'package:checkmate/features/bookings/domain/usecases/place_order_uc.dart';
import 'package:checkmate/features/bookings/presentation/bloc/labs/labs_bloc.dart';
import 'package:checkmate/features/appointments/data/data_sources/appointments_datasource.dart';
import 'package:checkmate/features/appointments/data/repository/appointments_repository_impl.dart';
import 'package:checkmate/features/appointments/domain/repository/appointments_repository.dart';
import 'package:checkmate/features/appointments/domain/usecases/get_user_bookings_uc.dart';
import 'package:checkmate/features/appointments/domain/usecases/get_booking_details_uc.dart';
import 'package:checkmate/features/appointments/presentation/bloc/appointments_bloc.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  // SharedPreferences & LocalStorageService
  final sharedPreferences = await SharedPreferences.getInstance();
  s1.registerSingleton<SharedPreferences>(sharedPreferences);
  s1.registerSingleton<LocalStorageService>(LocalStorageService(s1()));

  // Dio
  s1.registerSingleton<Dio>(Dio());

  // Dependencies
  s1.registerSingleton<NewsApiService>(NewsApiService(s1()));

  s1.registerSingleton<ArticleRepository>(ArticleRepoImpl(s1()));

  // use cases
  s1.registerSingleton<GetArticleUseCase>(GetArticleUseCase(s1()));

  // Blocs
  s1.registerFactory<ArticleBloc>(() => ArticleBloc(s1()));

  //=====================================================
  // AUTH - STARTS
  //=====================================================

  // Supabase Client
  s1.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Datasource
  s1.registerLazySingleton<AuthDatasource>(() => AuthDatasource(s1()));

  // Repository
  s1.registerLazySingleton<AuthRepository>(() => AuthRepoImplementation(s1()));

  // Use Cases
  s1.registerLazySingleton(() => AddOtpToDbUseCase(s1()));

  s1.registerLazySingleton(() => VerifyOtpUseCase(s1()));
  s1.registerLazySingleton(() => DeleteOtpFrDbUseCase(s1()));

  // Bloc
  s1.registerFactory(
    () => OtpBloc(
      addOtpToDbUseCase: s1(),
      deleteOtpFrDbUseCase: s1(),
      verifyOtpUseCase: s1(),
    ),
  );

  //=====================================================
  // AUTH - ENDS
  //=====================================================

  //=====================================================
  // USER
  //=====================================================

  // Datasource
  s1.registerLazySingleton<UserDs>(() => UserDs(s1()));

  // Repository
  s1.registerLazySingleton<UserRepository>(() => UserRepoImpl(s1()));

  // UseCases

  s1.registerLazySingleton(() => CreateUserUseCase(s1()));

  s1.registerLazySingleton(() => AddAddressUseCase(s1()));

  // Bloc
  s1.registerFactory(
    () => UserBloc(
      createUserUseCase: s1(),
      addAddressUseCase: s1(),
      userRepository: s1(),
    ),
  );

  //=====================================================
  // USER - ENDS
  //=====================================================

  //=====================================================
  // BOOKINGS
  //=====================================================

  s1.registerLazySingleton<LabsRemoteDataSource>(() => LabsRemoteDataSource(s1()));
  s1.registerLazySingleton<LabsRepository>(() => LabsRepositoryImpl(s1()));
  s1.registerLazySingleton(() => GetTestsByPincodeUseCase(s1()));
  s1.registerLazySingleton(() => GetLabsByTestIdUseCase(s1()));
  s1.registerLazySingleton(() => GetSlotsByLabIdUseCase(s1()));
  s1.registerLazySingleton(() => PlaceOrderUseCase(s1()));

  s1.registerFactory(() => LabsBloc(
        getTestsByPincodeUseCase: s1(),
        getLabsByTestIdUseCase: s1(),
        getSlotsByLabIdUseCase: s1(),
        placeOrderUseCase: s1(),
      ));

  //=====================================================
  // APPOINTMENTS
  //=====================================================
  s1.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => AppointmentsRemoteDataSource(s1()),
  );
  s1.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(s1()),
  );
  s1.registerLazySingleton(() => GetUserBookingsUseCase(s1()));
  s1.registerLazySingleton(() => GetBookingDetailsUseCase(s1()));
  s1.registerFactory(
    () => AppointmentsBloc(
      getUserBookingsUseCase: s1(),
      getBookingDetailsUseCase: s1(),
    ),
  );
}
