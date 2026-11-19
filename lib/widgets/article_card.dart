import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import 'news_image.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;
  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
            NewsImage(url: article.urlToImage!),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 17),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                article.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                  color: AppColors.textPrimary,
                ),
              ),
              if (article.description != null) ...[
                const SizedBox(height: 9),
                Text(
                  article.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 15),
              const Divider(height: 1, color: AppColors.outline),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.newspaper_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      article.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      DateFormatter.formatDate(article.publishedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
