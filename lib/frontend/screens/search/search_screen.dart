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

// Import navigation targets for professional category routing
import '../clinic/clinic_list_screen.dart';
import '../market/category_products_screen.dart';
import '../more/more_services_screen.dart';
import '../vet/vet_detail_screen.dart';
import '../vet/vet_list_screen.dart';
import '../ai/ai_assistant_screen.dart';

/// Qidiruv ekrani — jonli filtr (veterinar, mahsulot, kategoriya) va premium animatsiyalar.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<Veterinarian> _allVets = MockData.vets;
  List<Product> _allProducts = MockData.products;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _recentSearches = List.from(MockData.recentSearches);
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

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  void _onCategory(CategoryItem item) {
    switch (item.label) {
      case 'Veterinar':
        _push(const VetListScreen(title: 'Veterinarlar'));
      case 'Klinika':
        _push(const ClinicListScreen());
      case 'Chorva':
        _push(
          VetListScreen(
            title: 'Chorva mutaxassislari',
            filter: (v) => v.animalType.contains('Sigir'),
          ),
        );
      case 'Dorixona':
        _push(
          const CategoryProductsScreen(
            title: 'Dorixona',
            allowed: {'Dorilar', 'Vitaminlar'},
          ),
        );
      case 'Pet Shop':
        _push(
          const CategoryProductsScreen(
            title: 'Pet Shop',
            allowed: {'Oziq-ovqat', 'Jihozlar'},
          ),
        );
      case 'Market':
        _push(const CategoryProductsScreen(title: 'Barcha mahsulotlar'));
      case 'AI':
        _push(const AiAssistantScreen());
      default:
        _push(const MoreServicesScreen());
    }
  }

  void _openVet(Veterinarian vet) {
    _push(VetDetailScreen(vet: vet));
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
          if (hasQuery)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _results(),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _suggestions(),
            ),
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
        CategoryGrid(items: categories, onTap: _onCategory),
        const SizedBox(height: AppSpacing.xl),
      ],
      if (vets.isNotEmpty) ...[
        SectionHeader(title: AppStrings.nearbyVets),
        const SizedBox(height: AppSpacing.md),
        for (final v in vets) ...[
          VetCard(vet: v, onTap: () => _openVet(v)),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SectionHeader(title: AppStrings.recentSearches),
          if (_recentSearches.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
              child: const Text(
                "Tozalash",
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      if (_recentSearches.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            "So'nggi qidiruvlar mavjud emas",
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        )
      else
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final q in _recentSearches)
              _AnimatedRecentChip(
                label: q,
                onTap: () {
                  _controller.text = q;
                  _onChanged(q);
                },
                onDelete: () {
                  setState(() {
                    _recentSearches.remove(q);
                  });
                },
              ),
          ],
        ),
      const SizedBox(height: AppSpacing.xxl),
      SectionHeader(title: AppStrings.popularCategories),
      const SizedBox(height: AppSpacing.md),
      CategoryGrid(items: MockData.categories, onTap: _onCategory),
    ];
  }
}

class _AnimatedRecentChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AnimatedRecentChip({
    required this.label,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_AnimatedRecentChip> createState() => _AnimatedRecentChipState();
}

class _AnimatedRecentChipState extends State<_AnimatedRecentChip> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = Theme.of(context).textTheme.bodyMedium?.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B2321) : const Color(0xFFF2F9F6),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isDark ? const Color(0xFF283631) : const Color(0xFFDCEFE7),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 14,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: widget.onDelete,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatefulWidget {
  final Product product;
  const _ProductTile({required this.product});

  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final titleColor = Theme.of(context).textTheme.titleMedium?.color;
    final secondary = Theme.of(context).textTheme.bodySmall?.color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: () {
        _showProductDetail(context, widget.product);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.product.tint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(widget.product.icon, color: widget.product.color, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.product.category,
                      style: AppTextStyles.caption.copyWith(color: secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PriceText(
                    amount: widget.product.priceSom,
                    color: AppColors.primary,
                    style: AppTextStyles.bodyStrong,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Text(
                      "Ko'rish",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, Product product) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        final titleColor = Theme.of(ctx).textTheme.titleLarge?.color;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: product.tint,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Icon(product.icon, color: product.color, size: 30),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.h2.copyWith(color: titleColor),
                        ),
                        Text(
                          product.category,
                          style: AppTextStyles.body.copyWith(
                            color: Theme.of(ctx).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "Tavsif",
                style: AppTextStyles.bodyStrong.copyWith(color: titleColor),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Ushbu ${product.name.toLowerCase()} chorvachilik va hayvonlarni parvarish qilishda ishlatiladi. Yuqori sifatli va sinovdan o'tgan mahsulot.",
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(ctx).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Narxi", style: AppTextStyles.caption),
                      PriceText(
                        amount: product.priceSom,
                        color: AppColors.primary,
                        style: AppTextStyles.h2,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.name} savatchaga qo'shildi!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    child: const Text(
                      "Savatchaga qo'shish",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
