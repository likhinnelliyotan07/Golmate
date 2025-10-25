import 'package:equatable/equatable.dart';

/// Entity representing a football player with comprehensive profile data
class FootballPlayerEntity extends Equatable {
  final String id;
  final String userId; // Reference to the user account

  // Basic Information (Editable)
  final String? fullName;
  final String? nickname;
  final String? gender;
  final int? age;
  final String? position;
  final String? preferredFoot;
  final String? nationality;
  final String? club;
  final String? jerseyNumber;
  final String? bio;
  final String? profileImageUrl;

  // Physical Attributes (Editable)
  final double? height; // in cm
  final double? weight; // in kg
  final String? bodyType;

  // Contact Information (Editable)
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? country;

  // Social Media (Editable)
  final String? instagramHandle;
  final String? twitterHandle;
  final String? facebookProfile;
  final String? linkedinProfile;

  // Statistics (Auto-calculated, not manually editable)
  final int goals; // Total goals scored
  final int assists; // Total assists
  final int matches; // Total matches played
  final int yellowCards; // Total yellow cards
  final int redCards; // Total red cards
  final int saves; // Total saves (for goalkeepers)
  final int cleanSheets; // Clean sheets (for goalkeepers)
  final double goalsPerMatch; // Goals per match ratio
  final double avgPoints; // Average points per match
  final int totalPoints; // Total points earned

  // Achievements (Auto-calculated)
  final List<String> awards; // List of awards won
  final List<String> tournaments; // List of tournaments participated
  final List<String> achievements; // List of achievements unlocked

  // Career Information (Editable)
  final String? careerStartDate;
  final String? currentTeam;
  final List<String> previousTeams;
  final String? playingStyle;
  final String? strengths;
  final String? areasForImprovement;

  // Preferences (Editable)
  final List<String> preferredPositions;
  final String? preferredFormation;
  final String? trainingSchedule;
  final String? availability;

  // System Fields
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isVerified;
  final String? verificationStatus;

