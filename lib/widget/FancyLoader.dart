import 'dart:math' as math;

import 'package:flutter/material.dart';

class FancyLoader extends StatefulWidget {
  final String label;
  final String? subtitle;
  final double size;
  final IconData icon;
  final Color accentColor;
  final Color backgroundTint;
  final bool showCard;
  final EdgeInsetsGeometry padding;

  const FancyLoader({
    super.key,
    required this.label,
    this.subtitle,
    this.size = 96,
    this.icon = Icons.auto_awesome_rounded,
    this.accentColor = const Color(0xFFAD1207),
    this.backgroundTint = const Color(0xFFFBE9E7),
    this.showCard = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
  });

  @override
  State<FancyLoader> createState() => _FancyLoaderState();
}

class _FancyLoaderState extends State<FancyLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Widget loaderContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int index = 0; index < 6; index++)
                    _buildOrbitDot(index: index),
                  child!,
                ],
              ),
            );
          },
          child: Container(
            width: widget.size * 0.54,
            height: widget.size * 0.54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, widget.backgroundTint],
              ),
              border: Border.all(
                color: widget.accentColor.withOpacity(0.16),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.20),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: widget.size * 0.26,
              color: widget.accentColor,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.label,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF221F1C),
          ),
        ),
        if (widget.subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.subtitle!,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              height: 1.35,
              color: const Color(0xFF7B6F68),
            ),
          ),
        ],
      ],
    );

    if (!widget.showCard) {
      return loaderContent;
    }

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: loaderContent,
    );
  }

  Widget _buildOrbitDot({required int index}) {
    final double turns = _controller.value + (index / 6);
    final double angle = turns * math.pi * 2;
    final double radius = widget.size * 0.34;
    final double wave = math.sin((turns * math.pi * 2) - (math.pi / 6));
    final double scale = 0.72 + ((wave + 1) * 0.16);
    final double opacity = 0.28 + ((wave + 1) * 0.22);
    final double dotOpacity = opacity.clamp(0.0, 1.0).toDouble();
    final double dotSize = widget.size * 0.14;

    return Transform.translate(
      offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.accentColor.withOpacity(dotOpacity),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
