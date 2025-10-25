import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/widgets.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/validation_handler.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            log(state.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        48.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40.h),

                      // Logo and Title
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/app_logo.png',
                            width: 120.r,
                            height: 120.r,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'app.name'.tr(),
                            style: AppTextStyles.displayMedium,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'auth.login'.tr(),
                            style: AppTextStyles.headlineMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: 48.h),

                      // Email Field
                      AppTextField(
                        label: 'auth.email'.tr(),
                        hint: 'auth.email'.tr(),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          final error = ValidationHandler.validateEmail(value);
                          return error?.tr();
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      AppTextField(
                        label: 'auth.password'.tr(),
                        hint: 'auth.password'.tr(),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outlined),
                      ),
                      SizedBox(height: 8.h),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text('auth.forgotPassword'.tr()),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Login Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            text: 'auth.login'.tr(),
                            onPressed: state is AuthLoading
                                ? null
                                : _handleLogin,
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text('auth.or'.tr()),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Google Sign In Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            text: 'auth.signInWithGoogle'.tr(),
                            onPressed: state is AuthLoading
                                ? null
                                : _handleGoogleSignIn,
                            isLoading: state is AuthLoading,
                            isOutlined: true,
                            icon: Icons.g_mobiledata,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('auth.dontHaveAccount'.tr()),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text('auth.signup'.tr()),
                          ),
                        ],
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(SignInWithGoogleRequested());
  }
}
