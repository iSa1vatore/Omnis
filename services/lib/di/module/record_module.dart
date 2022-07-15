import 'package:injectable/injectable.dart';
import 'package:record/record.dart';

@module
abstract class RecordModule {
  @injectable
  Record get record => Record();
}
