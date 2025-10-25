import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _backgroundController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      _taglineController.forward();
    });
  }

  void _navigateAfterDelay() {
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  void dispose() {
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
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError || state is AuthInitial) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
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
                    ).withOpacity(_backgroundOpacity.value),
                    const Color(
                      0xFFFF6B35,
                    ).withOpacity(_backgroundOpacity.value),
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

                    const SizedBox(height: 40),

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

                    const SizedBox(height: 20),

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
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
      width: 80,
      height: 80,
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
    return CustomPaint(size: const Size(60, 60), painter: ArrowStarPainter());
  }

  Widget _buildBrandName() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Goal',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
                letterSpacing: 1.2,
              ),
            ),
            Text(
              ' Mate',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF6B35),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        Container(
          width: 120,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1E3A8A), const Color(0xFFFF6B35)],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Text(
      'Dream. Strive. Achieve.',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
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
    final path = Path();

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
