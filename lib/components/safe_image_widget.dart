import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class SafeImageWidget extends StatelessWidget {
  final String? imageOrIcon;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final String? fallbackLabel;

  const SafeImageWidget({
    Key? key,
    required this.imageOrIcon,
    this.width = 70.0,
    this.height = 70.0,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.fallbackLabel,
  }) : super(key: key);

  bool _isEmoji(String text) {
    if (text.isEmpty) return false;
    if (text.startsWith('http://') || text.startsWith('https://') || text.startsWith('assets/')) {
      return false;
    }
    if (text.contains('/') || text.contains('\\') || text.contains('.png') || text.contains('.jpg')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8.0);
    final effectiveBg = backgroundColor ?? FlutterFlowTheme.of(context).secondaryBackground;

    final String raw = (imageOrIcon ?? '').trim();

    if (raw.isEmpty) {
      return _buildFallback(context, effectiveBorderRadius, effectiveBg);
    }

    if (_isEmoji(raw)) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: effectiveBorderRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          raw,
          style: TextStyle(
            fontSize: (height * 0.45).clamp(16.0, 48.0),
          ),
        ),
      );
    }

    if (raw.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Image.asset(
          raw,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _buildFallback(context, effectiveBorderRadius, effectiveBg),
        ),
      );
    }

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: CachedNetworkImage(
          imageUrl: raw,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            color: effectiveBg,
            alignment: Alignment.center,
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              _buildFallback(context, effectiveBorderRadius, effectiveBg),
        ),
      );
    }

    return _buildFallback(context, effectiveBorderRadius, effectiveBg);
  }

  Widget _buildFallback(BuildContext context, BorderRadius radius, Color bg) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.2),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.candlestick_chart,
        size: (height * 0.4).clamp(16.0, 36.0),
        color: FlutterFlowTheme.of(context).primary,
      ),
    );
  }
}
