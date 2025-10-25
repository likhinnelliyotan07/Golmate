import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/football_player_model.dart';
import '../../domain/entities/football_player_entity.dart';

/// Service for managing football player data operations with Firestore
class FootballPlayerService {
  final FirebaseFirestore _firestore;

  FootballPlayerService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  /// Get football player profile by user ID
  Future<FootballPlayerEntity?> getPlayerByUserId(String userId) async {
    try {
      log("FootballPlayerService: Fetching player profile for user: $userId");

      final query = await _firestore
          .collection('football_players')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final player = FootballPlayerModel.fromJson(
          query.docs.first.data(),
        ).toEntity();
        log("FootballPlayerService: Player profile found");
        return player;
      } else {
        log("FootballPlayerService: No player profile found for user");
        return null;
      }
    } catch (e) {
      log('FootballPlayerService: Error fetching player profile: $e');
      return null;
    }
  }

  /// Get football player profile by player ID
  Future<FootballPlayerEntity?> getPlayerById(String playerId) async {
    try {
      log("FootballPlayerService: Fetching player profile: $playerId");

      final doc = await _firestore
          .collection('football_players')
          .doc(playerId)
          .get();

      if (doc.exists) {
        final player = FootballPlayerModel.fromJson(doc.data()!).toEntity();
        log("FootballPlayerService: Player profile found");
        return player;
      } else {
        log("FootballPlayerService: Player profile not found");
        return null;
      }
    } catch (e) {
      log('FootballPlayerService: Error fetching player profile: $e');
      return null;
    }
  }

  /// Create a new football player profile
  Future<bool> createPlayerProfile(FootballPlayerEntity player) async {
    try {
      log("FootballPlayerService: Creating player profile: ${player.id}");

      final playerModel = FootballPlayerModel.fromEntity(player);
      await _firestore
          .collection('football_players')
          .doc(player.id)
          .set(playerModel.toJson());

      log("FootballPlayerService: Player profile created successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error creating player profile: $e');
      return false;
    }
  }

  /// Update football player profile
  Future<bool> updatePlayerProfile(FootballPlayerEntity player) async {
    try {
      log("FootballPlayerService: Updating player profile: ${player.id}");

      final playerModel = FootballPlayerModel.fromEntity(player);
      await _firestore
          .collection('football_players')
          .doc(player.id)
          .update(playerModel.toJson());

      log("FootballPlayerService: Player profile updated successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error updating player profile: $e');
      return false;
    }
  }

  /// Update only editable fields (excludes statistics)
  Future<bool> updatePlayerEditableFields(FootballPlayerEntity player) async {
    try {
      log(
        "FootballPlayerService: Updating editable fields for player: ${player.id}",
      );

      final updateData = {
        'fullName': player.fullName,
        'nickname': player.nickname,
        'gender': player.gender,
        'age': player.age,
        'position': player.position,
        'preferredFoot': player.preferredFoot,
        'nationality': player.nationality,
        'club': player.club,
        'jerseyNumber': player.jerseyNumber,
        'bio': player.bio,
        'profileImageUrl': player.profileImageUrl,
        'height': player.height,
        'weight': player.weight,
        'bodyType': player.bodyType,
        'phoneNumber': player.phoneNumber,
        'email': player.email,
        'address': player.address,
        'city': player.city,
        'country': player.country,
        'instagramHandle': player.instagramHandle,
        'twitterHandle': player.twitterHandle,
        'facebookProfile': player.facebookProfile,
        'linkedinProfile': player.linkedinProfile,
        'careerStartDate': player.careerStartDate,
        'currentTeam': player.currentTeam,
        'previousTeams': player.previousTeams,
        'playingStyle': player.playingStyle,
        'strengths': player.strengths,
        'areasForImprovement': player.areasForImprovement,
        'preferredPositions': player.preferredPositions,
        'preferredFormation': player.preferredFormation,
        'trainingSchedule': player.trainingSchedule,
        'availability': player.availability,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      await _firestore
          .collection('football_players')
          .doc(player.id)
          .update(updateData);

      log("FootballPlayerService: Player editable fields updated successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error updating editable fields: $e');
      return false;
    }
  }

  /// Update player statistics (auto-calculated fields)
  Future<bool> updatePlayerStatistics(
    String playerId, {
    int? goals,
    int? assists,
    int? matches,
    int? yellowCards,
    int? redCards,
    int? saves,
    int? cleanSheets,
  }) async {
    try {
      log("FootballPlayerService: Updating statistics for player: $playerId");

      // Get current player data
      final currentPlayer = await getPlayerById(playerId);
      if (currentPlayer == null) {
        log("FootballPlayerService: Player not found");
        return false;
      }

      // Calculate new statistics
      final newGoals = (currentPlayer.goals + (goals ?? 0));
      final newAssists = (currentPlayer.assists + (assists ?? 0));
      final newMatches = (currentPlayer.matches + (matches ?? 0));
      final newYellowCards = (currentPlayer.yellowCards + (yellowCards ?? 0));
      final newRedCards = (currentPlayer.redCards + (redCards ?? 0));
      final newSaves = (currentPlayer.saves + (saves ?? 0));
      final newCleanSheets = (currentPlayer.cleanSheets + (cleanSheets ?? 0));

      // Calculate derived statistics
      final newGoalsPerMatch = newMatches > 0 ? newGoals / newMatches : 0.0;
      final newAvgPoints = newMatches > 0
          ? (newGoals * 2.0 +
                    newAssists * 1.5 -
                    newYellowCards * 0.5 -
                    newRedCards * 2.0) /
                newMatches
          : 0.0;
      final newTotalPoints =
          (newGoals * 2 +
                  newAssists * 1.5 -
                  newYellowCards * 0.5 -
                  newRedCards * 2)
              .round();

      final updateData = {
        'goals': newGoals,
        'assists': newAssists,
        'matches': newMatches,
        'yellowCards': newYellowCards,
        'redCards': newRedCards,
        'saves': newSaves,
        'cleanSheets': newCleanSheets,
        'goalsPerMatch': newGoalsPerMatch,
        'avgPoints': newAvgPoints,
        'totalPoints': newTotalPoints,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      await _firestore
          .collection('football_players')
          .doc(playerId)
          .update(updateData);

      log("FootballPlayerService: Player statistics updated successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error updating statistics: $e');
      return false;
    }
  }

  /// Add achievement to player
  Future<bool> addAchievement(String playerId, String achievement) async {
    try {
      log("FootballPlayerService: Adding achievement to player: $playerId");

      final docRef = _firestore.collection('football_players').doc(playerId);
      await docRef.update({
        'achievements': FieldValue.arrayUnion([achievement]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      log("FootballPlayerService: Achievement added successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error adding achievement: $e');
      return false;
    }
  }

  /// Add award to player
  Future<bool> addAward(String playerId, String award) async {
    try {
      log("FootballPlayerService: Adding award to player: $playerId");

      final docRef = _firestore.collection('football_players').doc(playerId);
      await docRef.update({
        'awards': FieldValue.arrayUnion([award]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      log("FootballPlayerService: Award added successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error adding award: $e');
      return false;
    }
  }

  /// Add tournament participation
  Future<bool> addTournament(String playerId, String tournament) async {
    try {
      log("FootballPlayerService: Adding tournament to player: $playerId");

      final docRef = _firestore.collection('football_players').doc(playerId);
      await docRef.update({
        'tournaments': FieldValue.arrayUnion([tournament]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      log("FootballPlayerService: Tournament added successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error adding tournament: $e');
      return false;
    }
  }

  /// Search players by position
  Future<List<FootballPlayerEntity>> searchPlayersByPosition(
    String position,
  ) async {
    try {
      log("FootballPlayerService: Searching players by position: $position");

      final query = await _firestore
          .collection('football_players')
          .where('position', isEqualTo: position)
          .where('isActive', isEqualTo: true)
          .get();

      final players = query.docs
          .map((doc) => FootballPlayerModel.fromJson(doc.data()).toEntity())
          .toList();

      log(
        "FootballPlayerService: Found ${players.length} players with position: $position",
      );
      return players;
    } catch (e) {
      log('FootballPlayerService: Error searching players by position: $e');
      return [];
    }
  }

  /// Search players by club
  Future<List<FootballPlayerEntity>> searchPlayersByClub(String club) async {
    try {
      log("FootballPlayerService: Searching players by club: $club");

      final query = await _firestore
          .collection('football_players')
          .where('club', isEqualTo: club)
          .where('isActive', isEqualTo: true)
          .get();

      final players = query.docs
          .map((doc) => FootballPlayerModel.fromJson(doc.data()).toEntity())
          .toList();

      log(
        "FootballPlayerService: Found ${players.length} players from club: $club",
      );
      return players;
    } catch (e) {
      log('FootballPlayerService: Error searching players by club: $e');
      return [];
    }
  }

  /// Get top players by statistics
  Future<List<FootballPlayerEntity>> getTopPlayers({
    String? sortBy = 'goals',
    int limit = 10,
  }) async {
    try {
      log("FootballPlayerService: Getting top players by $sortBy");

      final query = await _firestore
          .collection('football_players')
          .where('isActive', isEqualTo: true)
          .orderBy(sortBy!, descending: true)
          .limit(limit)
          .get();

      final players = query.docs
          .map((doc) => FootballPlayerModel.fromJson(doc.data()).toEntity())
          .toList();

      log("FootballPlayerService: Found ${players.length} top players");
      return players;
    } catch (e) {
      log('FootballPlayerService: Error getting top players: $e');
      return [];
    }
  }

  /// Listen to player profile changes in real-time
  Stream<FootballPlayerEntity?> listenToPlayer(String playerId) {
    return _firestore
        .collection('football_players')
        .doc(playerId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return FootballPlayerModel.fromJson(doc.data()!).toEntity();
          }
          return null;
        });
  }

  /// Listen to player profile changes by user ID
  Stream<FootballPlayerEntity?> listenToPlayerByUserId(String userId) {
    return _firestore
        .collection('football_players')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return FootballPlayerModel.fromJson(
              snapshot.docs.first.data(),
            ).toEntity();
          }
          return null;
        });
  }

  /// Delete player profile
  Future<bool> deletePlayerProfile(String playerId) async {
    try {
      log("FootballPlayerService: Deleting player profile: $playerId");

      await _firestore.collection('football_players').doc(playerId).delete();

      log("FootballPlayerService: Player profile deleted successfully");
      return true;
    } catch (e) {
      log('FootballPlayerService: Error deleting player profile: $e');
      return false;
    }
  }

  /// Get player statistics summary
  Future<Map<String, dynamic>> getPlayerStatsSummary(String playerId) async {
    try {
      log("FootballPlayerService: Getting stats summary for player: $playerId");

      final player = await getPlayerById(playerId);
      if (player == null) {
        return {};
      }

      final stats = {
        'goals': player.goals,
        'assists': player.assists,
        'matches': player.matches,
        'yellowCards': player.yellowCards,
        'redCards': player.redCards,
        'saves': player.saves,
        'cleanSheets': player.cleanSheets,
        'goalsPerMatch': player.goalsPerMatch,
        'avgPoints': player.avgPoints,
        'totalPoints': player.totalPoints,
        'performanceRating': player.performanceRating,
        'careerDuration': player.careerDuration,
        'isGoalkeeper': player.isGoalkeeper,
        'awardsCount': player.awards.length,
        'tournamentsCount': player.tournaments.length,
        'achievementsCount': player.achievements.length,
      };

      log("FootballPlayerService: Stats summary retrieved successfully");
      return stats;
    } catch (e) {
      log('FootballPlayerService: Error getting stats summary: $e');
      return {};
    }
  }
}