  const FootballPlayerEntity({
    required this.id,
    required this.userId,
    this.fullName,
    this.nickname,
    this.gender,
    this.age,
    this.position,
    this.preferredFoot,
    this.nationality,
    this.club,
    this.jerseyNumber,
    this.bio,
    this.profileImageUrl,
    this.height,
    this.weight,
    this.bodyType,
    this.phoneNumber,
    this.email,
    this.address,
    this.city,
    this.country,
    this.instagramHandle,
    this.twitterHandle,
    this.facebookProfile,
    this.linkedinProfile,
    this.goals = 0,
    this.assists = 0,
    this.matches = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.saves = 0,
    this.cleanSheets = 0,
    this.goalsPerMatch = 0.0,
    this.avgPoints = 0.0,
    this.totalPoints = 0,
    this.awards = const [],
    this.tournaments = const [],
    this.achievements = const [],
    this.careerStartDate,
    this.currentTeam,
    this.previousTeams = const [],
    this.playingStyle,
    this.strengths,
    this.areasForImprovement,
    this.preferredPositions = const [],
    this.preferredFormation,
    this.trainingSchedule,
    this.availability,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isVerified = false,
    this.verificationStatus,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    nickname,
    gender,
    age,
    position,
    preferredFoot,
    nationality,
    club,
    jerseyNumber,
    bio,
    profileImageUrl,
    height,
    weight,
    bodyType,
    phoneNumber,
    email,
    address,
    city,
    country,
    instagramHandle,
    twitterHandle,
    facebookProfile,
    linkedinProfile,
    goals,
    assists,
    matches,
    yellowCards,
    redCards,
    saves,
    cleanSheets,
    goalsPerMatch,
    avgPoints,
    totalPoints,
    awards,
    tournaments,
    achievements,
    careerStartDate,
    currentTeam,
    previousTeams,
    playingStyle,
    strengths,
    areasForImprovement,
    preferredPositions,
    preferredFormation,
    trainingSchedule,
    availability,
    createdAt,
    updatedAt,
    isActive,
    isVerified,
    verificationStatus,
  ];

  FootballPlayerEntity copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? nickname,
    String? gender,
    int? age,
    String? position,
    String? preferredFoot,
    String? nationality,
    String? club,
    String? jerseyNumber,
    String? bio,
    String? profileImageUrl,
    double? height,
    double? weight,
    String? bodyType,
    String? phoneNumber,
    String? email,
    String? address,
    String? city,
    String? country,
    String? instagramHandle,
    String? twitterHandle,
    String? facebookProfile,
    String? linkedinProfile,
    int? goals,
    int? assists,
    int? matches,
    int? yellowCards,
    int? redCards,
    int? saves,
    int? cleanSheets,
    double? goalsPerMatch,
    double? avgPoints,
    int? totalPoints,
    List<String>? awards,
    List<String>? tournaments,
    List<String>? achievements,
    String? careerStartDate,
    String? currentTeam,
    List<String>? previousTeams,
    String? playingStyle,
    String? strengths,
    String? areasForImprovement,
    List<String>? preferredPositions,
    String? preferredFormation,
    String? trainingSchedule,
    String? availability,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isVerified,
    String? verificationStatus,
  }) {
    return FootballPlayerEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      position: position ?? this.position,
      preferredFoot: preferredFoot ?? this.preferredFoot,
      nationality: nationality ?? this.nationality,
      club: club ?? this.club,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bodyType: bodyType ?? this.bodyType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      facebookProfile: facebookProfile ?? this.facebookProfile,
      linkedinProfile: linkedinProfile ?? this.linkedinProfile,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      matches: matches ?? this.matches,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      saves: saves ?? this.saves,
      cleanSheets: cleanSheets ?? this.cleanSheets,
      goalsPerMatch: goalsPerMatch ?? this.goalsPerMatch,
      avgPoints: avgPoints ?? this.avgPoints,
      totalPoints: totalPoints ?? this.totalPoints,
      awards: awards ?? this.awards,
      tournaments: tournaments ?? this.tournaments,
      achievements: achievements ?? this.achievements,
      careerStartDate: careerStartDate ?? this.careerStartDate,
      currentTeam: currentTeam ?? this.currentTeam,
      previousTeams: previousTeams ?? this.previousTeams,
      playingStyle: playingStyle ?? this.playingStyle,
      strengths: strengths ?? this.strengths,
      areasForImprovement: areasForImprovement ?? this.areasForImprovement,
      preferredPositions: preferredPositions ?? this.preferredPositions,
      preferredFormation: preferredFormation ?? this.preferredFormation,
      trainingSchedule: trainingSchedule ?? this.trainingSchedule,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  @override
  String toString() {
    return 'FootballPlayerEntity(id: $id, fullName: $fullName, position: $position, club: $club)';
  }

  /// Get display name (fullName or nickname or "Unknown Player")
  String get displayName {
    return fullName ?? nickname ?? 'Unknown Player';
  }

  /// Get position with fallback
  String get displayPosition {
    return position ?? 'Not specified';
  }

  /// Get club with fallback
  String get displayClub {
    return club ?? currentTeam ?? 'Free agent';
  }

  /// Check if player is a goalkeeper
  bool get isGoalkeeper {
    return position?.toLowerCase() == 'goalkeeper' ||
        position?.toLowerCase() == 'gk' ||
        position?.toLowerCase() == 'keeper';
  }

  /// Get performance rating based on statistics
  double get performanceRating {
    if (matches == 0) return 0.0;

    double rating = 0.0;

    // Goals contribution (for outfield players)
    if (!isGoalkeeper) {
      rating += (goals * 2.0) + (assists * 1.5);
    }

    // Goalkeeper specific
    if (isGoalkeeper) {
      rating += (saves * 0.5) + (cleanSheets * 3.0);
    }

    // Discipline (negative impact for cards)
    rating -= (yellowCards * 0.5) + (redCards * 2.0);

    // Normalize by matches
    rating = rating / matches;

    // Cap at 10.0
    return rating > 10.0 ? 10.0 : rating;
  }

  /// Get career duration in years
  int get careerDuration {
    if (careerStartDate == null) return 0;

    try {
      final startDate = DateTime.parse(careerStartDate!);
      final now = DateTime.now();
      return now.year - startDate.year;
    } catch (e) {
      return 0;
    }
  }
}
