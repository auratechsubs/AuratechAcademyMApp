
library;

import 'dart:ui';
import 'package:auratech_academy/constant/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebinarCardPro extends StatelessWidget {
  final String title;
  final String date;              // "22 August 2025"
  final String time;              // "06:00 PM IST"
  final String speaker;           // "Rushikesh Meharwade"
  final String role;              // "Founder, Vidvatta"
  final String buttonText;
  final String bannerAsset;       // asset path or http(s) url
  final String? speakerAvatar;    // optional network avatar

  final bool isLive;              // red LIVE chip if true
  final bool isUpcoming;          // green UPCOMING chip if true
  final VoidCallback? onTap;
  final VoidCallback? onRegister;

  const WebinarCardPro({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.speaker,
    required this.role,
    required this.bannerAsset,
    this.speakerAvatar,
    this.buttonText = "Register Now",
    this.isLive = false,
    this.isUpcoming = true,
    this.onTap,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // clamp user text scale so layout stays tight but accessible
    final ts = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: ts),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          // breakpoints tuned for phone/tablet/web
          final bool isWide = w >= 840;
          final bool isTablet = !isWide && w >= 600;

          // responsive helpers
          double rs(double phone, [double? tab, double? wide]) =>
              isWide ? (wide ?? tab ?? phone)
                  : isTablet ? (tab ?? phone)
                  : phone;

          double rf(double phone, [double? tab, double? wide]) =>
              rs(phone, tab, wide);

          final radius = rs(18, 20, 22);
          final cardPadding = EdgeInsets.symmetric(
            horizontal: rs(14, 16, 18),
            vertical: rs(10, 12, 14),
          );

          final border = BorderSide(
            color: isDark ? Colors.white12 : const Color(0xFFEFF2F6),
            width: 1,
          );

          final card = Card(
            elevation: 0,
            color: isDark
                ? const Color(0xFF12161D)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: border,
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              splashColor: AppColors.primary.withOpacity(.08),
              highlightColor: AppColors.primary.withOpacity(.04),
              child: isWide
                  ? _HorizontalBody(
                radius: radius,
                padding: cardPadding,
                rs: rs,
                rf: rf,
                isDark: isDark,
                title: title,
                date: date,
                time: time,
                speaker: speaker,
                role: role,
                buttonText: buttonText,
                bannerAsset: bannerAsset,
                speakerAvatar: speakerAvatar,
                isLive: isLive,
                isUpcoming: isUpcoming,
                onRegister: onRegister,
              )
                  : _VerticalBody(
                radius: radius,
                padding: cardPadding,
                rs: rs,
                rf: rf,
                isTablet: isTablet,
                isDark: isDark,
                title: title,
                date: date,
                time: time,
                speaker: speaker,
                role: role,
                buttonText: buttonText,
                bannerAsset: bannerAsset,
                speakerAvatar: speakerAvatar,
                isLive: isLive,
                isUpcoming: isUpcoming,
                onRegister: onRegister,
              ),
            ),
          );

          return Container(
            // subtle outer shadow for elevation in both themes
            margin: EdgeInsets.symmetric(
              horizontal: rs(12, 14, 16),
              vertical: rs(8, 10, 12),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                  blurRadius: rs(18, 20, 24),
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
              // soft gradient – barely visible in light, richer in dark
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF10141A), Color(0xFF151A20)]
                    : const [Colors.white, Color(0xFFF7F9FC)],
              ),
            ),
            child: card,
          );
        },
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// VERTICAL (phone / compact)
/// ─────────────────────────────────────────────────────────────────────────────
class _VerticalBody extends StatelessWidget {
  final double radius;
  final EdgeInsets padding;
  final double Function(double p, [double? t, double? w]) rs;
  final double Function(double p, [double? t, double? w]) rf;
  final bool isTablet;
  final bool isDark;

  final String title, date, time, speaker, role, buttonText, bannerAsset;
  final String? speakerAvatar;
  final bool isLive, isUpcoming;
  final VoidCallback? onRegister;

