import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class NewsImage extends StatelessWidget {
  final String url;
  final double height;
  const NewsImage({super.key, required this.url, this.height = 200});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      color: AppColors.surfaceSoft,
      child: const Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
    final error = Container(
      height: height,
      color: AppColors.surfaceSoft,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 42, color: AppColors.textSecondary),
      ),
    );
    if (kIsWeb) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, progress) => progress == null ? child : placeholder,
        errorBuilder: (context, e, st) => error,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, e) => error,
    );
  }
}
