import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/widgets.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/validation_handler.dart';
import '../home/home_screen.dart';

class ProfileCompletionScreen extends StatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(),

                            // Welcome Animation
                            _buildWelcomeSection(),

                            SizedBox(height: 48.h),

                            // Form Fields
                            _buildFormFields(),

                            SizedBox(height: 32.h),

                            // Complete Profile Button
                            _buildCompleteButton(),

                            SizedBox(height: 16.h),

                            // Skip Button
                            _buildSkipButton(),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: Icon(
            Icons.person_add,
            size: 50.w,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'profile.welcome'.tr(),
          style: AppTextStyles.displaySmall.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'profile.completionMessage'.tr(),
          style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Name Field
        AppTextField(
          label: 'profile.fullName'.tr(),
          hint: 'profile.fullNameHint'.tr(),
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) {
            final error = ValidationHandler.validateName(value);
            return error?.tr();
          },
        ),
        SizedBox(height: 16.h),

        // Phone Field
        AppTextField(
          label: 'profile.phoneNumber'.tr(),
          hint: 'profile.phoneNumberHint'.tr(),
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final error = ValidationHandler.validatePhone(value);
              return error?.tr();
            }
            return null; // Phone is optional
          },
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AppButton(
          text: 'profile.completeProfile'.tr(),
          onPressed: state is AuthLoading ? null : _handleCompleteProfile,
          isLoading: state is AuthLoading,
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _handleSkip,
      child: Text(
        'profile.skipForNow'.tr(),
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
      ),
    );
  }

  void _handleCompleteProfile() {
    if (_formKey.currentState!.validate()) {
      // Update user profile with additional information
      // For now, we'll just navigate to home screen
      // In a real app, you'd update the user profile here
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _handleSkip() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
