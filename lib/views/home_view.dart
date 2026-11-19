import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';
import '../widgets/search_dialog.dart';
import 'detail_view.dart';
import 'search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();
  static const Map<String, String> _categories = {
    'general': 'Utama', 'nation': 'Nasional', 'world': 'Dunia',
    'business': 'Bisnis', 'technology': 'Teknologi', 'entertainment': 'Hiburan',
    'sports': 'Olahraga', 'science': 'Sains', 'health': 'Kesehatan',
  };
  String _selectedCategory = 'general';
  final Map<String, Future<List<ArticleModel>>> _categoryFutures = {};
  final List<int> _pageHistory = [0];
  String? _searchKeyword;
  ArticleModel? _selectedArticle;
  late Future<List<ArticleModel>> _futureNews;

  int get _activePage => _pageHistory.last;

  @override
  void initState() {
    super.initState();
    _futureNews = _categoryFutures.putIfAbsent(
      _selectedCategory,
      () => _service.getTopHeadlines(category: _selectedCategory),
    );
  }

  void _muatUlang() {
    setState(() {
      // Retry dan pull-to-refresh membuang Future lama agar request baru dibuat.
      _categoryFutures.remove(_selectedCategory);
      _futureNews = _categoryFutures.putIfAbsent(
        _selectedCategory,
        () => _service.getTopHeadlines(category: _selectedCategory),
      );
    });
  }

  void _gantiKategori(String category) {
    if (category == _selectedCategory) return;
    setState(() {
      _selectedCategory = category;
      _futureNews = _categoryFutures.putIfAbsent(
        category,
        () => _service.getTopHeadlines(category: category),
      );
    });
  }

  Future<void> _cariBerita() async {
    final keyword = await showDialog<String>(
      context: context,
      builder: (_) => const SearchDialog(),
    );
    if (keyword == null || keyword.isEmpty) return;
    if (!mounted) return;
    setState(() {
      _searchKeyword = keyword;
      _selectedArticle = null;
      _pageHistory.add(1);
    });
  }

  void _bukaDetail(ArticleModel article) {
    setState(() {
      _selectedArticle = article;
      _pageHistory.add(2);
    });
  }

  void _kembali() {
    if (_pageHistory.length <= 1) return;
    setState(() {
      _pageHistory.removeLast();
      if (_activePage != 2) _selectedArticle = null;
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try { await _futureNews; } catch (_) { /* FutureBuilder menampilkan error. */ }
  }

  @override
  Widget build(BuildContext context) => PopScope<void>(
        canPop: _pageHistory.length == 1,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _kembali();
        },
        child: IndexedStack(
          index: _activePage,
          children: [
            _buildHomePage(),
            SearchView(
              keyword: _searchKeyword,
              onBack: _kembali,
              onArticleSelected: _bukaDetail,
            ),
            DetailView(article: _selectedArticle, onBack: _kembali),
          ],
        ),
      );

  Widget _buildHomePage() => Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('News App'),
              SizedBox(height: 2),
              Text(
                'Kabar pilihan Indonesia',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filledTonal(
                onPressed: _cariBerita,
                tooltip: 'Cari berita',
                icon: const Icon(Icons.search_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceSoft,
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildCategoryChips(),
            Expanded(
              child: FutureBuilder<List<ArticleModel>>(
                future: _futureNews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Memuat berita...', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorView(message: snapshot.error.toString(), onRetry: _muatUlang);
                  }
                  final articles = snapshot.data ?? [];
                  if (articles.isEmpty) {
                    return const _EmptyNewsState(
                      title: 'Belum ada berita',
                      message: 'Coba pilih kategori lain untuk melihat berita.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.primary,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                      itemCount: articles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleCard(article: article, onTap: () => _bukaDetail(article));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildCategoryChips() => Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        decoration: const BoxDecoration(
          color: AppColors.canvas,
          border: Border(bottom: BorderSide(color: AppColors.outline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Text(
                'PILIH KATEGORI',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories.keys.elementAt(index);
                  final selected = category == _selectedCategory;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(_categories[category]!),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    selected: selected,
                    onSelected: (_) => _gantiKategori(category),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

class _EmptyNewsState extends StatelessWidget {
  final String title;
  final String message;
  const _EmptyNewsState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(color: AppColors.surfaceSoft, shape: BoxShape.circle),
                child: const Icon(Icons.newspaper_rounded, color: AppColors.primary, size: 34),
              ),
              const SizedBox(height: 18),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, height: 1.45)),
            ],
          ),
        ),
      );
}
