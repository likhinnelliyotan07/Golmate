import 'dart:developer';
import '../di/service_locator.dart';
import '../services/user_service.dart';
import '../../domain/entities/user_entity.dart';

/// Example class demonstrating how to fetch user data from Firestore
class FirestoreUserExample {
  final UserService _userService = sl<UserService>();

  /// Example 1: Fetch a single user by ID
  Future<void> fetchSingleUser(String userId) async {
    try {
      log("Example: Fetching user with ID: $userId");

      final user = await _userService.getUserById(userId);

      if (user != null) {
        log("Example: User found!");
        log("  - Name: ${user.name}");
        log("  - Email: ${user.email}");
        log("  - Phone: ${user.phone}");
        log("  - Profile Image: ${user.profileImageUrl}");
        log("  - Email Verified: ${user.isEmailVerified}");
        log("  - Phone Verified: ${user.isPhoneVerified}");
        log("  - Created At: ${user.createdAt}");
        log("  - Updated At: ${user.updatedAt}");
      } else {
        log("Example: User not found in Firestore");
      }
    } catch (e) {
      log('Example: Error fetching user: $e');
    }
  }

  /// Example 2: Fetch multiple users
  Future<void> fetchMultipleUsers(List<String> userIds) async {
    try {
      log("Example: Fetching multiple users: $userIds");

      final users = await _userService.getUsersByIds(userIds);

      log("Example: Found ${users.length} users");
      for (final user in users) {
        log("  - ${user.name ?? user.email} (${user.id})");
      }
    } catch (e) {
      log('Example: Error fetching multiple users: $e');
    }
  }

  /// Example 3: Listen to user data changes in real-time
  void listenToUserChanges(String userId) {
    log("Example: Starting to listen to user changes for: $userId");

    _userService
        .listenToUser(userId)
        .listen(
          (user) {
            if (user != null) {
              log("Example: User data updated!");
              log("  - Name: ${user.name}");
              log("  - Email: ${user.email}");
              log("  - Updated At: ${user.updatedAt}");
            } else {
              log("Example: User data deleted or not found");
            }
          },
          onError: (error) {
            log('Example: Error in user stream: $error');
          },
        );
  }

  /// Example 4: Update user data
  Future<void> updateUserData(String userId) async {
    try {
      log("Example: Updating user data for: $userId");

      // First, get the current user
      final user = await _userService.getUserById(userId);
      if (user == null) {
        log("Example: User not found, cannot update");
        return;
      }

      // Update the user with new data
      final updatedUser = user.copyWith(
        name: 'Updated Name',
        phone: '+1234567890',
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      final success = await _userService.updateUser(updatedUser);

      if (success) {
        log("Example: User updated successfully!");
      } else {
        log("Example: Failed to update user");
      }
    } catch (e) {
      log('Example: Error updating user: $e');
    }
  }

  /// Example 5: Create a new user
  Future<void> createNewUser() async {
    try {
      log("Example: Creating a new user");

      final newUser = UserEntity(
        id: 'example_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'example@example.com',
        name: 'Example User',
        phone: '+1234567890',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: false,
        isPhoneVerified: false,
      );

      final success = await _userService.createUser(newUser);

      if (success) {
        log("Example: User created successfully!");
        log("  - User ID: ${newUser.id}");
      } else {
        log("Example: Failed to create user");
      }
    } catch (e) {
      log('Example: Error creating user: $e');
    }
  }

  /// Example 6: Get user statistics
  Future<void> getUserStatistics(String userId) async {
    try {
      log("Example: Getting user statistics for: $userId");

      final stats = await _userService.getUserStats(userId);

      log("Example: User statistics:");
      log("  - Total Goals: ${stats['totalGoals'] ?? 0}");
      log("  - Total Achievements: ${stats['totalAchievements'] ?? 0}");
      log("  - Member Since: ${stats['userCreatedAt']}");
      log("  - Last Updated: ${stats['lastUpdated']}");
    } catch (e) {
      log('Example: Error getting user statistics: $e');
    }
  }

  /// Example 7: Search users by email
  Future<void> searchUsersByEmail(String emailQuery) async {
    try {
      log("Example: Searching users by email: $emailQuery");

      final users = await _userService.searchUsersByEmail(emailQuery);

      log("Example: Found ${users.length} users matching email query");
      for (final user in users) {
        log("  - ${user.name ?? user.email} (${user.email})");
      }
    } catch (e) {
      log('Example: Error searching users: $e');
    }
  }

  /// Example 8: Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      log("Example: Deleting user: $userId");

      final success = await _userService.deleteUser(userId);

      if (success) {
        log("Example: User deleted successfully!");
      } else {
        log("Example: Failed to delete user");
      }
    } catch (e) {
      log('Example: Error deleting user: $e');
    }
  }

  /// Run all examples
  Future<void> runAllExamples() async {
    log("=== Firestore User Examples ===");

    // Example 1: Fetch single user
    await fetchSingleUser('example_user_id');

    // Example 2: Fetch multiple users
    await fetchMultipleUsers(['user1', 'user2', 'user3']);

    // Example 3: Listen to user changes
    listenToUserChanges('example_user_id');

    // Example 4: Update user data
    await updateUserData('example_user_id');

    // Example 5: Create new user
    await createNewUser();

    // Example 6: Get user statistics
    await getUserStatistics('example_user_id');

    // Example 7: Search users by email
    await searchUsersByEmail('example');

    // Example 8: Delete user (commented out for safety)
    // await deleteUser('example_user_id');

    log("=== Examples completed ===");
  }
}
