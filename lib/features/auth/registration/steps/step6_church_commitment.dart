import 'package:flutter/material.dart';
import 'package:politia/features/auth/registration/models/registration_catalogs.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Milestone 6: Church Commitment (Step6ChurchCommitment)
class Step6ChurchCommitment extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step6ChurchCommitment({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step6ChurchCommitment> createState() => _Step6ChurchCommitmentState();
}

class _Step6ChurchCommitmentState extends State<Step6ChurchCommitment> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _customPrimaryChurchController;
  late final TextEditingController _secondaryChurchController;
  late final TextEditingController _fatherOfConfessionController;

  static const List<String> _deaconRanks = [
    'None / ليس شماساً',
    'Epsaltos / إبصالتس (مرتل)',
    'Anagnostis / أغنسطس (قارئ)',
    'Hypodeacon / إيبودياكون (مساعد شماس)',
    'Deacon / دياكون (شماس كامل)',
    'Archdeacon / أرشدياكون (رئيس الشمامسة)',
  ];

  static const List<String> _serviceRoles = [
    'Sunday School Service',
    'Scouting & Guides',
    'Choir & Hymns Service',
    'Media & Broadcast Service',
    'Elderly & Sick Care',
    'Bible Study Prep',
  ];

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _customPrimaryChurchController = TextEditingController();
    _secondaryChurchController = TextEditingController(text: draft.secondaryChurch);
    _fatherOfConfessionController = TextEditingController(text: draft.fatherOfConfession);

    // Derive Diocese automatically from governorate
    final diocese = EgyptianLocationsData.getDioceseForGovernorate(draft.governorate);
    widget.notifier.updateDraft((d) => d.diocese = diocese);
  }

  @override
  void dispose() {
    _customPrimaryChurchController.dispose();
    _secondaryChurchController.dispose();
    _fatherOfConfessionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.notifier.updateDraft((d) {
      if (_customPrimaryChurchController.text.trim().isNotEmpty) {
        d.primaryChurch = _customPrimaryChurchController.text.trim();
      }
      d.secondaryChurch = _secondaryChurchController.text.trim();
      d.fatherOfConfession = _fatherOfConfessionController.text.trim();
    });

    if (widget.notifier.draft.primaryChurch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter your primary church')),
      );
      return;
    }

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final draft = widget.notifier.draft;

    final churches = EgyptianLocationsData.churchesByGovernorate[draft.governorate] ??
        ['St. Mark Coptic Orthodox Cathedral', 'St. George Church', 'St. Mary Church'];

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
                    'Church Commitment',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Connect your local church parish, diocese, and spiritual father of confession.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Diocese Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.church_rounded, color: primary, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Diocese Affiliation (Automatic)',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                draft.diocese ?? 'Diocese of ${draft.governorate}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Primary Church Cascading Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: churches.contains(draft.primaryChurch) ? draft.primaryChurch : churches.first,
                    decoration: InputDecoration(
                      labelText: 'Primary Church / الكنيسة الأساسية (${draft.governorate})',
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: churches.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        widget.notifier.updateDraft((d) => d.primaryChurch = val);
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Custom church fallback input
                  CustomAuthTextField(
                    label: 'Or type custom church name if not listed',
                    controller: _customPrimaryChurchController,
                    hintText: 'e.g. St. Mina Church, Shubra',
                  ),
                  const SizedBox(height: 18),

                  // Secondary Church (Optional)
                  CustomAuthTextField(
                    label: 'Secondary Church regularly attended / كنيسة ثانوية (Optional)',
                    controller: _secondaryChurchController,
                    hintText: 'e.g. Monastery of St. Bishoy, Wadi El Natrun',
                  ),
                  const SizedBox(height: 18),

                  // Father of Confession
                  CustomAuthTextField(
                    label: 'Father of Confession / أب الاعتراف (Optional)',
                    controller: _fatherOfConfessionController,
                    hintText: 'e.g. Fr. Daoud Lamei / أبونا داود لمعي',
                  ),
                  const SizedBox(height: 20),

                  // Deacon Rank Selection
                  DropdownButtonFormField<String>(
                    initialValue: draft.deaconRank ?? _deaconRanks.first,
                    decoration: const InputDecoration(
                      labelText: 'Deacon Rank / الرتبة الشماسية',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: _deaconRanks.map((r) => DropdownMenuItem(value: r, child: Text(r, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) {
                      widget.notifier.updateDraft((d) => d.deaconRank = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),

                  // Ecclesiastical Service Roles
                  Text(
                    'Church Services & Scouting',
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
                    children: _serviceRoles.map((role) {
                      final isSelected = draft.churchServices.contains(role);
                      return FilterChip(
                        label: Text(role, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),
                        selected: isSelected,
                        onSelected: (selected) {
                          widget.notifier.updateDraft((d) {
                            if (selected) {
                              d.churchServices = [...d.churchServices, role];
                            } else {
                              d.churchServices = d.churchServices.where((r) => r != role).toList();
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
                  child: const Text('Continue to Hobbies', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
