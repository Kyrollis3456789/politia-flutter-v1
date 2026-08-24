import 'package:flutter/material.dart';
import 'package:politia/core/localization/app_locales.dart';
import 'package:politia/services/locale_service.dart';

/// Interactive, searchable bottom sheet / dialog for picking from all 131 supported locales.
class LanguageSelectionSheet extends StatefulWidget {
  const LanguageSelectionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LanguageSelectionSheet(),
    );
  }

  @override
  State<LanguageSelectionSheet> createState() => _LanguageSelectionSheetState();
}

class _LanguageSelectionSheetState extends State<LanguageSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  LocaleCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PolitiaLocaleMetadata> get _filteredLocales {
    return PolitiaLocales.all.where((meta) {
      if (_selectedCategory != null && meta.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isEmpty) return true;

      return meta.englishName.toLowerCase().contains(_searchQuery) ||
          meta.nativeName.toLowerCase().contains(_searchQuery) ||
          meta.tag.toLowerCase().contains(_searchQuery) ||
          meta.languageCode.toLowerCase().contains(_searchQuery) ||
          (meta.countryCode?.toLowerCase().contains(_searchQuery) ?? false);
    }).toList();
  }

  bool _isCurrentlyActive(PolitiaLocaleMetadata? meta) {
    final current = LocaleService.instance.currentLocale;
    if (meta == null) {
      return current == null;
    }
    if (current == null) return false;

    if (current.languageCode != meta.languageCode) return false;
    if (meta.countryCode != null && current.countryCode != meta.countryCode) {
      return false;
    }
    if (meta.scriptCode != null && current.scriptCode != meta.scriptCode) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    final filtered = _filteredLocales;

    return Container(
      height: mediaQuery.size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(
                  Icons.language_rounded,
                  color: theme.colorScheme.primary,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Language / اختر اللغة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '131 UI Locales & Regional Variations',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search language, country, code...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: isDark ? const Color(0xFF2A2A32) : const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildCategoryChip('All (131)', null),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  'Liturgical (4)',
                  LocaleCategory.liturgical,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  'Global Multi-Regional (65)',
                  LocaleCategory.global,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  'European (34)',
                  LocaleCategory.european,
                ),
                const SizedBox(width: 8),
                _buildCategoryChip(
                  'Asian & African (28)',
                  LocaleCategory.asianAfrican,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          // Locales List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // System Default Option
                if (_searchQuery.isEmpty && _selectedCategory == null)
                  _buildLocaleTile(
                    title: 'System Default / إعدادات النظام',
                    subtitle: 'Use device operating system language',
                    tag: 'system',
                    isSelected: _isCurrentlyActive(null),
                    onTap: () {
                      LocaleService.instance.setLocale(null);
                      Navigator.of(context).pop();
                    },
                  ),

                // Render Filtered Locales
                ...filtered.map((meta) {
                  final isSelected = _isCurrentlyActive(meta);
                  return _buildLocaleTile(
                    title: meta.nativeName,
                    subtitle: meta.englishName,
                    tag: meta.tag,
                    isRtl: meta.isRtl,
                    isSelected: isSelected,
                    onTap: () {
                      LocaleService.instance.setLocale(meta.toLocale());
                      Navigator.of(context).pop();
                    },
                  );
                }),

                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'No matching languages found',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, LocaleCategory? category) {
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.white : null,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategory = category;
        });
      },
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF2A2A32)
          : const Color(0xFFF3F4F6),
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }

  Widget _buildLocaleTile({
    required String title,
    required String subtitle,
    required String tag,
    bool isRtl = false,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: primaryColor.withValues(alpha: 0.4), width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        onTap: onTap,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? primaryColor : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.8)
                : Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: primaryColor)
            : null,
      ),
    );
  }
}
