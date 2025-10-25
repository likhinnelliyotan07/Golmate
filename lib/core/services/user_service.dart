import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Service for managing user data operations with Firestore
class UserService {
  final FirebaseFirestore _firestore;

  UserService({required FirebaseFirestore firestore}) : _firestore = firestore;

  /// Fetch user data from Firestore by user ID
  Future<UserEntity?> getUserById(String userId) async {
    try {
      log("UserService: Fetching user from Firestore: $userId");

      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        log("UserService: User found in Firestore, converting to entity");
        final userEntity = UserModel.fromJson(doc.data()!).toEntity();
        log("UserService: User retrieved from Firestore successfully");
        return userEntity;
      } else {
        log("UserService: User not found in Firestore");
        return null;
      }
    } catch (e) {
      log('UserService: Failed to get user from Firestore: $e');
      return null;
    }
  }

  /// Fetch multiple users by their IDs
  Future<List<UserEntity>> getUsersByIds(List<String> userIds) async {
    try {
      log("UserService: Fetching multiple users from Firestore: $userIds");

      if (userIds.isEmpty) return [];

      final futures = userIds.map((userId) => getUserById(userId));
      final results = await Future.wait(futures);

      // Filter out null results
      final users = results
          .where((user) => user != null)
          .cast<UserEntity>()
          .toList();

      log("UserService: Retrieved ${users.length} users from Firestore");
      return users;
    } catch (e) {
      log('UserService: Failed to get multiple users from Firestore: $e');
      return [];
    }
  }

  /// Update user data in Firestore
  Future<bool> updateUser(UserEntity user) async {
    try {
      log("UserService: Updating user in Firestore: ${user.id}");

      final userModel = UserModel.fromEntity(user);
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(userModel.toJson());

      log("UserService: User updated in Firestore successfully");
      return true;
    } catch (e) {
      log('UserService: Failed to update user in Firestore: $e');
      return false;
    }
  }

  /// Create user data in Firestore
  Future<bool> createUser(UserEntity user) async {
    try {
      log("UserService: Creating user in Firestore: ${user.id}");

      final userModel = UserModel.fromEntity(user);
      await _firestore.collection('users').doc(user.id).set(userModel.toJson());

      log("UserService: User created in Firestore successfully");
      return true;
    } catch (e) {
      log('UserService: Failed to create user in Firestore: $e');
      return false;
    }
  }

  /// Delete user data from Firestore
  Future<bool> deleteUser(String userId) async {
    try {
      log("UserService: Deleting user from Firestore: $userId");

      await _firestore.collection('users').doc(userId).delete();

      log("UserService: User deleted from Firestore successfully");
      return true;
    } catch (e) {
      log('UserService: Failed to delete user from Firestore: $e');
      return false;
    }
  }

  /// Listen to user data changes in real-time
  Stream<UserEntity?> listenToUser(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!).toEntity();
      }
      return null;
    });
  }

  /// Search users by email (for admin purposes)
  Future<List<UserEntity>> searchUsersByEmail(String emailQuery) async {
    try {
      log("UserService: Searching users by email: $emailQuery");

      final query = await _firestore
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: emailQuery)
          .where('email', isLessThan: '$emailQuery\uf8ff')
          .get();

      final users = query.docs
          .map((doc) => UserModel.fromJson(doc.data()).toEntity())
          .toList();

      log("UserService: Found ${users.length} users matching email query");
      return users;
    } catch (e) {
      log('UserService: Failed to search users by email: $e');
      return [];
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      log("UserService: Getting user stats for: $userId");

      // Get user document
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        return {};
      }

      // Get user's goals count
      final goalsQuery = await _firestore
          .collection('goals')
          .where('userId', isEqualTo: userId)
          .get();

      // Get user's achievements count
      final achievementsQuery = await _firestore
          .collection('achievements')
          .where('userId', isEqualTo: userId)
          .get();

      final stats = {
        'totalGoals': goalsQuery.docs.length,
        'totalAchievements': achievementsQuery.docs.length,
        'userCreatedAt': userDoc.data()?['createdAt'],
        'lastUpdated': userDoc.data()?['updatedAt'],
      };

      log("UserService: Retrieved user stats successfully");
      return stats;
    } catch (e) {
      log('UserService: Failed to get user stats: $e');
      return {};
    }
  }
}
