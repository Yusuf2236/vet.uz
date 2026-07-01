import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../../backend/repositories/product_repository.dart';
import '../../../backend/repositories/vet_repository.dart';
import '../../data/mock_data.dart';
import '../../models/category_item.dart';
import '../../models/product.dart';
import '../../models/veterinarian.dart';
import '../../widgets/price_text.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/vet_card.dart';
import '../home/widgets/category_grid.dart';

/// Qidiruv ekrani — jonli filtr (veterinar, mahsulot, kategoriya).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  // Repository'dan yuklangan real ma'lumot (Supabase yoki MockData).
  List<Veterinarian> _allVets = MockData.vets;
  List<Product> _allProducts = MockData.products;

  @override
  void initState() {
    super.initState();
    VetRepository().fetchVets().then((v) {
      if (mounted) setState(() => _allVets = v);
    });
    ProductRepository().fetchProducts().then((p) {
      if (mounted) setState(() => _allProducts = p);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value.trim().toLowerCase());
  }

  List<Veterinarian> get _vets => _query.isEmpty
      ? const []
      : _allVets
            .where(
              (v) =>
                  v.name.toLowerCase().contains(_query) ||
                  v.specialty.toLowerCase().contains(_query),
            )
            .toList();

  List<Product> get _products => _query.isEmpty
      ? const []
      : _allProducts
            .where(
              (p) =>
                  p.name.toLowerCase().contains(_query) ||
                  p.category.toLowerCase().contains(_query),
            )
            .toList();

  List<CategoryItem> get _categories => _query.isEmpty
      ? const []
      : MockData.categories
            .where((c) => c.label.toLowerCase().contains(_query))
            .toList();

  @override
  Widget build(BuildContext context) {
    final hasQuery = _query.isNotEmpty;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.md,
          AppSpacing.screenH,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            AppStrings.navSearch,
            style: AppTextStyles.h1.copyWith(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SearchField(
            hint: AppStrings.searchHint,
            controller: _controller,
            onChanged: _onChanged,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (hasQuery) ..._results() else ..._suggestions(),
        ],
      ),
    );
  }

  // ---- Qidiruv natijalari ----
  List<Widget> _results() {
    final vets = _vets;
    final products = _products;
    final categories = _categories;
    final empty = vets.isEmpty && products.isEmpty && categories.isEmpty;

    if (empty) {
      return [_EmptyResult(query: _query)];
    }

    return [
      if (categories.isNotEmpty) ...[
        SectionHeader(title: AppStrings.categories),
        const SizedBox(height: AppSpacing.md),
        CategoryGrid(items: categories),
        const SizedBox(height: AppSpacing.xl),
      ],
      if (vets.isNotEmpty) ...[
        SectionHeader(title: AppStrings.nearbyVets),
        const SizedBox(height: AppSpacing.md),
        for (final v in vets) ...[
          VetCard(vet: v),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
      ],
      if (products.isNotEmpty) ...[
        SectionHeader(title: AppStrings.marketTitle),
        const SizedBox(height: AppSpacing.md),
        for (final p in products) _ProductTile(product: p),
      ],
    ];
  }

  // ---- Bo'sh holatdagi takliflar ----
  List<Widget> _suggestions() {
    return [
      SectionHeader(title: AppStrings.recentSearches),
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final q in MockData.recentSearches)
            _RecentChip(
              label: q,
              onTap: () {
                _controller.text = q;
                _onChanged(q);
              },
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.xxl),
      SectionHeader(title: AppStrings.popularCategories),
      const SizedBox(height: AppSpacing.md),
      CategoryGrid(items: MockData.categories),
    ];
  }
}

class _RecentChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RecentChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 15,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: product.tint,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(product.icon, color: product.color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: titleColor),
                ),
                Text(
                  product.category,
                  style: AppTextStyles.caption.copyWith(color: secondary),
                ),
              ],
            ),
          ),
          PriceText(amount: product.priceSom, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String query;
  const _EmptyResult({required this.query});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxxl),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 56, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            '"$query" bo\'yicha hech narsa topilmadi',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: secondary),
          ),
        ],
      ),
    );
  }
}
