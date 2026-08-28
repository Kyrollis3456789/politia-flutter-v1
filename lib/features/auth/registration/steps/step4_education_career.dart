import 'package:flutter/material.dart';
import 'package:politia/features/auth/registration/models/registration_catalogs.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Milestone 4: Education & Career (Step4EducationWork)
class Step4EducationCareer extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4EducationCareer({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4EducationCareer> createState() => _Step4EducationCareerState();
}

class _Step4EducationCareerState extends State<Step4EducationCareer> {
  final _formKey = GlobalKey<FormState>();

  // Basic education controllers
  late final TextEditingController _schoolNameController;

  // Working / Career controllers
  late final TextEditingController _jobTitleController;
  late final TextEditingController _companyController;
  late final TextEditingController _postGradDegreeController;

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _schoolNameController = TextEditingController(text: draft.schoolName);
    _jobTitleController = TextEditingController(text: draft.jobTitle);
    _companyController = TextEditingController(text: draft.companyName);
    _postGradDegreeController = TextEditingController(text: draft.postGraduateDegree);

    // Auto routing by age: if age < 17, enforce basic
    final age = draft.calculatedAge;
    if (age != null && age < 17) {
      widget.notifier.updateDraft((d) => d.educationCategory = 'basic');
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _postGradDegreeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.notifier.updateDraft((d) {
      d.schoolName = _schoolNameController.text.trim();
      d.jobTitle = _jobTitleController.text.trim();
      d.companyName = _companyController.text.trim();
      d.postGraduateDegree = _postGradDegreeController.text.trim();
    });

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final draft = widget.notifier.draft;
    final age = draft.calculatedAge ?? 20;

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
                    'Education & Career',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provide your academic or professional pathway to tailor church programs & activities.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Pathway Selector (only for age >= 17)
                  if (age >= 17) ...[
                    Text(
                      'Current Pathway / المسار الحالي',
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
                          child: _buildPathwayCard(
                            title: 'School',
                            subtitle: 'Basic Ed',
                            icon: Icons.school_outlined,
                            isSelected: draft.educationCategory == 'basic',
                            onTap: () {
                              widget.notifier.updateDraft((d) => d.educationCategory = 'basic');
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPathwayCard(
                            title: 'University',
                            subtitle: 'Higher Ed',
                            icon: Icons.account_balance_outlined,
                            isSelected: draft.educationCategory == 'university',
                            onTap: () {
                              widget.notifier.updateDraft((d) => d.educationCategory = 'university');
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildPathwayCard(
                            title: 'Career',
                            subtitle: 'Work/Grad',
                            icon: Icons.business_center_outlined,
                            isSelected: draft.educationCategory == 'working',
                            onTap: () {
                              widget.notifier.updateDraft((d) => d.educationCategory = 'working');
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Path A: Basic Education
                  if (draft.educationCategory == 'basic') ...[
                    DropdownButtonFormField<String>(
                      initialValue: draft.basicStage ?? 'Secondary',
                      decoration: const InputDecoration(
                        labelText: 'Education Stage / المرحلة الدراسية',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: ['Primary / ابتدائي', 'Preparatory / إعدادي', 'Secondary / ثانوي']
                          .map((e) => DropdownMenuItem(value: e.split(' / ').first, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.basicStage = val);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: draft.basicSystem ?? 'General / Thanaweya',
                      decoration: const InputDecoration(
                        labelText: 'Educational System / النظام التعليمي',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: ['General / Thanaweya', 'American', 'IGCSE', 'Baccalaureate', 'STEM', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.basicSystem = val);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomAuthTextField(
                      label: 'School Name / اسم المدرسة',
                      controller: _schoolNameController,
                      hintText: 'e.g. St. George School',
                    ),
                  ],

                  // Path B: University / Higher Ed
                  if (draft.educationCategory == 'university') ...[
                    DropdownButtonFormField<String>(
                      initialValue: draft.universityName ?? EgyptianLocationsData.universitiesList.first,
                      decoration: const InputDecoration(
                        labelText: 'University / الجامعة',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: EgyptianLocationsData.universitiesList
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.universityName = val);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: draft.facultyName ?? EgyptianLocationsData.facultiesList.first,
                      decoration: const InputDecoration(
                        labelText: 'Faculty / الكلية',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: EgyptianLocationsData.facultiesList
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.facultyName = val);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<int>(
                      initialValue: draft.academicYear ?? 1,
                      decoration: const InputDecoration(
                        labelText: 'Academic Year / الفرقة الدراسية',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: List.generate(7, (i) => i + 1)
                          .map((yr) => DropdownMenuItem(value: yr, child: Text('Year $yr (الفرقة $yr)')))
                          .toList(),
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.academicYear = val);
                        setState(() {});
                      },
                    ),
                  ],

                  // Path C: Graduated / Career
                  if (draft.educationCategory == 'working') ...[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Currently Employed / يعمل حالياً', style: TextStyle(fontWeight: FontWeight.w600)),
                      value: draft.isWorking,
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.isWorking = val);
                        setState(() {});
                      },
                    ),
                    if (draft.isWorking) ...[
                      const SizedBox(height: 8),
                      CustomAuthTextField(
                        label: 'Job Title / المسمى الوظيفي',
                        controller: _jobTitleController,
                        hintText: 'e.g. Civil Engineer, Accountant',
                      ),
                      const SizedBox(height: 16),
                      CustomAuthTextField(
                        label: 'Company / Organization / جهة العمل',
                        controller: _companyController,
                        hintText: 'e.g. Petrojet, Vodafone',
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Post graduate toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Post-Graduate Studies / دراسات عليا (Master / PhD)', style: TextStyle(fontSize: 13)),
                      value: draft.hasPostGraduate,
                      onChanged: (val) {
                        widget.notifier.updateDraft((d) => d.hasPostGraduate = val);
                        setState(() {});
                      },
                    ),
                    if (draft.hasPostGraduate) ...[
                      CustomAuthTextField(
                        label: 'Degree Details / تخصص الدراسات العليا',
                        controller: _postGradDegreeController,
                        hintText: 'e.g. Master of Science in AI',
                      ),
                    ],

                    // Retired option (restricted to age >= 60)
                    if (age >= 60) ...[
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Retired / على المعاش', style: TextStyle(fontSize: 13)),
                        value: draft.isRetired,
                        onChanged: (val) {
                          widget.notifier.updateDraft((d) => d.isRetired = val);
                          setState(() {});
                        },
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Navigation Buttons
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
                  child: const Text('Continue to Residence', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPathwayCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF1E2633) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primary : Colors.grey[500], size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
                color: isSelected ? primary : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
