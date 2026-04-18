import 'dart:async';

import 'package:flutter/material.dart';

import 'Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _backgroundTop = Color(0xFFFDE7EA);
  static const Color _backgroundBottom = Color(0xFFFFFBF7);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2300),
  )..repeat(reverse: true);

  late final Animation<double> _logoScale = Tween<double>(
    begin: 0.92,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  late final Animation<double> _logoFloat = Tween<double>(
    begin: 0,
    end: -10,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_backgroundTop, _backgroundBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -60,
              child: _buildGlowOrb(
                size: 240,
                color: _brandColor.withOpacity(0.10),
              ),
            ),
            Positioned(
              bottom: -70,
              left: -50,
              child: _buildGlowOrb(
                size: 210,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _logoFloat.value),
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildPulseRing(180, 0.12),
                          _buildPulseRing(140, 0.18),
                          Container(
                            width: 118,
                            height: 118,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.96),
                              borderRadius: BorderRadius.circular(34),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1D000000),
                                  blurRadius: 28,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            child: const Image(
                              image: AssetImage('assets/logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Shree Kutch Tumbadi Jain Mahajan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF251F1C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Community updates, directory access, and spiritual information in one place.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A6D65),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 56,
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          _brandColor,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowOrb({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildPulseRing(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _brandColor.withOpacity(opacity), width: 1.2),
      ),
    );
  }
}
