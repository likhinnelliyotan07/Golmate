import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> getUserFromFirestore(String userId);
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(
    String email,
    String password,
    String name,
  );
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithPhone(String phoneNumber);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updatePassword(String newPassword);
  Future<void> updateProfile(UserEntity user);
  Future<void> deleteAccount();
  Stream<UserEntity?> get authStateChanges;
}
