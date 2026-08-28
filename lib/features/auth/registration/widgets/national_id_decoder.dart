/// Egyptian 14-digit National ID decoding algorithm.
class NationalIdResult {
  final bool isValid;
  final String? errorMessage;
  final DateTime? birthDate;
  final String? gender;
  final String? governorate;

  const NationalIdResult({
    required this.isValid,
    this.errorMessage,
    this.birthDate,
    this.gender,
    this.governorate,
  });

  static const Map<String, String> _governorateCodes = {
    '01': 'Cairo',
    '02': 'Alexandria',
    '03': 'Port Said',
    '04': 'Suez',
    '11': 'Damietta',
    '12': 'Dakahlia',
    '13': 'Ash Sharqia',
    '14': 'Al Qalyubia',
    '15': 'Kafr El Sheikh',
    '16': 'Gharbia',
    '17': 'Monufia',
    '18': 'El Beheira',
    '19': 'Ismailia',
    '21': 'Giza',
    '22': 'Beni Suef',
    '23': 'Faiyum',
    '24': 'Minya',
    '25': 'Assiut',
    '26': 'Sohag',
    '27': 'Qena',
    '28': 'Aswan',
    '29': 'Luxor',
    '31': 'Red Sea',
    '32': 'New Valley',
    '33': 'Matrouh',
    '34': 'North Sinai',
    '35': 'South Sinai',
    '88': 'Foreign Born',
  };

  static NationalIdResult decode(String? rawId) {
    if (rawId == null || rawId.trim().isEmpty) {
      return const NationalIdResult(isValid: false, errorMessage: 'National ID cannot be empty');
    }

    final id = rawId.trim();
    if (id.length != 14 || !RegExp(r'^\d{14}$').hasMatch(id)) {
      return const NationalIdResult(isValid: false, errorMessage: 'Must be exactly 14 digits');
    }

    // 1st digit: Century (2 = 1900-1999, 3 = 2000-2099)
    final centuryDigit = int.parse(id[0]);
    if (centuryDigit != 2 && centuryDigit != 3) {
      return const NationalIdResult(isValid: false, errorMessage: 'Invalid century digit');
    }
    final centuryPrefix = centuryDigit == 2 ? 1900 : 2000;

    // Digits 2-7: YYMMDD
    final year = centuryPrefix + int.parse(id.substring(1, 3));
    final month = int.parse(id.substring(3, 5));
    final day = int.parse(id.substring(5, 7));

    if (month < 1 || month > 12) {
      return const NationalIdResult(isValid: false, errorMessage: 'Invalid birth month');
    }
    if (day < 1 || day > 31) {
      return const NationalIdResult(isValid: false, errorMessage: 'Invalid birth day');
    }

    DateTime birthDate;
    try {
      birthDate = DateTime(year, month, day);
      if (birthDate.isAfter(DateTime.now())) {
        return const NationalIdResult(isValid: false, errorMessage: 'Birth date cannot be in the future');
      }
    } catch (_) {
      return const NationalIdResult(isValid: false, errorMessage: 'Invalid birth date');
    }

    // Digits 8-9: Governorate Code
    final govCode = id.substring(7, 9);
    final govName = _governorateCodes[govCode] ?? 'Unknown Governorate';

    // Digit 13: Gender (Odd = Male, Even = Female)
    final genderDigit = int.parse(id[12]);
    final gender = (genderDigit % 2 != 0) ? 'male' : 'female';

    return NationalIdResult(
      isValid: true,
      birthDate: birthDate,
      gender: gender,
      governorate: govName,
    );
  }
}
