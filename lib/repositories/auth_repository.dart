import 'package:muhjaaa/models/user_model.dart';
import 'package:muhjaaa/repositories/failure.dart';
import 'package:muhjaaa/utils/either.dart'; // Import the extracted Either type

class AuthRepository {
  FutureEither<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

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
    await Future.delayed(const Duration(seconds: 1));

    if (!email.contains("exists")) {
      final user = UserModel(
        id: "user-${DateTime.now().millisecondsSinceEpoch}",
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
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
