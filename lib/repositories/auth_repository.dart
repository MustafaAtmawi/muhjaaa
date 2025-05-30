import 'package:muhjaaa/models/user_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
// You might need an HTTP client like 'http' or 'dio' here in the future
// import 'package:http/http.dart' as http;

// Define a type for the result of repository operations
// Either a Failure or the expected data type (T)
typedef FutureEither<T> = Future<Either<Failure, T>>;

// A simple Either type
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

  // ADDED fold method
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

class AuthRepository {
  // In a real app, you would inject an HTTP client here
  // final http.Client _httpClient;
  // AuthRepository({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  FutureEither<UserModel> login(String username, String password) async {
    // TODO: Implement actual API call
    // For now, simulate a successful login
    print('AuthRepository: Attempting login for $username');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (username == "testuser" && password == "password") {
      const user = UserModel(
        id: "user123",
        username: "testuser",
        email: "testuser@example.com",
        firstName: "Test",
        lastName: "User",
        token: "fake_jwt_token_12345",
      );
      return const Right(user);
    } else {
      return const Left(
        Failure("Invalid username or password", statusCode: 401),
      );
    }
  }

  FutureEither<UserModel> signup({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    // TODO: Implement actual API call
    print('AuthRepository: Attempting signup for $username, $email');
    await Future.delayed(const Duration(seconds: 1));

    // Simulate a successful signup
    if (!email.contains("exists")) {
      // Simple check for simulation
      final user = UserModel(
        id: "user-${DateTime.now().millisecondsSinceEpoch}", // Generate a fake ID
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
        token: "fake_jwt_token_signup_67890",
      );
      return Right(user);
    } else {
      return const Left(Failure("Email already exists", statusCode: 409));
    }
  }

  Future<void> logout() async {
    // TODO: Implement actual API call (e.g., invalidate token on backend)
    // and clear local user data/token
    print('AuthRepository: Logging out');
    await Future.delayed(const Duration(milliseconds: 500));
    // No return value needed, or could return FutureEither<void> if logout can fail
  }

  // You might add methods like:
  // FutureEither<UserModel> getCurrentUser();
  // FutureEither<void> forgotPassword(String email);
}
