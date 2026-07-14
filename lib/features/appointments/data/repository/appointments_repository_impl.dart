import 'package:checkmate/features/appointments/data/data_sources/appointments_datasource.dart';
import 'package:checkmate/features/appointments/domain/entities/booking_details_entity.dart';
import 'package:checkmate/features/appointments/domain/repository/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BookingDetailsEntity>> getUserBookings(String userId) {
    return remoteDataSource.getUserBookings(userId);
  }
}
