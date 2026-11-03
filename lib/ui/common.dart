import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/store_bloc.dart';
import '../models/models.dart';

// ---------------------------------------------------------------------------
// Breakpoints & layout
// ---------------------------------------------------------------------------

class Bp {
  static bool mobile(BuildContext c) => MediaQuery.sizeOf(c).width < 640;
  static bool tablet(BuildContext c) => MediaQuery.sizeOf(c).width < 1024;
  static bool desktop(BuildContext c) => MediaQuery.sizeOf(c).width >= 1024;
  static double hPad(BuildContext c) => mobile(c) ? 20 : (tablet(c) ? 32 : 48);
}

/// Membatasi lebar konten maksimal 1280px dan memberi padding horizontal.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.padding = true});
  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding ? Bp.hPad(context) : 0),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------------

class Txt {
  static TextStyle serif(double size,
          {FontWeight weight = FontWeight.w400,
          Color? color,
          double? height,
          FontStyle? style,
          double spacing = 0}) =>
      GoogleFonts.newsreader(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        fontStyle: style,
        letterSpacing: spacing,
      );

  static TextStyle sans(double size,
          {FontWeight weight = FontWeight.w400,
          Color? color,
          double? height,
          double spacing = 0,
          TextDecoration? decoration}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: spacing,
        decoration: decoration,
        decorationColor: color,
      );

  /// Label kecil huruf kapital (eyebrow).
  static TextStyle eyebrow(Color color, {double size = 11}) =>
      sans(size, weight: FontWeight.w700, color: color, spacing: 1.2);
}

extension PaletteX on BuildContext {
  StorePalette get pal => read<StoreBloc>().state.store.palette;
}

// ---------------------------------------------------------------------------
// Interaksi
// ---------------------------------------------------------------------------

/// Builder sederhana untuk efek hover (web/desktop).
class Hover extends StatefulWidget {
  const Hover({super.key, required this.builder, this.onTap, this.cursor});
  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor? cursor;

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor ??
          (widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer),
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
        onTapUp: widget.onTap == null ? null : (_) => setState(() => _down = false),
        onTapCancel: widget.onTap == null ? null : () => setState(() => _down = false),
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          child: widget.builder(context, _hover),
        ),
      ),
    );
  }
}

/// Tombol pil serbaguna.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onTap,
    required this.bg,
    required this.fg,
    this.hoverBg,
    this.border,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    this.fontSize = 13,
    this.shadow = false,
    this.radius = 999,
    this.expand = false,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color bg;
  final Color fg;
  final Color? hoverBg;
  final Color? border;
  final Gradient? gradient;
  final EdgeInsets padding;
  final double fontSize;
  final bool shadow;
  final double radius;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Hover(
      onTap: onTap,
      cursor: onTap == null ? SystemMouseCursors.forbidden : null,
      builder: (context, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? (h && hoverBg != null ? hoverBg : bg) : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          border: border != null ? Border.all(color: border!) : null,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: h ? 0.22 : 0.14),
                    blurRadius: h ? 18 : 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        foregroundDecoration: gradient != null && h
            ? BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(radius),
              )
            : null,
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: fontSize + 4, color: fg),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Txt.sans(fontSize, weight: FontWeight.w600, color: fg),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: fontSize + 4, color: fg),
            ],
          ],
        ),
      ),
    );
  }
}

/// Badge/chip kecil.
class Tag extends StatelessWidget {
  const Tag(this.text,
      {super.key,
      required this.bg,
      required this.fg,
      this.icon,
      this.border,
      this.radius = 999,
      this.fontSize = 10.5,
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4)});
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;
  final Color? border;
  final double radius;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: fg),
            const SizedBox(width: 4),
          ],
          Text(text.toUpperCase(),
              style: Txt.sans(fontSize, weight: FontWeight.w700, color: fg, spacing: 0.8)),
        ],
      ),
    );
  }
}

/// Indikator titik berdenyut (status buka).
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, this.color = const Color(0xFF059669), this.size = 10});
  final Color color;
  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Transform.scale(
                scale: 1 + _c.value * 1.4,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: (1 - _c.value) * 0.6),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gambar
// ---------------------------------------------------------------------------

/// Gambar dengan fallback emoji bergradasi bila gambar gagal dimuat.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.src,
    required this.emoji,
    this.fit = BoxFit.cover,
    this.grayscale = false,
    this.cacheWidth,
    this.cacheHeight,
  });
  final String src;
  final String emoji;
  final BoxFit fit;
  final bool grayscale;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    Widget fallback() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [pal.secondarySoft, pal.glow, pal.surfaceContainer],
            ),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(emoji, style: const TextStyle(fontSize: 48)),
            ),
          ),
        );

    Widget img;
    if (src.isEmpty) {
      img = fallback();
    } else if (src.startsWith('assets/')) {
      img = Image.asset(
        src,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        filterQuality: FilterQuality.low,
        errorBuilder: (_, _, _) => fallback(),
      );
    } else {
      img = Image.network(
        src,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        filterQuality: FilterQuality.low,
        errorBuilder: (_, _, _) => fallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: pal.surfaceContainer,
            alignment: Alignment.center,
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: pal.secondary),
            ),
          );
        },
      );
    }
    if (grayscale) {
      img = ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0.2126, 0.7152, 0.0722, 0, 0, //
          0, 0, 0, 0.65, 0,
        ]),
        child: img,
      );
    }
    return img;
  }
}

// ---------------------------------------------------------------------------
// Util
// ---------------------------------------------------------------------------

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
}

String waLink(String number, String text) {
  final t = Uri.encodeComponent(text);
  return number.isEmpty ? 'https://wa.me/?text=$t' : 'https://wa.me/$number?text=$t';
}

void showToast(BuildContext context, String message,
    {IconData icon = Icons.check_circle_rounded, bool error = false}) {
  final pal = context.read<StoreBloc>().state.store.palette;
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.sizeOf(context).width < 500 ? null : 440,
      margin: MediaQuery.sizeOf(context).width < 500
          ? const EdgeInsets.fromLTRB(16, 0, 16, 110)
          : null,
      backgroundColor: error ? const Color(0xFF7F1D1D) : pal.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      duration: const Duration(milliseconds: 2200),
      content: Row(
        children: [
          Icon(error ? Icons.error_outline_rounded : icon,
              color: error ? Colors.white : pal.secondarySoft, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: Txt.sans(13, weight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}

/// Kartu standar dengan border & bayangan halus.
BoxDecoration cardDecoration(StorePalette pal, {double radius = 24, bool hovered = false}) =>
    BoxDecoration(
      color: pal.surfaceLowest,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: pal.outlineVariant.withValues(alpha: 0.35)),
      boxShadow: [
        BoxShadow(
          color: pal.primaryContainer.withValues(alpha: hovered ? 0.08 : 0.04),
          blurRadius: hovered ? 18 : 10,
          offset: Offset(0, hovered ? 6 : 3),
        ),
      ],
    );

