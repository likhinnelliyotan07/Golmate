import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../core/utils/firebase_auth_error_handler.dart';

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
      log("Getting current user from Firestore: ${user.uid}");

      // First try to get user data from Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        log("User found in Firestore, converting to entity");
        final userEntity = UserModel.fromJson(doc.data()!).toEntity();
        log("Current user retrieved from Firestore successfully");
        return userEntity;
      } else {
        log("User not found in Firestore, creating from Firebase Auth data");
        // Create user entity from Firebase Auth data
        final userEntity = UserEntity(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          profileImageUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: user.emailVerified,
        );

        // Save to Firestore for future use
        await _saveUserToFirestore(userEntity);
        log("User created and saved to Firestore successfully");
        return userEntity;
      }
    } catch (e) {
      log('Failed to get current user from Firestore: $e');

      // Fallback to Firebase Auth data if Firestore fails
      try {
        log("Falling back to Firebase Auth data");
        final userEntity = UserEntity(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          profileImageUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: user.emailVerified,
        );
        return userEntity;
      } catch (fallbackError) {
        log('Fallback also failed: $fallbackError');
        return null;
      }
    }
  }

  @override
  Future<UserEntity?> getUserFromFirestore(String userId) async {
    try {
      log("Fetching user from Firestore: $userId");

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        log("User found in Firestore, converting to entity");
        final userEntity = UserModel.fromJson(doc.data()!).toEntity();
        log("User retrieved from Firestore successfully");
        return userEntity;
      } else {
        log("User not found in Firestore");
        return null;
      }
    } catch (e) {
      log('Failed to get user from Firestore: $e');
      return null;
    }
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      log("Starting email sign-in process for: $email");

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      log("Email sign-in credential obtained");

      if (credential.user == null) {
        throw Exception('Sign in failed - no user returned');
      }

      final firebaseUser = credential.user!;
      log("Firebase user: ${firebaseUser.uid}, email: ${firebaseUser.email}");

      // Create user entity directly from Firebase user
      final userEntity = UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );

      // Save to Firestore
      await _saveUserToFirestore(userEntity);

      log("Email sign in completed successfully");
      return userEntity;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Email sign in error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      log("Starting email sign-up process for: $email");

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      final firebaseUser = credential.user!;
      log(
        "Firebase user created: ${firebaseUser.uid}, email: ${firebaseUser.email}",
      );

      // Update display name
      await firebaseUser.updateDisplayName(name);

      // Create user entity directly from Firebase user
      final userEntity = UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );

      // Save to Firestore
      await _saveUserToFirestore(userEntity);

      log("Email sign up completed successfully");
      return userEntity;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Sign up error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      log("Starting Google Sign-In process");

      // Try to get Google user first
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      log("Google user obtained: ${googleUser.email}");

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Validate tokens
      if (googleAuth.idToken == null) {
        throw Exception('Google authentication tokens are null');
      }

      log("Google tokens obtained successfully");

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      log("Firebase credential created, attempting sign in");

      // Sign in to Firebase with Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      log("Firebase sign in completed");

      if (userCredential.user == null) {
        throw Exception('Google sign in failed - no user returned');
      }

      final firebaseUser = userCredential.user!;
      log("Firebase user: ${firebaseUser.uid}, email: ${firebaseUser.email}");

      // Create user entity directly from Firebase user
      final userEntity = UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName,
        profileImageUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );

      // Save to Firestore
      await _saveUserToFirestore(userEntity);

      log("Google sign in completed successfully");
      return userEntity;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Google sign in error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> _saveUserToFirestore(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _firestore.collection('users').doc(user.id).set(userModel.toJson());

      log("User saved to Firestore successfully");
    } catch (e) {
      log("Failed to save user to Firestore: $e");
      // Don't throw here, as the user is already authenticated
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

        // Verify the user was created successfully
        final createdDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!createdDoc.exists) {
          throw Exception('Failed to create user document');
        }

        return newUser.toEntity();
      }
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Phone sign in error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      log('Sign out error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Password reset error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
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
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Password update error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
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
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Profile update error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
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
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code} - ${e.message}");
      final errorMessage = FirebaseAuthErrorHandler.getErrorMessage(e);
      throw FirebaseAuthException(code: e.code, message: errorMessage);
    } catch (e) {
      log('Account deletion error: $e');
      final errorMessage = FirebaseAuthErrorHandler.handleException(e);
      throw Exception(errorMessage);
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        // Create user entity directly from Firebase user if Firestore doc doesn't exist
        final userEntity = UserEntity(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          profileImageUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: user.emailVerified,
        );

        // Try to get user data from Firestore
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data()!).toEntity();
        } else {
          // If user doesn't exist in Firestore, save the current user data
          await _saveUserToFirestore(userEntity);
          return userEntity;
        }
      } catch (e) {
        log('Auth state changes error: $e');
        // Return basic user entity if Firestore fails
        return UserEntity(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName,
          profileImageUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: user.emailVerified,
        );
      }
    });
  }
}
