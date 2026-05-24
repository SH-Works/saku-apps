/// Sealed class representing a domain-level failure.
sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => 'Failure(message: $message)';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
