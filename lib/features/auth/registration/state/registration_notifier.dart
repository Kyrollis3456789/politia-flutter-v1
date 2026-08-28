import 'package:flutter/foundation.dart';
import 'package:politia/features/auth/registration/models/registration_draft.dart';

/// State management notifier maintaining the multi-step registration in-memory draft.
///
/// Lifecycle Rules:
/// 1. App Cold Start / Fresh Launch: Draft is completely empty by default.
/// 2. In-Session Navigation (Sign In <-> Sign Up): Draft is preserved in-memory.
/// 3. Clear Data: Resets in-memory draft to empty.
class RegistrationNotifier extends ChangeNotifier {
  static final RegistrationNotifier _instance = RegistrationNotifier._internal();

  /// Session singleton instance for in-memory registration draft preservation
  factory RegistrationNotifier() => _instance;

  RegistrationNotifier._internal();

  RegistrationDraft _draft = RegistrationDraft();
  int _currentStep = 0;
  bool _isLoading = false;

  RegistrationDraft get draft => _draft;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;

  /// Resets the in-memory draft state to an empty state.
  void clearDraft() {
    _draft = RegistrationDraft();
    _currentStep = 0;
    notifyListeners();
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 7) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 7) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void updateDraft(void Function(RegistrationDraft draft) updater) {
    updater(_draft);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
