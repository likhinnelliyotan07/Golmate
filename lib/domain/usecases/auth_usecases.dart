import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<UserEntity?> getCurrentUser() async {
    return await repository.getCurrentUser();
  }

  Future<UserEntity?> getUserFromFirestore(String userId) async {
    return await repository.getUserFromFirestore(userId);
  }

  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await repository.signInWithEmail(email, password);
  }

  Future<UserEntity> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    return await repository.signUpWithEmail(email, password, name);
  }

  Future<UserEntity> signInWithGoogle() async {
    return await repository.signInWithGoogle();
  }

  Future<UserEntity> signInWithPhone(String phoneNumber) async {
    return await repository.signInWithPhone(phoneNumber);
  }

  Future<void> signOut() async {
    await repository.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await repository.sendPasswordResetEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await repository.updatePassword(newPassword);
  }

  Future<void> updateProfile(UserEntity user) async {
    await repository.updateProfile(user);
  }

  Future<void> deleteAccount() async {
    await repository.deleteAccount();
  }

  Stream<UserEntity?> get authStateChanges => repository.authStateChanges;
}
