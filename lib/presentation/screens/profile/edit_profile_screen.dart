import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/services/football_player_service.dart';
import '../../../domain/entities/football_player_entity.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_card.dart';

class EditProfileScreen extends StatefulWidget {
  final FootballPlayerEntity? initialPlayer;
  final String userId;

  const EditProfileScreen({
    super.key,
    this.initialPlayer,
    required this.userId,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FootballPlayerService _playerService = sl<FootballPlayerService>();
  final _formKey = GlobalKey<FormState>();

  late FootballPlayerEntity _player;
  final bool _isLoading = false;
  bool _isSaving = false;

  // Controllers for editable fields
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _jerseyNumberController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _instagramController = TextEditingController();
  final _twitterController = TextEditingController();
  final _facebookController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _careerStartController = TextEditingController();
  final _currentTeamController = TextEditingController();
  final _playingStyleController = TextEditingController();
  final _strengthsController = TextEditingController();
  final _areasForImprovementController = TextEditingController();
  final _trainingScheduleController = TextEditingController();
  final _availabilityController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedPosition;
  String? _selectedPreferredFoot;
  String? _selectedNationality;
  String? _selectedBodyType;
  String? _selectedPreferredFormation;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.initialPlayer != null) {
      _player = widget.initialPlayer!;
    } else {
      _player = FootballPlayerEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        userId: widget.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    _populateControllers();
  }

  void _populateControllers() {
    _fullNameController.text = _player.fullName ?? '';
    _nicknameController.text = _player.nickname ?? '';
    _ageController.text = _player.age?.toString() ?? '';
    _jerseyNumberController.text = _player.jerseyNumber ?? '';
    _bioController.text = _player.bio ?? '';
    _phoneNumberController.text = _player.phoneNumber ?? '';
    _emailController.text = _player.email ?? '';
    _addressController.text = _player.address ?? '';
    _cityController.text = _player.city ?? '';
    _countryController.text = _player.country ?? '';
    _instagramController.text = _player.instagramHandle ?? '';
    _twitterController.text = _player.twitterHandle ?? '';
    _facebookController.text = _player.facebookProfile ?? '';
    _linkedinController.text = _player.linkedinProfile ?? '';
    _heightController.text = _player.height?.toString() ?? '';
    _weightController.text = _player.weight?.toString() ?? '';
    _careerStartController.text = _player.careerStartDate ?? '';
    _currentTeamController.text = _player.currentTeam ?? '';
    _playingStyleController.text = _player.playingStyle ?? '';
    _strengthsController.text = _player.strengths ?? '';
    _areasForImprovementController.text = _player.areasForImprovement ?? '';
    _trainingScheduleController.text = _player.trainingSchedule ?? '';
    _availabilityController.text = _player.availability ?? '';

    _selectedGender = _player.gender;
    _selectedPosition = _player.position;
    _selectedPreferredFoot = _player.preferredFoot;
    _selectedNationality = _player.nationality;
    _selectedBodyType = _player.bodyType;
    _selectedPreferredFormation = _player.preferredFormation;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    _jerseyNumberController.dispose();
    _bioController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _careerStartController.dispose();
    _currentTeamController.dispose();
    _playingStyleController.dispose();
    _strengthsController.dispose();
    _areasForImprovementController.dispose();
    _trainingScheduleController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'.tr()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    SizedBox(height: 24.h),
                    _buildPhysicalAttributesSection(),
                    SizedBox(height: 24.h),
                    _buildContactInfoSection(),
                    SizedBox(height: 24.h),
                    _buildSocialMediaSection(),
                    SizedBox(height: 24.h),
                    _buildCareerInfoSection(),
                    SizedBox(height: 24.h),
                    _buildPreferencesSection(),
                    SizedBox(height: 32.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBasicInfoSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _fullNameController,
            label: 'Full Name'.tr(),
            hint: 'Enter your full name'.tr(),
            validator: (value) =>
                value?.isEmpty == true ? 'Full name is required'.tr() : null,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _nicknameController,
            label: 'Nickname'.tr(),
            hint: 'Enter your nickname'.tr(),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: InputDecoration(
                    labelText: 'Gender'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.tr()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField(
                  controller: _ageController,
                  label: 'Age'.tr(),
                  hint: 'Age',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedPosition,
                  decoration: InputDecoration(
                    labelText: 'Position'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items:
                      [
                        'Goalkeeper',
                        'Defender',
                        'Midfielder',
                        'Forward',
                        'Left Back',
                        'Right Back',
                        'Center Back',
                        'Left Midfielder',
                        'Right Midfielder',
                        'Center Midfielder',
                        'Left Winger',
                        'Right Winger',
                        'Striker',
                        'Attacking Midfielder',
                        'Defensive Midfielder',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr()),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPosition = newValue;
                    });
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedPreferredFoot,
                  decoration: InputDecoration(
                    labelText: 'Preferred Foot'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: ['Left', 'Right', 'Both'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.tr()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPreferredFoot = newValue;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _jerseyNumberController,
                  label: 'Jersey Number'.tr(),
                  hint: 'Number',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField(
                  controller: _currentTeamController,
                  label: 'Current Team'.tr(),
                  hint: 'Team name',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _bioController,
            label: 'Bio'.tr(),
            hint: 'Tell us about yourself'.tr(),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalAttributesSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Physical Attributes'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _heightController,
                  label: 'Height (cm)'.tr(),
                  hint: '180',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField(
                  controller: _weightController,
                  label: 'Weight (kg)'.tr(),
                  hint: '75',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          DropdownButtonFormField<String>(
            initialValue: _selectedBodyType,
            decoration: InputDecoration(
              labelText: 'Body Type'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            items: ['Slim', 'Athletic', 'Muscular', 'Stocky', 'Tall', 'Short']
                .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.tr()),
                  );
                })
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedBodyType = newValue;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _phoneNumberController,
            label: 'Phone Number'.tr(),
            hint: '+1234567890',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _emailController,
            label: 'Email'.tr(),
            hint: 'email@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _addressController,
            label: 'Address'.tr(),
            hint: 'Street address',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _cityController,
                  label: 'City'.tr(),
                  hint: 'City',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField(
                  controller: _countryController,
                  label: 'Country'.tr(),
                  hint: 'Country',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Social Media'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _instagramController,
            label: 'Instagram Handle'.tr(),
            hint: '@username',
            prefixIcon: const Icon(Icons.camera_alt),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _twitterController,
            label: 'Twitter Handle'.tr(),
            hint: '@username',
            prefixIcon: const Icon(Icons.alternate_email),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _facebookController,
            label: 'Facebook Profile'.tr(),
            hint: 'facebook.com/username',
            prefixIcon: const Icon(Icons.facebook),
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _linkedinController,
            label: 'LinkedIn Profile'.tr(),
            hint: 'linkedin.com/in/username',
            prefixIcon: const Icon(Icons.work),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerInfoSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Career Information'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _careerStartController,
            label: 'Career Start Date'.tr(),
            hint: 'YYYY-MM-DD',
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _playingStyleController,
            label: 'Playing Style'.tr(),
            hint: 'Describe your playing style',
            maxLines: 2,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _strengthsController,
            label: 'Strengths'.tr(),
            hint: 'What are your main strengths?',
            maxLines: 2,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _areasForImprovementController,
            label: 'Areas for Improvement'.tr(),
            hint: 'What areas would you like to improve?',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preferences'.tr(), style: AppTextStyles.titleMedium),
          SizedBox(height: 16.h),
          DropdownButtonFormField<String>(
            initialValue: _selectedPreferredFormation,
            decoration: InputDecoration(
              labelText: 'Preferred Formation'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            items:
                [
                  '4-4-2',
                  '4-3-3',
                  '3-5-2',
                  '4-2-3-1',
                  '3-4-3',
                  '5-3-2',
                  '4-1-4-1',
                  '3-4-1-2',
                  '4-5-1',
                  'Flexible',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPreferredFormation = newValue;
              });
            },
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _trainingScheduleController,
            label: 'Training Schedule'.tr(),
            hint: 'When do you usually train?',
          ),
          SizedBox(height: 16.h),
          AppTextField(
            controller: _availabilityController,
            label: 'Availability'.tr(),
            hint: 'When are you available to play?',
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: _isSaving ? null : _saveProfile,
        text: _isSaving ? 'Saving...'.tr() : 'Save Profile'.tr(),
        isLoading: _isSaving,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedPlayer = _player.copyWith(
        fullName: _fullNameController.text.trim().isEmpty
            ? null
            : _fullNameController.text.trim(),
        nickname: _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
        gender: _selectedGender,
        age: int.tryParse(_ageController.text),
        position: _selectedPosition,
        preferredFoot: _selectedPreferredFoot,
        nationality: _selectedNationality,
        jerseyNumber: _jerseyNumberController.text.trim().isEmpty
            ? null
            : _jerseyNumberController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        height: double.tryParse(_heightController.text),
        weight: double.tryParse(_weightController.text),
        bodyType: _selectedBodyType,
        phoneNumber: _phoneNumberController.text.trim().isEmpty
            ? null
            : _phoneNumberController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        instagramHandle: _instagramController.text.trim().isEmpty
            ? null
            : _instagramController.text.trim(),
        twitterHandle: _twitterController.text.trim().isEmpty
            ? null
            : _twitterController.text.trim(),
        facebookProfile: _facebookController.text.trim().isEmpty
            ? null
            : _facebookController.text.trim(),
        linkedinProfile: _linkedinController.text.trim().isEmpty
            ? null
            : _linkedinController.text.trim(),
        careerStartDate: _careerStartController.text.trim().isEmpty
            ? null
            : _careerStartController.text.trim(),
        currentTeam: _currentTeamController.text.trim().isEmpty
            ? null
            : _currentTeamController.text.trim(),
        playingStyle: _playingStyleController.text.trim().isEmpty
            ? null
            : _playingStyleController.text.trim(),
        strengths: _strengthsController.text.trim().isEmpty
            ? null
            : _strengthsController.text.trim(),
        areasForImprovement: _areasForImprovementController.text.trim().isEmpty
            ? null
            : _areasForImprovementController.text.trim(),
        preferredFormation: _selectedPreferredFormation,
        trainingSchedule: _trainingScheduleController.text.trim().isEmpty
            ? null
            : _trainingScheduleController.text.trim(),
        availability: _availabilityController.text.trim().isEmpty
            ? null
            : _availabilityController.text.trim(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.initialPlayer != null) {
        success = await _playerService.updatePlayerEditableFields(
          updatedPlayer,
        );
      } else {
        success = await _playerService.createPlayerProfile(updatedPlayer);
      }

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile saved successfully!'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save profile. Please try again.'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      log('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
