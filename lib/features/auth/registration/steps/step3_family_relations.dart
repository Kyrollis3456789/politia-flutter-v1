import 'package:flutter/material.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Milestone 3: Family Relations (FamilyRelationsStep)
class Step3FamilyRelations extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3FamilyRelations({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3FamilyRelations> createState() => _Step3FamilyRelationsState();
}

class _Step3FamilyRelationsState extends State<Step3FamilyRelations> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fatherController;
  late final TextEditingController _motherController;
  late final TextEditingController _spouseController;
  final TextEditingController _relativeSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _fatherController = TextEditingController(text: draft.fatherNameOrPhone);
    _motherController = TextEditingController(text: draft.motherNameOrPhone);
    _spouseController = TextEditingController(text: draft.spouseNameOrPhone);
  }

  @override
  void dispose() {
    _fatherController.dispose();
    _motherController.dispose();
    _spouseController.dispose();
    _relativeSearchController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.notifier.updateDraft((d) {
      d.fatherNameOrPhone = _fatherController.text.trim();
      d.motherNameOrPhone = _motherController.text.trim();
      d.spouseNameOrPhone = _spouseController.text.trim();
    });

    widget.onNext();
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Family Relations',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Link your family members for unified church and service record keeping.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Parents Linking
                  CustomAuthTextField(
                    label: "Father's Name or Mobile / بيانات الوالد (الأب)",
                    controller: _fatherController,
                    hintText: 'Name or 010xxxxxxx',
                  ),
                  const SizedBox(height: 16),

                  CustomAuthTextField(
                    label: "Mother's Name or Mobile / بيانات الوالدة (الأم)",
                    controller: _motherController,
                    hintText: 'Name or 010xxxxxxx',
                  ),
                  const SizedBox(height: 20),

                  // Marital Status Toggle
                  Text(
                    'Marital Status / الحالة الاجتماعية',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceChip(
                          label: 'Single / أعزب',
                          isSelected: draft.maritalStatus == 'single',
                          onTap: () {
                            widget.notifier.updateDraft((d) => d.maritalStatus = 'single');
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChoiceChip(
                          label: 'Married / متزوج',
                          isSelected: draft.maritalStatus == 'married',
                          onTap: () {
                            widget.notifier.updateDraft((d) => d.maritalStatus = 'married');
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Married conditional details
                  if (draft.maritalStatus == 'married') ...[
                    CustomAuthTextField(
                      label: "Spouse's Name or Mobile / بيانات الزوج أو الزوجة",
                      controller: _spouseController,
                      hintText: 'Spouse full name or phone',
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Advanced Relatives Search Card (Debounced search >= 4 chars)
                  Text(
                    'Extended Relatives (Optional)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomAuthTextField(
                    label: 'Search Relatives by Name or Mobile',
                    controller: _relativeSearchController,
                    hintText: 'Type at least 4 characters...',
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                  if (_relativeSearchController.text.trim().length >= 4)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_search_rounded, color: primary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Search query ready for "${_relativeSearchController.text.trim()}". Send link request upon submit.',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
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
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Continue to Education', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF1E2633) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primary : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
