import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/football_player_service.dart';
import '../../domain/entities/football_player_entity.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_colors.dart';
import '../screens/profile/edit_profile_screen.dart';

class ProfileDrawer extends StatefulWidget {
  final String userId;

  const ProfileDrawer({super.key, required this.userId});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  final FootballPlayerService _playerService = sl<FootballPlayerService>();
  FootballPlayerEntity? _player;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerProfile();
  }

  Future<void> _loadPlayerProfile() async {
    try {
      final player = await _playerService.getPlayerByUserId(widget.userId);
      if (mounted) {
        setState(() {
          _player = player;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error loading player profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _player != null
                ? _buildPlayerProfile()
                : _buildNoProfile(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    backgroundImage: _player?.profileImageUrl != null
                        ? NetworkImage(_player!.profileImageUrl!)
                        : null,
                    child: _player?.profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 30.r,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _player?.displayName ?? 'Player',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _player?.displayPosition ?? 'Position not set',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        if (_player?.club != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            _player!.club!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (_player != null) _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatItem('Goals', _player!.goals.toString()),
        SizedBox(width: 16.w),
        _buildStatItem('Matches', _player!.matches.toString()),
        SizedBox(width: 16.w),
        _buildStatItem('Rating', _player!.performanceRating.toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildPlayerProfile() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildProfileSection(),
        _buildStatisticsSection(),
        _buildAchievementsSection(),
        _buildMenuItems(),
      ],
    );
  }

  Widget _buildNoProfile() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer, size: 64.w, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No Player Profile',
              style: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              'Create your football player profile to get started',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _createProfile,
              icon: const Icon(Icons.add),
              label: Text('Create Profile'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text('Profile Info'.tr(), style: AppTextStyles.titleSmall),
              const Spacer(),
              TextButton.icon(
                onPressed: _editProfile,
                icon: Icon(Icons.edit, size: 16.w),
                label: Text('Edit'.tr()),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('Full Name', _player!.fullName ?? 'Not set'),
          _buildInfoRow('Age', _player!.age?.toString() ?? 'Not set'),
          _buildInfoRow('Nationality', _player!.nationality ?? 'Not set'),
          _buildInfoRow('Preferred Foot', _player!.preferredFoot ?? 'Not set'),
          if (_player!.height != null)
            _buildInfoRow(
              'Height',
              '${_player!.height!.toStringAsFixed(0)} cm',
            ),
          if (_player!.weight != null)
            _buildInfoRow(
              'Weight',
              '${_player!.weight!.toStringAsFixed(0)} kg',
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
              Icon(Icons.analytics, color: Colors.blue[700]),
              SizedBox(width: 8.w),
              Text('Statistics'.tr(), style: AppTextStyles.titleSmall),
            ],
          ),
          SizedBox(height: 12.h),
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

  Widget _buildAchievementsSection() {
    if (_player!.achievements.isEmpty &&
        _player!.awards.isEmpty &&
        _player!.tournaments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[700]),
              SizedBox(width: 8.w),
              Text('Achievements'.tr(), style: AppTextStyles.titleSmall),
            ],
          ),
          SizedBox(height: 12.h),
          if (_player!.awards.isNotEmpty) ...[
            Text(
              'Awards (${_player!.awards.length})'.tr(),
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 4.w,
              children: _player!.awards
                  .take(3)
                  .map(
                    (award) => Chip(
                      label: Text(award, style: AppTextStyles.bodySmall),
                      backgroundColor: Colors.amber[100],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8.h),
          ],
          if (_player!.tournaments.isNotEmpty) ...[
            Text(
              'Tournaments (${_player!.tournaments.length})'.tr(),
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 4.w,
              children: _player!.tournaments
                  .take(3)
                  .map(
                    (tournament) => Chip(
                      label: Text(tournament, style: AppTextStyles.bodySmall),
                      backgroundColor: Colors.amber[100],
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text('Edit Profile'.tr()),
          onTap: _editProfile,
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: Text('View Statistics'.tr()),
          onTap: _viewStatistics,
        ),
        ListTile(
          leading: const Icon(Icons.emoji_events),
          title: Text('Achievements'.tr()),
          onTap: _viewAchievements,
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text('Settings'.tr()),
          onTap: _openSettings,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.help),
          title: Text('Help & Support'.tr()),
          onTap: _openHelp,
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: Text('About'.tr()),
          onTap: _openAbout,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.sports_soccer, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            'Goal Mate',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodySmall)),
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

  void _createProfile() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(userId: widget.userId),
          ),
        )
        .then((_) {
          _loadPlayerProfile(); // Refresh profile after editing
        });
  }

  void _editProfile() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              userId: widget.userId,
              initialPlayer: _player,
            ),
          ),
        )
        .then((_) {
          _loadPlayerProfile(); // Refresh profile after editing
        });
  }

  void _viewStatistics() {
    // TODO: Navigate to statistics screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Statistics screen coming soon!'.tr())),
    );
  }

  void _viewAchievements() {
    // TODO: Navigate to achievements screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Achievements screen coming soon!'.tr())),
    );
  }

  void _openSettings() {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings screen coming soon!'.tr())),
    );
  }

  void _openHelp() {
    // TODO: Navigate to help screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Help screen coming soon!'.tr())));
  }

  void _openAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Goal Mate'.tr()),
        content: Text('Goal Mate - Your football companion app'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'.tr()),
          ),
        ],
      ),
    );
  }
}
