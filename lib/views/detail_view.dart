import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends StatelessWidget {
  final ArticleModel? article;
  final VoidCallback onBack;
  const DetailView({super.key, required this.article, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final currentArticle = article;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: BackButton(onPressed: onBack),
      ),
      body: currentArticle == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentArticle.urlToImage != null && currentArticle.urlToImage!.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: NewsImage(url: currentArticle.urlToImage!, height: 230),
                    ),
                    const SizedBox(height: 22),
                  ],
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          currentArticle.author,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule_rounded, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          DateFormatter.formatDate(currentArticle.publishedAt),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentArticle.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1.22,
                          letterSpacing: -0.5,
                        ),
                  ),
                  if (currentArticle.description != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        currentArticle.description!,
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 15,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: AppColors.outline),
                  ),
                  Text(
                    'Tentang berita ini',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentArticle.content ?? 'Konten lengkap tidak tersedia.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                  ),
                ],
              ),
            ),
    );
  }
}
