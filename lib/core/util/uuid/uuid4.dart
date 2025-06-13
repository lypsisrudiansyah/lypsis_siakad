import 'package:uuid/uuid.dart';

String get uuid4 {
  return const Uuid().v4();
}
