// lib/utils/either.dart
import 'package:muhjaaa/repositories/failure.dart'; // Assuming Failure is in this path

abstract class Either<L, R> {
  const Either();
  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get leftValue {
    if (this is Left<L, R>) {
      return (this as Left<L, R>).value;
    }
    throw Exception('Tried to get leftValue on a Right instance');
  }

  R get rightValue {
    if (this is Right<L, R>) {
      return (this as Right<L, R>).value;
    }
    throw Exception('Tried to get rightValue on a Left instance');
  }

  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) {
    if (isLeft) {
      return ifLeft(leftValue);
    } else {
      return ifRight(rightValue);
    }
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}

// Define a type for the result of repository operations
// Either a Failure or the expected data type (T)
typedef FutureEither<T> = Future<Either<Failure, T>>;
