import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color fallbackIconColor;
  final double fallbackIconSize;
  final Color fallbackBackgroundColor;
  final BorderRadius borderRadius;

  const SmartImage({
    Key? key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image,
    this.fallbackIconColor = const Color(0xFF13B8A8),
    this.fallbackIconSize = 24,
    this.fallbackBackgroundColor = const Color(0xFF333333),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem URL hình ảnh có hợp lệ không
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackContainer();
    }

    // Nếu là URL mạng, sử dụng Image.network với xử lý lỗi
    if (imageUrl!.startsWith('http')) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackContainer();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: fallbackBackgroundColor,
                borderRadius: borderRadius,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: fallbackIconColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }

    // Nếu là asset, sử dụng Image.asset với xử lý lỗi
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackContainer();
        },
      ),
    );
  }

  Widget _buildFallbackContainer() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fallbackBackgroundColor,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          color: fallbackIconColor,
          size: fallbackIconSize,
        ),
      ),
    );
  }
} 