  const _VerticalBody({
    required this.radius,
    required this.padding,
    required this.rs,
    required this.rf,
    required this.isTablet,
    required this.isDark,
    required this.title,
    required this.date,
    required this.time,
    required this.speaker,
    required this.role,
    required this.buttonText,
    required this.bannerAsset,
    required this.speakerAvatar,
    required this.isLive,
    required this.isUpcoming,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final bannerH = rs(170, 200);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Banner(
          height: bannerH,
          radius: radius,
          banner: bannerAsset,
          isLive: isLive,
          isUpcoming: isUpcoming,
          date: date,
          time: time,
          rs: rs,
        ),
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: rf(16, 18),
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF141A24),
                  height: 1.2,
                ),
              ),
              SizedBox(height: rs(10, 12)),
              Row(
                children: [
                  _SpeakerAvatar(
                    name: speaker,
                    avatar: speakerAvatar,
                    size: rs(36, 42),
                  ),
                  SizedBox(width: rs(10, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          speaker,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: rf(14, 15),
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2430),
                          ),
                        ),
                        SizedBox(height: rs(2, 3)),
                        Text(
                          role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: rf(12, 13),
                            color:
                            isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: rs(14, 16)),
              _PrimaryButton(
                label: buttonText,
                onPressed: onRegister,
                dense: !isTablet,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// HORIZONTAL (wide ≥ 840)
/// ─────────────────────────────────────────────────────────────────────────────
class _HorizontalBody extends StatelessWidget {
  final double radius;
  final EdgeInsets padding;
  final double Function(double p, [double? t, double? w]) rs;
  final double Function(double p, [double? t, double? w]) rf;
  final bool isDark;

  final String title, date, time, speaker, role, buttonText, bannerAsset;
  final String? speakerAvatar;
  final bool isLive, isUpcoming;
  final VoidCallback? onRegister;

  const _HorizontalBody({
    required this.radius,
    required this.padding,
    required this.rs,
    required this.rf,
    required this.isDark,
    required this.title,
    required this.date,
    required this.time,
    required this.speaker,
    required this.role,
    required this.buttonText,
    required this.bannerAsset,
    required this.speakerAvatar,
    required this.isLive,
    required this.isUpcoming,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final bannerW = 320.0; // fixed visual anchor
    final bannerH = 200.0;

    return Row(
      children: [
        // Left banner
        SizedBox(
          width: bannerW,
          child: _Banner(
            height: bannerH,
            radius: radius,
            banner: bannerAsset,
            isLive: isLive,
            isUpcoming: isUpcoming,
            date: date,
            time: time,
            rs: rs,
          ),
        ),
        // Right content
        Expanded(
          child: Padding(
            padding: padding.copyWith(left: rs(10, 14, 18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: rf(18, 20, 22),
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF141A24),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: rs(10, 12, 14)),
                Row(
                  children: [
                    _SpeakerAvatar(
                      name: speaker,
                      avatar: speakerAvatar,
                      size: rs(42, 46, 50),
                    ),
                    SizedBox(width: rs(12, 14, 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            speaker,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: rf(15, 16, 17),
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2430),
                            ),
                          ),
                          SizedBox(height: rs(3, 4, 4)),
                          Text(
                            role,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: rf(13, 13.5, 14),
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: rs(16, 18, 20)),
                _PrimaryButton(
                  label: buttonText,
                  onPressed: onRegister,
                  dense: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// SHARED SUBWIDGETS
/// ─────────────────────────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  final double height;
  final double radius;
  final String banner;
  final bool isLive;
  final bool isUpcoming;
  final String date;
  final String time;
  final double Function(double p, [double? t, double? w]) rs;

  const _Banner({
    required this.height,
    required this.radius,
    required this.banner,
    required this.isLive,
    required this.isUpcoming,
    required this.date,
    required this.time,
    required this.rs,
  });

  bool get _isNetwork => banner.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final isTabletOrUp = MediaQuery.sizeOf(context).width >= 600;

    ImageProvider img() {
      if (_isNetwork) return NetworkImage(banner);
      return AssetImage(banner);
    }

    return Stack(
      children: [
        // image
        SizedBox(
          height: height,
          width: double.infinity,
          child: Ink.image(
            image: img(),
            fit: BoxFit.cover,
            child: const SizedBox.shrink(),
          ),
        ),
        // gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
        ),
        // chips
        Positioned(
          top: rs(10, 12),
          left: rs(10, 12),
          child: Row(
            children: [
              if (isLive)
                _ChipBadge(
                  label: "LIVE",
                  bg: Colors.red.withOpacity(0.90),
                  fg: Colors.white,
                  icon: Icons.fiber_manual_record,
                ),
              if (isLive && isUpcoming) SizedBox(width: rs(6, 8)),
              if (isUpcoming)
                _ChipBadge(
                  label: "UPCOMING",
                  bg: Colors.green.withOpacity(0.90),
                  fg: Colors.white,
                  icon: Icons.schedule,
                ),
            ],
          ),
        ),
        // glass date/time
        Positioned(
          left: rs(10, 12),
          right: rs(10, 12),
          bottom: rs(10, 12),
          child: _GlassPanel(
            radius: rs(12, 14),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: rs(10, 12),
                vertical: rs(8, 10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: rs(16, 18),
                      color: Colors.white),
                  SizedBox(width: rs(8, 10)),
                  Flexible(
                    child: Text(
                      "$date  •  $time",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: rs(12.5, 14),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final IconData? icon;
  const _ChipBadge({
    required this.label,
    required this.bg,
    required this.fg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: bg,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final double radius;
  final Widget child;
  const _GlassPanel({required this.radius, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SpeakerAvatar extends StatelessWidget {
  final String name;
  final String? avatar;
  final double size;
  const _SpeakerAvatar({required this.name, this.avatar, this.size = 40});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.primaries[name.hashCode % Colors.primaries.length];
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color.withOpacity(0.15),
      foregroundImage:
      (avatar != null && avatar!.isNotEmpty) ? NetworkImage(avatar!) : null,
      child: (avatar == null || avatar!.isEmpty)
          ? Text(
        initials,
        style: GoogleFonts.inter(
          fontSize: size * 0.42,
          fontWeight: FontWeight.w800,
          color: color.shade700,
        ),
      )
          : null,
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool dense;
  const _PrimaryButton({
    required this.label,
    this.onPressed,
    this.dense = false,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.primary;
    final fg = Colors.white;
    final pad = widget.dense
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 12);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            elevation: _hover ? 6 : 3,
            backgroundColor: bg,
            foregroundColor: fg,
            padding: pad,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
