abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

// General failures
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}