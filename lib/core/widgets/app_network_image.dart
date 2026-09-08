import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable, rounded network image with shimmer placeholder and a graceful
/// fallback when [url] is null/invalid or fails to load.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(16);
    final bool hasUrl = url != null && url!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: radius,
      child: hasUrl
          ? CachedNetworkImage(
              imageUrl: url!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, _) => _shimmer(context),
              errorWidget: (context, _, __) => _fallback(context),
            )
          : _fallback(context),
    );
  }

  Widget _shimmer(BuildContext context) {
    final Color base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: base.withValues(alpha: 0.5),
      child: Container(width: width, height: height, color: base),
    );
  }

  Widget _fallback(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: scheme.onSurfaceVariant,
        size: 28,
      ),
    );
  }
}
