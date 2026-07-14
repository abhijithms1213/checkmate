import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? error;

  const DataState({this.data, this.error});
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException err) : super(error: err);
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}
