import 'package:flutter/material.dart';
import 'package:politia/features/auth/registration/models/registration_catalogs.dart';
import 'package:politia/features/auth/registration/state/registration_notifier.dart';
import 'package:politia/widgets/custom_text_field.dart';

/// Milestone 5: Residential Locations (Step5Locations)
class Step5ResidentialLocations extends StatefulWidget {
  final RegistrationNotifier notifier;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5ResidentialLocations({
    super.key,
    required this.notifier,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5ResidentialLocations> createState() => _Step5ResidentialLocationsState();
}

class _Step5ResidentialLocationsState extends State<Step5ResidentialLocations> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _streetAddressController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _secondaryAddressController;

  bool _showSecondaryAddress = false;

  @override
  void initState() {
    super.initState();
    final draft = widget.notifier.draft;
    _streetAddressController = TextEditingController(text: draft.streetAddress);
    _buildingController = TextEditingController(text: draft.buildingNumber);
    _floorController = TextEditingController(text: draft.floorNumber);
    _apartmentController = TextEditingController(text: draft.apartmentNumber);
    _secondaryAddressController = TextEditingController(text: draft.secondaryAddress);
    _showSecondaryAddress = draft.secondaryAddress != null && draft.secondaryAddress!.isNotEmpty;
  }

  @override
  void dispose() {
    _streetAddressController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _secondaryAddressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.notifier.updateDraft((d) {
      d.streetAddress = _streetAddressController.text.trim();
      d.buildingNumber = _buildingController.text.trim();
      d.floorNumber = _floorController.text.trim();
      d.apartmentNumber = _apartmentController.text.trim();
      d.secondaryAddress = _showSecondaryAddress ? _secondaryAddressController.text.trim() : null;
    });

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final draft = widget.notifier.draft;

    final governorates = EgyptianLocationsData.governoratesAndCities.keys.toList();
    final cities = EgyptianLocationsData.governoratesAndCities[draft.governorate] ?? ['Center City'];

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
                    'Residential Location',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cinzel',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Primary residence location for geographical parish mapping & visitation services.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Country Selector
                  DropdownButtonFormField<String>(
                    initialValue: draft.country,
                    decoration: const InputDecoration(
                      labelText: 'Country / الدولة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: ['Egypt', 'United States', 'Canada', 'Australia', 'United Kingdom', 'United Arab Emirates', 'Kuwait']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        widget.notifier.updateDraft((d) => d.country = val);
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Governorate Selector
                  DropdownButtonFormField<String>(
                    initialValue: governorates.contains(draft.governorate) ? draft.governorate : governorates.first,
                    decoration: const InputDecoration(
                      labelText: 'Governorate / المحافظة',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        widget.notifier.updateDraft((d) {
                          d.governorate = val;
                          final availCities = EgyptianLocationsData.governoratesAndCities[val];
                          if (availCities != null && availCities.isNotEmpty) {
                            d.city = availCities.first;
                          }
                        });
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // City Selector
                  DropdownButtonFormField<String>(
                    initialValue: cities.contains(draft.city) ? draft.city : cities.first,
                    decoration: const InputDecoration(
                      labelText: 'City / District / المركز أو الحي',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        widget.notifier.updateDraft((d) => d.city = val);
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Interactive Map Pin Dropper Mock Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2633) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.my_location_rounded, color: primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Map Pin Location Dropper',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                'Reverse geocoded to: ${draft.city}, ${draft.governorate}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Pin saved at ${draft.city}, ${draft.governorate}')),
                            );
                          },
                          child: const Text('Pick Pin'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Detailed Street Address
                  CustomAuthTextField(
                    label: 'Street Name / اسم الشارع',
                    controller: _streetAddressController,
                    hintText: 'e.g. 15 Ramses St., near Church',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Street address is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Building, Floor, Apartment
                  Row(
                    children: [
                      Expanded(
                        child: CustomAuthTextField(
                          label: 'Building No.',
                          controller: _buildingController,
                          hintText: 'e.g. 12B',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomAuthTextField(
                          label: 'Floor No.',
                          controller: _floorController,
                          hintText: 'e.g. 3',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomAuthTextField(
                          label: 'Apartment',
                          controller: _apartmentController,
                          hintText: 'e.g. 14',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Secondary Address Toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Add Secondary Residence (Work or Summer house)', style: TextStyle(fontSize: 13)),
                    value: _showSecondaryAddress,
                    onChanged: (val) {
                      setState(() {
                        _showSecondaryAddress = val;
                      });
                    },
                  ),
                  if (_showSecondaryAddress) ...[
                    const SizedBox(height: 8),
                    CustomAuthTextField(
                      label: 'Secondary Address Details',
                      controller: _secondaryAddressController,
                      hintText: 'e.g. Alexandria Summer House, Miami St.',
                    ),
                  ],
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
                  child: const Text('Continue to Church Commitment', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
