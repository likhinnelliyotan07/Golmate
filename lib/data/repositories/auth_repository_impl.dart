import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _firestore = firestore;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!).toEntity();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!).toEntity();
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel(
          id: credential.user!.uid,
          email: credential.user!.email!,
          name: credential.user!.displayName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: credential.user!.emailVerified,
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(newUser.toJson());
        return newUser.toEntity();
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed');
      }

      // Update display name
      await credential.user!.updateDisplayName(name);

      final newUser = UserModel(
        id: credential.user!.uid,
        email: credential.user!.email!,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: credential.user!.emailVerified,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toJson());
      return newUser.toEntity();
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user == null) {
        throw Exception('Google sign in failed');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!).toEntity();
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName,
          profileImageUrl: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: userCredential.user!.emailVerified,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());
        return newUser.toEntity();
      }
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<UserEntity> signInWithPhone(String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('Phone verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle code sent
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Phone sign in failed');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!).toEntity();
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel(
          id: user.uid,
          email: user.email ?? '',
          phone: phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPhoneVerified: true,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());
        return newUser.toEntity();
      }
    } catch (e) {
      throw Exception('Phone sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  @override
  Future<void> updateProfile(UserEntity user) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user signed in');
      }

      await firebaseUser.updateDisplayName(user.name);
      if (user.profileImageUrl != null) {
        await firebaseUser.updatePhotoURL(user.profileImageUrl);
      }

      final updatedUser = UserModel.fromEntity(
        user,
      ).copyWith(updatedAt: DateTime.now());

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .update(updatedUser.toJson());
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data()!).toEntity();
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }
}
