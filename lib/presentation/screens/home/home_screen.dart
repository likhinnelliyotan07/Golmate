import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/widgets.dart';
import '../../widgets/user_profile_widget.dart';
import '../../widgets/profile_drawer.dart';
import '../../../core/constants/app_text_styles.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app.name'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const AppLoadingIndicator(message: 'app.loading');
            }

            if (state is AuthError) {
              return AppErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<AuthBloc>().add(AuthCheckRequested());
                },
              );
            }

            if (state is AuthSuccess) {
              return _buildWelcomeContent(context, state.user);
            }

            return const AppLoadingIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(BuildContext context, user) {
    final userName = (user.name != null && user.name!.trim().isNotEmpty)
        ? user.name!.trim()
        : (user.email != null && user.email!.trim().isNotEmpty)
        ? user.email!.trim().split('@')[0]
        : "User";
    log("user profile image url: ${user.profileImageUrl}");
    return Scaffold(
      drawer: ProfileDrawer(userId: user.id),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(24.w),
          children: [
            // Welcome Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Theme.of(context).primaryColor,
                        backgroundImage: user.profileImageUrl != null
                            ? NetworkImage(user.profileImageUrl!)
                            : null,
                        child: user.profileImageUrl == null
                            ? Text(
                                userName.substring(0, 1).toUpperCase(),
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'home.welcome'.tr()}, ${user.name ?? 'User'}!',
                              style: AppTextStyles.headlineMedium,
                            ),
                            SizedBox(height: 4.h),
                            Text(user.email, style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Welcome to Goal Mate! Start tracking your goals and achieving your dreams.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // User Profile from Firestore
            UserProfileWidget(userId: user.id),
            SizedBox(height: 24.h),

            // Quick Actions
            Text('Quick Actions', style: AppTextStyles.titleLarge),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: AppCard(
                    onTap: () {
                      // TODO: Navigate to goals screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Goals feature coming soon!'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.flag,
                          size: 32.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8.h),
                        Text('Goals', style: AppTextStyles.titleMedium),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppCard(
                    onTap: () {
                      // TODO: Navigate to progress screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Progress tracking coming soon!'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 32.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8.h),
                        Text('Progress', style: AppTextStyles.titleMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: AppCard(
                    onTap: () {
                      // TODO: Navigate to achievements screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Achievements coming soon!'),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 32.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8.h),
                        Text('Achievements', style: AppTextStyles.titleMedium),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 32.w,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8.h),
                        Text('Settings', style: AppTextStyles.titleMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Logout Button
            AppButton(
              text: 'auth.logout'.tr(),
              onPressed: () {
                _showLogoutDialog(context);
              },
              isOutlined: true,
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('auth.logout'.tr()),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('app.cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: Text('auth.logout'.tr()),
            ),
          ],
        );
      },
    );
  }
}
