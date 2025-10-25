import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/user_service.dart';
import '../../core/services/football_player_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/football_player_entity.dart';
import '../../core/constants/app_text_styles.dart';
import 'app_card.dart';

/// Widget that demonstrates fetching user data from Firestore
class UserProfileWidget extends StatefulWidget {
  final String userId;

  const UserProfileWidget({super.key, required this.userId});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final UserService _userService = sl<UserService>();
  final FootballPlayerService _playerService = sl<FootballPlayerService>();
  UserEntity? _user;
  FootballPlayerEntity? _player;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      log("UserProfileWidget: Fetching user data for ID: ${widget.userId}");

      // Fetch both user and player data
      final futures = await Future.wait([
        _userService.getUserById(widget.userId),
        _playerService.getPlayerByUserId(widget.userId),
      ]);

      final user = futures[0] as UserEntity?;
      final player = futures[1] as FootballPlayerEntity?;

      if (mounted) {
        setState(() {
          _user = user;
          _player = player;
          _isLoading = false;
        });

        if (user != null) {
          log("UserProfileWidget: User data fetched successfully");
        } else {
          log("UserProfileWidget: User not found in Firestore");
          setState(() {
            _error = 'User not found';
          });
        }
      }
    } catch (e) {
      log('UserProfileWidget: Error fetching user data: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to fetch user data: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Refresh user data
  Future<void> _refreshUserData() async {
    await _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 24.w,
              ),
              SizedBox(width: 8.w),
              Text(
                'User Profile (From Firestore)',
                style: AppTextStyles.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: _refreshUserData,
                icon: Icon(Icons.refresh, size: 20.w),
                tooltip: 'Refresh user data',
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            _buildErrorWidget()
          else if (_user != null)
            _buildUserData()
          else
            _buildNoDataWidget(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      children: [
        Icon(Icons.error_outline, color: Colors.red, size: 48.w),
        SizedBox(height: 8.h),
        Text(
          _error!,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        ElevatedButton(onPressed: _refreshUserData, child: const Text('Retry')),
      ],
    );
  }

  Widget _buildNoDataWidget() {
    return Column(
      children: [
        Icon(Icons.person_off, color: Colors.grey, size: 48.w),
        SizedBox(height: 8.h),
        Text(
          'No user data found',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUserData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Avatar
        Center(
          child: CircleAvatar(
            radius: 40.r,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: _user!.profileImageUrl != null
                ? NetworkImage(_user!.profileImageUrl!)
                : null,
            child: _user!.profileImageUrl == null
                ? Text(
                    _user!.name?.substring(0, 1).toUpperCase() ??
                        _user!.email.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(height: 16.h),

        // User Information
        Column(
          children: [
            _buildInfoRow('ID', _user!.id),
            _buildInfoRow('Email', _user!.email),
            if (_user!.name != null) _buildInfoRow('Name', _user!.name!),
            if (_user!.phone != null) _buildInfoRow('Phone', _user!.phone!),
            _buildInfoRow(
              'Email Verified',
              _user!.isEmailVerified ? 'Yes' : 'No',
            ),
            _buildInfoRow(
              'Phone Verified',
              _user!.isPhoneVerified ? 'Yes' : 'No',
            ),
            _buildInfoRow('Created At', _formatDate(_user!.createdAt)),
            _buildInfoRow('Updated At', _formatDate(_user!.updatedAt)),
          ],
        ),

        // Football Player Information (if available)
        if (_player != null) ...[
          SizedBox(height: 24.h),
          _buildFootballPlayerSection(),
        ],

        SizedBox(height: 16.h),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _refreshUserData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _showUserStats,
                icon: const Icon(Icons.analytics),
                label: const Text('Stats'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFootballPlayerSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports_soccer, color: Colors.blue[700], size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Football Player Profile',
                style: AppTextStyles.titleSmall.copyWith(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Player Basic Info
          if (_player!.fullName != null)
            _buildInfoRow('Full Name', _player!.fullName!),
          if (_player!.position != null)
            _buildInfoRow('Position', _player!.position!),
          if (_player!.age != null)
            _buildInfoRow('Age', _player!.age.toString()),
          if (_player!.club != null) _buildInfoRow('Club', _player!.club!),
          if (_player!.nationality != null)
            _buildInfoRow('Nationality', _player!.nationality!),
          if (_player!.preferredFoot != null)
            _buildInfoRow('Preferred Foot', _player!.preferredFoot!),

          SizedBox(height: 12.h),

          // Player Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Goals', _player!.goals.toString()),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatCard('Assists', _player!.assists.toString()),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Matches', _player!.matches.toString()),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildStatCard(
                  'Rating',
                  _player!.performanceRating.toStringAsFixed(1),
                ),
              ),
            ],
          ),

          if (_player!.isGoalkeeper) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Saves', _player!.saves.toString()),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatCard(
                    'Clean Sheets',
                    _player!.cleanSheets.toString(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.blue[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Show user statistics
  Future<void> _showUserStats() async {
    try {
      final stats = await _userService.getUserStats(widget.userId);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('User Statistics'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Goals: ${stats['totalGoals'] ?? 0}'),
                Text('Total Achievements: ${stats['totalAchievements'] ?? 0}'),
                if (stats['userCreatedAt'] != null)
                  Text('Member Since: ${stats['userCreatedAt']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log('Error fetching user stats: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
