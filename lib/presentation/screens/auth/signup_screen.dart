import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/widgets.dart';
import '../../../core/utils/validation_handler.dart';
import 'login_screen.dart';
import 'profile_completion_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth.signup'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileCompletionScreen(),
              ),
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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'auth.signup'.tr(),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account to get started',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Name Field
                    AppTextField(
                      label: 'auth.name'.tr(),
                      hint: 'auth.name'.tr(),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: const Icon(Icons.person_outlined),
                      validator: (value) {
                        final error = ValidationHandler.validateName(value);
                        return error?.tr();
                      },
                    ),
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 16),

                    // Password Field
                    AppTextField(
                      label: 'auth.password'.tr(),
                      hint: 'auth.password'.tr(),
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      validator: (value) {
                        final error = ValidationHandler.validatePassword(value);
                        return error?.tr();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    AppTextField(
                      label: 'auth.confirmPassword'.tr(),
                      hint: 'auth.confirmPassword'.tr(),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      validator: (value) {
                        final error = ValidationHandler.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        );
                        return error?.tr();
                      },
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          text: 'auth.signup'.tr(),
                          onPressed: state is AuthLoading
                              ? null
                              : _handleSignUp,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('auth.or'.tr()),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Google Sign Up Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AppButton(
                          text: 'auth.signUpWithGoogle'.tr(),
                          onPressed: state is AuthLoading
                              ? null
                              : _handleGoogleSignUp,
                          isLoading: state is AuthLoading,
                          isOutlined: true,
                          icon: Icons.g_mobiledata,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('auth.alreadyHaveAccount'.tr()),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text('auth.login'.tr()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpWithEmailRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        ),
      );
    }
  }

  void _handleGoogleSignUp() {
    context.read<AuthBloc>().add(SignInWithGoogleRequested());
  }
}
