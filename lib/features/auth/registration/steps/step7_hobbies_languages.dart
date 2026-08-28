import 'package:flutter/material.dart';
import 'package:politia/features/auth/registration/models/registration_catalogs.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Milestone 7: Hobbies & Languages
class Step7HobbiesLanguages extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step7HobbiesLanguages({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step7HobbiesLanguages> createState() => _Step7HobbiesLanguagesState();
}

class _Step7HobbiesLanguagesState extends State<Step7HobbiesLanguages> {
  final TextEditingController _customHobbyController = TextEditingController();

  static const List<String> _languagesCatalog = [
    'Arabic',
    'English',
    'Coptic',
    'French',
    'German',
    'Italian',
    'Spanish',
    'Greek',
    'Syriac',
    'Russian',
  ];

  @override
  void dispose() {
    _customHobbyController.dispose();
    super.dispose();
  }

  void _addCustomHobby() {
    final text = _customHobbyController.text.trim();
    if (text.isNotEmpty) {
      widget.notifier.updateDraft((d) {
        if (!d.customHobbies.contains(text)) {
          d.customHobbies = [...d.customHobbies, text];
        }
      });
      _customHobbyController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final draft = widget.notifier.draft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hobbies & Languages',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cinzel',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Highlight your mother tongue, spoken languages, and personal talents & hobbies.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Primary Mother Tongue
                DropdownButtonFormField<String>(
                  initialValue: draft.primaryLanguage,
                  decoration: const InputDecoration(
                    labelText: 'Mother Tongue / اللغة الأم',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  items: _languagesCatalog.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      widget.notifier.updateDraft((d) => d.primaryLanguage = val);
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Additional Spoken Languages
                Text(
                  'Additional Spoken Languages / لغات إضافية',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _languagesCatalog.where((l) => l != draft.primaryLanguage).map((lang) {
                    final isSelected = draft.additionalLanguages.any((m) => m['language'] == lang);
                    return FilterChip(
                      label: Text(lang, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),
                      selected: isSelected,
                      onSelected: (selected) {
                        widget.notifier.updateDraft((d) {
                          if (selected) {
                            d.additionalLanguages = [...d.additionalLanguages, {'language': lang, 'proficiency': 3}];
                          } else {
                            d.additionalLanguages = d.additionalLanguages.where((m) => m['language'] != lang).toList();
                          }
                        });
                        setState(() {});
                      },
                      selectedColor: primary,
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Hobbies & Talents Catalog (Pill Chips)
                Text(
                  'Hobbies & Talents / الهوايات والمواهب',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: EgyptianLocationsData.hobbiesList.map((hobby) {
                    final isSelected = draft.hobbies.contains(hobby);
                    return FilterChip(
                      label: Text(hobby, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),
                      selected: isSelected,
                      onSelected: (selected) {
                        widget.notifier.updateDraft((d) {
                          if (selected) {
                            d.hobbies = [...d.hobbies, hobby];
                          } else {
                            d.hobbies = d.hobbies.where((h) => h != hobby).toList();
                          }
                        });
                        setState(() {});
                      },
                      selectedColor: primary,
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Custom Hobby Adder
                Row(
                  children: [
                    Expanded(
                      child: CustomAuthTextField(
                        label: 'Add Custom Hobby / موهبة أخرى',
                        controller: _customHobbyController,
                        hintText: 'e.g. Graphic Design, Swimming',
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _addCustomHobby,
                      icon: const Icon(Icons.add_rounded),
                      style: IconButton.styleFrom(backgroundColor: primary),
                    ),
                  ],
                ),

                // Display Custom Hobbies
                if (draft.customHobbies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: draft.customHobbies.map((h) {
                      return Chip(
                        label: Text(h, style: const TextStyle(fontSize: 12)),
                        onDeleted: () {
                          widget.notifier.updateDraft((d) {
                            d.customHobbies = d.customHobbies.where((item) => item != h).toList();
                          });
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Action Buttons
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Continue to Password', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
