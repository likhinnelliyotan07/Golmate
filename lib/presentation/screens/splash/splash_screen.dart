import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goal_mate/core/constants/app_text_styles.dart';
import 'package:goal_mate/presentation/bloc/auth/auth_bloc.dart';
import 'package:goal_mate/presentation/bloc/auth/auth_event.dart';
import 'package:goal_mate/presentation/bloc/auth/auth_state.dart';
import 'package:goal_mate/presentation/screens/auth/login_screen.dart';
import 'package:goal_mate/presentation/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _backgroundController;
  bool _isDisposed = false;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _arrowOpacity;
  late Animation<double> _starScale;
  late Animation<double> _textOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _backgroundOpacity;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateAfterDelay();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Tagline animation controller
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _arrowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );

    _starScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    // Background animation
    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn),
    );
  }

  void _startAnimations() {
    if (!_isDisposed) {
      try {
        _backgroundController.forward();
      } catch (e) {
        print('Error starting background animation: $e');
      }
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_isDisposed) {
        try {
          _logoController.forward();
        } catch (e) {
          print('Error starting logo animation: $e');
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!_isDisposed) {
        try {
          _textController.forward();
        } catch (e) {
          print('Error starting text animation: $e');
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!_isDisposed) {
        try {
          _taglineController.forward();
        } catch (e) {
          print('Error starting tagline animation: $e');
        }
      }
    });
  }

  void _navigateAfterDelay() {
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _playExitAnimation();
      }
    });

    // Fallback timeout to ensure navigation happens
    Timer(const Duration(milliseconds: 5000), () {
      if (mounted && !_isDisposed) {
        print('Splash: Fallback timeout - forcing navigation to LoginScreen');
        // Force navigation to login screen if still on splash
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  void _playExitAnimation() async {
    print('Splash: Starting exit animation');

    // Check if controllers are still active before animating
    if (!_isDisposed) {
      try {
        _logoController.reverse();
      } catch (e) {
        print('Error reversing logo animation: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_isDisposed) {
      try {
        _textController.reverse();
      } catch (e) {
        print('Error reversing text animation: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_isDisposed) {
      try {
        _taglineController.reverse();
      } catch (e) {
        print('Error reversing tagline animation: $e');
      }
    }
    await Future.delayed(const Duration(milliseconds: 200));

    if (!_isDisposed) {
      try {
        _backgroundController.reverse();
      } catch (e) {
        print('Error reversing background animation: $e');
      }
    }

    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Check auth state after animation completes
    if (mounted && !_isDisposed) {
      print('Splash: Requesting auth check');
      context.read<AuthBloc>().add(AuthCheckRequested());
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Splash: Auth state changed to ${state.runtimeType}');

        if (state is AuthSuccess) {
          print('Splash: Navigating to HomeScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError ||
            state is AuthInitial ||
            state is AuthLoggedOut) {
          print('Splash: Navigating to LoginScreen');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        // Note: AuthLoading state is handled by showing the splash screen content
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(
                      0xFF4A90E2,
                    ).withAlpha((_backgroundOpacity.value * 255).toInt()),
                    const Color(
                      0xFFFF6B35,
                    ).withAlpha((_backgroundOpacity.value * 255).toInt()),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value,
                            child: _buildAnimatedLogo(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40.h),

                    // Animated Brand Name
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: _buildBrandName(),
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Animated Tagline
                    AnimatedBuilder(
                      animation: _taglineController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _taglineOpacity.value,
                          child: _buildTagline(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soccer Ball
          _buildSoccerBall(),

          // Arrow and Star
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Opacity(
                opacity: _arrowOpacity.value,
                child: Transform.scale(
                  scale: _starScale.value,
                  child: _buildArrowAndStar(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSoccerBall() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E5BBA), Color(0xFF1E3A8A)],
        ),
      ),
      child: CustomPaint(painter: SoccerBallPainter()),
    );
  }

  Widget _buildArrowAndStar() {
    return CustomPaint(size: Size(60.w, 60.h), painter: ArrowStarPainter());
  }

  Widget _buildBrandName() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Goal',
              style: AppTextStyles.displayLarge.copyWith(
                color: const Color(0xFF1E3A8A),
                letterSpacing: 1.2,
              ),
            ),
            Text(
              ' Mate',
              style: AppTextStyles.displayLarge.copyWith(
                color: const Color(0xFFFF6B35),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        Container(
          width: 120.w,
          height: 2.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E3A8A), const Color(0xFFFF6B35)],
            ),
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Text(
      'Dream. Strive. Achieve.',
      style: AppTextStyles.titleLarge.copyWith(
        color: Colors.white,
        letterSpacing: 0.8,
      ),
    );
  }
}

class SoccerBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4ECDC4)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw pentagons and hexagons pattern
    _drawSoccerBallPattern(canvas, center, radius, paint, strokePaint);
  }

  void _drawSoccerBallPattern(
    Canvas canvas,
    Offset center,
    double radius,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    // Simplified soccer ball pattern with pentagons and hexagons

    // Draw pentagons (dark blue)
    fillPaint.color = const Color(0xFF1E3A8A);
    _drawPentagon(canvas, center, radius * 0.3, fillPaint, strokePaint);

    // Draw hexagons (teal)
    fillPaint.color = const Color(0xFF4ECDC4);
    _drawHexagon(
      canvas,
      Offset(center.dx + radius * 0.2, center.dy - radius * 0.1),
      radius * 0.25,
      fillPaint,
      strokePaint,
    );
    _drawHexagon(
      canvas,
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.1),
      radius * 0.25,
      fillPaint,
      strokePaint,
    );
  }

  void _drawPentagon(
    Canvas canvas,
    Offset center,
    double radius,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawHexagon(
    Canvas canvas,
    Offset center,
    double radius,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 2 * math.pi / 6) - (math.pi / 2);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ArrowStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw arrow
    final arrowPath = Path();
    arrowPath.moveTo(center.dx - 20, center.dy + 10);
    arrowPath.lineTo(center.dx + 15, center.dy - 15);
    arrowPath.lineTo(center.dx + 10, center.dy - 20);
    arrowPath.lineTo(center.dx + 25, center.dy - 5);
    arrowPath.lineTo(center.dx + 20, center.dy);
    arrowPath.lineTo(center.dx + 25, center.dy + 5);
    arrowPath.lineTo(center.dx + 10, center.dy + 20);
    arrowPath.lineTo(center.dx + 15, center.dy + 15);
    arrowPath.close();

    canvas.drawPath(arrowPath, paint);

    // Draw star
    _drawStar(canvas, Offset(center.dx + 25, center.dy), 8, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159 / 5) - (3.14159 / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
