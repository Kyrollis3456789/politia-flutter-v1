/// Identified input category from the unified sign-in input field.
enum InputType {
  email,
  phone,
  memberId,
  unrecognized,
}

/// Smart Input Detection Engine for Politeia Sign-In.
/// Dispatches credentials intelligently between Email, Egyptian/E.164 Phone, and Member ID.
class InputDetector {
  InputDetector._();

  static final RegExp _memberIdRegex = RegExp(r'^00\d{9}$');
  static final RegExp _emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
  static final RegExp _egyptianPhoneRegex = RegExp(r'^(?:\+20|0020|0)?(1[0125]\d{8})$');
  static final RegExp _e164PhoneRegex = RegExp(r'^\+[1-9]\d{7,14}$');

  /// Detects the type of user input for authentication.
  /// 1. Member ID: strictly ^00\d{9}$ (11 digits starting with 00)
  /// 2. Email: contains '@'
  /// 3. Phone: Egyptian (010, 011, 012, 015) or international E.164 (+...)
  /// 4. Unrecognized: anything else
  static InputType detect(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return InputType.unrecognized;

    // 1. Check Member ID first (strictly ^00\d{9}$)
    if (_memberIdRegex.hasMatch(clean)) {
      return InputType.memberId;
    }

    // 2. Check Email (contains '@')
    if (clean.contains('@')) {
      if (_emailRegex.hasMatch(clean)) {
        return InputType.email;
      }
      return InputType.email;
    }

    // 3. Check Phone format
    if (_egyptianPhoneRegex.hasMatch(clean) || _e164PhoneRegex.hasMatch(clean)) {
      return InputType.phone;
    }

    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('01') && digits.length == 11) {
      final prefix = digits.substring(0, 3);
      if (['010', '011', '012', '015'].contains(prefix)) {
        return InputType.phone;
      }
    }
    if (digits.startsWith('201') && digits.length == 12) {
      return InputType.phone;
    }

    return InputType.unrecognized;
  }

  /// Normalizes an Egyptian or international phone number to standard E.164 (+201xxxxxxxxx).
  static String normalizePhone(String phone) {
    final clean = phone.trim();
    if (clean.startsWith('+')) {
      return clean.replaceAll(RegExp(r'[^\d+]'), '');
    }

    final digits = clean.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('01') && digits.length == 11) {
      return '+20${digits.substring(1)}';
    }
    if (digits.startsWith('201') && digits.length == 12) {
      return '+$digits';
    }
    if (digits.startsWith('00201') && digits.length == 14) {
      return '+${digits.substring(2)}';
    }
    return '+$digits';
  }

  /// Extracts the 2-digit region code from an 11-digit Member ID.
  static String? getMemberIdRegionCode(String memberId) {
    final clean = memberId.trim();
    if (_memberIdRegex.hasMatch(clean)) {
      return clean.substring(2, 4);
    }
    return null;
  }

  /// Extracts the 7-digit serial number from an 11-digit Member ID.
  static String? getMemberIdSerial(String memberId) {
    final clean = memberId.trim();
    if (_memberIdRegex.hasMatch(clean)) {
      return clean.substring(4);
    }
    return null;
  }

  /// Region name descriptor for Member ID metadata lookup.
  static const Map<String, String> regionCodes = {
    '01': 'Africa (Global)',
    '02': 'Asia (Global)',
    '03': 'Europe (Global)',
    '04': 'North America (Global)',
    '05': 'South America (Global)',
    '06': 'Australia (Global)',
    '07': 'Antarctica (Global)',
    '10': 'Asyut', '11': 'Asyut', '12': 'Asyut',
    '13': 'Cairo', '14': 'Cairo', '15': 'Cairo',
    '16': 'Giza', '17': 'Giza', '18': 'Giza',
    '19': 'Alexandria', '20': 'Alexandria', '21': 'Alexandria',
    '22': 'Minya', '23': 'Minya', '24': 'Minya',
    '25': 'Sohag', '26': 'Sohag', '27': 'Sohag',
    '28': 'Qena', '29': 'Qena', '30': 'Qena',
    '31': 'Qalyubia', '32': 'Qalyubia',
    '33': 'Dakahlia', '34': 'Dakahlia',
    '35': 'Sharqia', '36': 'Sharqia',
    '37': 'Beheira', '38': 'Beheira',
    '39': 'Gharbia', '40': 'Gharbia',
    '41': 'Menofia', '42': 'Menofia',
    '43': 'Kafr El Sheikh', '44': 'Kafr El Sheikh',
    '45': 'Fayoum', '46': 'Fayoum',
    '47': 'Beni Suef', '48': 'Beni Suef',
    '49': 'Aswan', '50': 'Aswan',
    '51': 'Luxor', '52': 'Luxor',
    '53': 'Red Sea', '54': 'Red Sea',
    '55': 'Port Said', '56': 'Port Said',
    '57': 'Suez', '58': 'Suez',
    '59': 'Ismailia', '60': 'Ismailia',
    '61': 'Damietta', '62': 'Damietta',
    '63': 'North Sinai', '64': 'North Sinai',
    '65': 'South Sinai', '66': 'South Sinai',
    '67': 'Matrouh', '68': 'Matrouh',
    '69': 'New Valley', '70': 'New Valley',
  };
}
