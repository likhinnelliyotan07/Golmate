import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class to initialize Firestore with default data
class FirestoreInitializer {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize default categories for goals
  static Future<void> initializeDefaultCategories() async {
    try {
      final categories = [
        {
          'id': 'health',
          'name': 'Health & Fitness',
          'description': 'Physical health, exercise, and wellness goals',
          'icon': 'fitness_center',
          'color': '#4CAF50',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'career',
          'name': 'Career & Professional',
          'description': 'Work-related goals and professional development',
          'icon': 'work',
          'color': '#2196F3',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'education',
          'name': 'Education & Learning',
          'description': 'Educational goals and skill development',
          'icon': 'school',
          'color': '#FF9800',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'personal',
          'name': 'Personal Development',
          'description': 'Personal growth and self-improvement goals',
          'icon': 'person',
          'color': '#9C27B0',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'financial',
          'name': 'Financial',
          'description': 'Money management and financial goals',
          'icon': 'attach_money',
          'color': '#4CAF50',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'relationships',
          'name': 'Relationships',
          'description': 'Family, friends, and relationship goals',
          'icon': 'favorite',
          'color': '#F44336',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'hobbies',
          'name': 'Hobbies & Interests',
          'description': 'Recreational activities and personal interests',
          'icon': 'palette',
          'color': '#607D8B',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final category in categories) {
        await _firestore
            .collection('categories')
            .doc(category['id'] as String)
            .set(category);
      }

      print('Default categories initialized successfully');
    } catch (e) {
      print('Error initializing categories: $e');
    }
  }

  /// Initialize default achievement templates
  static Future<void> initializeDefaultAchievements() async {
    try {
      final achievements = [
        {
          'id': 'first_goal',
          'name': 'First Steps',
          'description': 'Create your first goal',
          'icon': 'flag',
          'points': 10,
          'type': 'milestone',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'goal_streak_7',
          'name': 'Week Warrior',
          'description': 'Maintain a 7-day goal streak',
          'icon': 'local_fire_department',
          'points': 50,
          'type': 'streak',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'goal_streak_30',
          'name': 'Monthly Master',
          'description': 'Maintain a 30-day goal streak',
          'icon': 'emoji_events',
          'points': 200,
          'type': 'streak',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'goal_completion_5',
          'name': 'Goal Getter',
          'description': 'Complete 5 goals',
          'icon': 'check_circle',
          'points': 100,
          'type': 'completion',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'id': 'goal_completion_10',
          'name': 'Achievement Hunter',
          'description': 'Complete 10 goals',
          'icon': 'star',
          'points': 250,
          'type': 'completion',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (final achievement in achievements) {
        await _firestore
            .collection('achievement_templates')
            .doc(achievement['id'] as String)
            .set(achievement);
      }

      print('Default achievement templates initialized successfully');
    } catch (e) {
      print('Error initializing achievement templates: $e');
    }
  }

  /// Initialize the database with default data
  static Future<void> initializeDatabase() async {
    try {
      await initializeDefaultCategories();
      await initializeDefaultAchievements();
      print('Database initialization completed successfully');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  /// Check if categories exist, if not initialize them
  static Future<bool> needsInitialization() async {
    try {
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .limit(1)
          .get();

      return categoriesSnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking initialization status: $e');
      return true; // Assume needs initialization if error occurs
    }
  }
}
