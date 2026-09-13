import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_color.dart';

class QuizQuestionShimmer extends StatelessWidget {
  const QuizQuestionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _ShimmerBox(width: 80, height: 12, borderRadius: 6),
                const _ShimmerBox(width: 70, height: 14, borderRadius: 6),
              ],
            ),
            verticalSpace(10),
            const _ShimmerBox(width: double.infinity, height: 8, borderRadius: 4),
            verticalSpace(16),
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: ColorPalette.surface,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _ShimmerBox(width: double.infinity, height: 16),
                          verticalSpace(8),
                          const _ShimmerBox(width: 140, height: 16),
                          verticalSpace(24),
                          for (int i = 0; i < 4; i++) ...[
                            const _ShimmerBox(
                              width: double.infinity,
                              height: 54,
                              borderRadius: 16,
                            ),
                            verticalSpace(12),
                          ],
                        ],
                      ),
                    ),
                    verticalSpace(14),
                    const Center(
                      child: _ShimmerBox(
                        width: 150,
                        height: 12,
                        borderRadius: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(8),
            const _ShimmerBox(width: double.infinity, height: 52, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorPalette.divider,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: SizedBox(width: width.w, height: height.h),
    );
  }
}

class _ShimmerLoading extends StatefulWidget {
  const _ShimmerLoading({required this.child});

  final Widget child;

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final dx = _controller.value * 2 - 1;
            return LinearGradient(
              begin: Alignment(-1 + dx, 0),
              end: Alignment(1 + dx, 0),
              colors: [
                ColorPalette.divider,
                ColorPalette.surface,
                ColorPalette.divider,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}