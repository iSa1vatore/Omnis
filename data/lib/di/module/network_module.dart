import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @injectable
  Dio get dio => Dio(BaseOptions(connectTimeout: 5000));
}
