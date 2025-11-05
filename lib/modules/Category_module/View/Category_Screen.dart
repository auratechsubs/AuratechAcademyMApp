import 'dart:convert';
import 'dart:math';

import 'dart:ui';
import 'package:auratech_academy/widget/custombottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constant/constant_colors.dart';
import '../../Course_module/Controller/Popular_course_controller.dart';
import '../Controller/Category_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data' as t;
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final Category_Controller categoryController = Get.find<Category_Controller>();
  final PopularCourseController popularCourseController = Get.find();

  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // continuous pulse
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenWidth = size.width;
    final screenHeight = size.height;

    final isTablet = screenWidth >= 600;
    final gridCrossAxisCount = isTablet ? 3 : 2;
    final cardSize = min(screenWidth, 820) / (isTablet ? 3.2 : 2.3);
    final iconBox = cardSize * 0.78;
    final radius = 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // gradient backdrop
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [Color(0xFFF7FAFF), Color(0xFFEFF4FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    isTablet ? 12 : 6,
                    16,
                    8,
                  ),
                  child: Row(
                    children: [
                      const BackButton(color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "All Categories",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                // SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchBar(
                    hint: "Search categories…",
                    onChanged: categoryController.filterCategory,
                  ),
                ),

                const SizedBox(height: 10),

                // GRID
                Expanded(
                  child: Obx(() {
                    final list = categoryController.filterCategories;
                    final loading = (categoryController.categoryList.isEmpty &&
                        list.isEmpty);

                    if (loading) {
                      return _GridSkeleton(
                        crossAxisCount: gridCrossAxisCount,
                        itemSize: cardSize,
                        count: gridCrossAxisCount * 4,
                      );
                    }

                    if (list.isEmpty) {
                      return _EmptyState(
                        message: "No categories found",
                        onReset: () => categoryController.filterCategory(""),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCrossAxisCount,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final iconUrl =
                            "https://api.auratechacademy.com${item.categoryIcon}";
                        final title = item.categoryName;

                        return _CategoryTile(
                          title: title,
                          iconUrl: iconUrl,
                          pulse: _pulseCtrl,
                          boxSize: iconBox,
                          radius: radius,
                          onTap: () {
                            popularCourseController.HomefilterCorse(title);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => BottomnavBar()),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*==========================
  SEARCH BAR (Glass style)
==========================*/
class _SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
            hintText: hint,
            filled: true,
            fillColor: (isDark ? Colors.white10 : Colors.white).withOpacity(0.85),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : const Color(0xFFE3E8F2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDark ? Colors.white24 : const Color(0xFFE3E8F2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1.4),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }
}

/*==========================
  CATEGORY TILE
==========================*/
class _CategoryTile extends StatefulWidget {
  final String title;
  final String iconUrl;
  final AnimationController pulse;
  final double boxSize;
  final double radius;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.iconUrl,
    required this.pulse,
    required this.boxSize,
    required this.radius,
    required this.onTap,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: _hover ? 1.015 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.radius),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A21) : Colors.white,
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFEAEFF6),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            child: Column(
              children: [
                // Pulse halo + Icon
                SizedBox(
                  width: widget.boxSize,
                  height: widget.boxSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // expanding circular ripples
                      Positioned.fill(
                        child: PulseHalo(
                          animation: widget.pulse,
                          color: Colors.blueAccent,
                          waveCount: 3,
                        ),
                      ),

                      // white card for icon
                      Container(
                        width: widget.boxSize * 0.78,
                        height: widget.boxSize * 0.78,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(widget.boxSize * 0.16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFE7EDF7), width: 1),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(widget.boxSize * 0.12),
                          child: _SafeSvg(
                            url: widget.iconUrl,
                            fallbackAsset: "assets/images/category_2_5.svg",
                            width: widget.boxSize * 0.56,
                            height: widget.boxSize * 0.56,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



                // Title
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 6),

                // subtle underline accent
                Container(
                  width: 34,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*==========================
  PULSE HALO WIDGET
==========================*/
class PulseHalo extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final int waveCount;
  const PulseHalo({
    super.key,
    required this.animation,
    required this.color,
    this.waveCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          painter: _HaloPainter(
            progress: animation.value,
            color: color,
            waveCount: waveCount,
          ),
        );
      },
    );
  }
}

class _HaloPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int waveCount;

  _HaloPainter({
    required this.progress,
    required this.color,
    required this.waveCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = size.shortestSide * 0.48;

    for (int i = 0; i < waveCount; i++) {
      final p = ((progress + (i / waveCount)) % 1.0);
      final radius = maxR * p;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = lerpDouble(3.0, 0.8, p)!
        ..color = color.withOpacity((1 - p).clamp(0.0, 0.7));

      if (radius > 0) {
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_HaloPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.color != color ||
          oldDelegate.waveCount != waveCount;
}

/*==========================
  EMPTY & SKELETON
==========================*/
class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback onReset;
  const _EmptyState({required this.message, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 56, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Reset search"),
          ),
        ],
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  final int crossAxisCount;
  final int count;
  final double itemSize;
  const _GridSkeleton({
    required this.crossAxisCount,
    required this.count,
    required this.itemSize,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.92,
      ),
      itemCount: count,
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
          child: Column(
            children: [
              Container(
                width: itemSize * 0.78,
                height: itemSize * 0.78,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(itemSize * 0.16),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 90,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}





class _SafeSvg extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackAsset;

  const _SafeSvg({
    required this.url,
    required this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<_SafeSvg> createState() => _SafeSvgState();
}

class _SafeSvgState extends State<_SafeSvg> {
  t.Uint8List? _svgBytes;                      // 👈 aliased Uint8List
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final resp = await http.get(Uri.parse(widget.url));
      if (resp.statusCode == 200) {
        // ✅ force to our aliased Uint8List to avoid “two Uint8List” mismatch
        final t.Uint8List bytes = t.Uint8List.fromList(resp.bodyBytes);

        // (Optional) check looks like SVG text
        final String sample = utf8.decode(bytes, allowMalformed: true);
        if (sample.contains('<svg')) {
          if (mounted) setState(() => _svgBytes = bytes);
          return;
        }
      }
      if (mounted) setState(() => _failed = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_svgBytes != null) {
      return SvgPicture.memory(
        _svgBytes!,                               // 👈 our aliased bytes
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    if (_failed) {
      return SvgPicture.asset(
        widget.fallbackAsset,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    return const Center(
      child: SizedBox(
        width: 22, height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}


