import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

class SearchView extends StatefulWidget {
  final String? keyword;
  final VoidCallback onBack;
  final ValueChanged<ArticleModel> onArticleSelected;
  const SearchView({
    super.key,
    required this.keyword,
    required this.onBack,
    required this.onArticleSelected,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final NewsApiService _service = NewsApiService();
  String? _keyword;
  Future<List<ArticleModel>>? _futureResults;

  @override
  void initState() {
    super.initState();
    _setKeyword(widget.keyword);
  }

  @override
  void didUpdateWidget(covariant SearchView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != oldWidget.keyword) _setKeyword(widget.keyword);
  }

  void _setKeyword(String? keyword) {
    final normalized = keyword?.trim();
    _keyword = normalized == null || normalized.isEmpty ? null : normalized;
    _futureResults = _keyword == null ? null : _service.searchNews(_keyword!);
  }

  void _retry() {
    final keyword = _keyword;
    if (keyword == null) return;
    setState(() => _futureResults = _service.searchNews(keyword));
  }

  Future<void> _refresh() async {
    if (_keyword == null) return;
    _retry();
    try {
      await _futureResults;
    } catch (_) {
      // FutureBuilder menampilkan pesan error.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: widget.onBack),
          title: const Text('Hasil pencarian'),
        ),
        body: Column(
          children: [
            if (_keyword != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 3, 20, 15),
                decoration: const BoxDecoration(
                  color: AppColors.canvas,
                  border: Border(bottom: BorderSide(color: AppColors.outline)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KATA KUNCI',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '“$_keyword”',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: FutureBuilder<List<ArticleModel>>(
                future: _futureResults,
                builder: (context, snapshot) {
                  if (_keyword == null) return const SizedBox.shrink();
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Mencari berita...', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorView(message: snapshot.error.toString(), onRetry: _retry);
                  }
                  final articles = snapshot.data ?? [];
                  if (articles.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded, size: 56, color: AppColors.textSecondary),
                            SizedBox(height: 14),
                            Text('Berita tidak ditemukan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            SizedBox(height: 6),
                            Text('Coba kata kunci yang berbeda.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    color: AppColors.primary,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                      itemCount: articles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleCard(
                          article: article,
                          onTap: () => widget.onArticleSelected(article),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
