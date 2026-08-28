import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Robust English-to-Arabic Name Transliteration Service
/// Combines an online API with a rich Coptic & Egyptian Christian name dictionary.
class NameTransliterationService {
  NameTransliterationService._();

  static final Map<String, String> _knownNames = {
    // Common Biblical & Coptic Names
    'kyrollis': 'كيرلس',
    'kyrollos': 'كيرلس',
    'cyril': 'كيرلس',
    'kirollos': 'كيرلس',
    'kerolos': 'كيرلس',
    'keroles': 'كيرلس',
    'maikel': 'مايكل',
    'michael': 'مايكل',
    'mikhail': 'ميخائيل',
    'mina': 'مينا',
    'meena': 'مينا',
    'mena': 'مينا',
    'bishoy': 'بيشوي',
    'beshoy': 'بيشوي',
    'shenouda': 'شنودة',
    'shenoudeh': 'شنودة',
    'george': 'جورج',
    'giorgis': 'جرجس',
    'girgis': 'جرجس',
    'gregory': 'غريغوريوس',
    'abanoub': 'أبانوب',
    'abanob': 'أبانوب',
    'fadi': 'فادي',
    'fady': 'فادي',
    'mark': 'مرقس',
    'marcus': 'مرقس',
    'morcos': 'مرقس',
    'morkos': 'مرقس',
    'john': 'يوحنا',
    'yohanna': 'يوحنا',
    'youhanna': 'يوحنا',
    'david': 'داود',
    'dawood': 'داود',
    'peter': 'بطرس',
    'boulos': 'بولس',
    'paul': 'بولس',
    'tony': 'طوني',
    'antony': 'أنطونيوس',
    'anton': 'أنطون',
    'antonios': 'أنطونيوس',
    'maged': 'ماجد',
    'magdy': 'مجدي',
    'sameh': 'سامح',
    'samir': 'سمير',
    'hany': 'هاني',
    'hani': 'هاني',
    'nader': 'نادر',
    'rami': 'رامي',
    'ramy': 'رامي',
    'wagdy': 'وجدي',
    'remon': 'ريمون',
    'raymond': 'ريمون',
    'nabih': 'نبيه',
    'nabil': 'نبيل',
    'malek': 'مالك',
    'malak': 'ملاك',
    'adel': 'عادل',
    'atef': 'عاطف',
    'ashraf': 'أشرف',
    'emad': 'عماد',
    'ezzat': 'عزت',
    'medhat': 'مدحت',
    'monir': 'منير',
    'mounir': 'منير',
    'mourad': 'مراد',
    'murad': 'مراد',
    'raouf': 'رؤوف',
    'raef': 'رائف',
    'victor': 'فيكتور',
    'fawzy': 'فوزي',
    'kamal': 'كمال',
    'sami': 'سامي',
    'sammy': 'سامي',
    'shafik': 'شفيق',
    'shukri': 'شكري',
    'tamer': 'تامر',
    'tareq': 'طارق',
    'tarek': 'طارق',
    'youssef': 'يوسف',
    'joseph': 'يوسف',
    'yacoub': 'يعقوب',
    'jacob': 'يعقوب',
    'matthew': 'متى',
    'matta': 'متى',
    'luke': 'لوقا',
    'louka': 'لوقا',
    'stephen': 'إسطفانوس',
    'estefanous': 'إسطفانوس',
    'thomas': 'توما',
    'toma': 'توما',
    'simon': 'سمعان',
    'soliman': 'سليمان',
    'suliman': 'سليمان',
    'ibrahim': 'إبراهيم',
    'abraham': 'إبراهيم',
    'isaac': 'إسحق',
    'ishak': 'إسحق',
    'gerges': 'جرجس',
    'hanna': 'حنا',
    'ghaly': 'غالي',
    'nassif': 'نصيف',
    'habib': 'حبيب',
    'farag': 'فرج',
    'farid': 'فريد',
    'fahmy': 'فهمي',
    'fayez': 'فايز',
    'fawzi': 'فوزي',
    'salib': 'صليب',
    'sobhy': 'صبحي',
    'sadek': 'صادق',
    'samuel': 'صموئيل',
    'daniel': 'دانيال',
    'elias': 'إيليا',
    'ayman': 'أيمن',
    'amgad': 'أمجد',
    'amr': 'عمرو',
    'sherif': 'شريف',
    'hossam': 'حسام',
  };

  /// Transliterates a full English name to Arabic.
  static Future<String> transliterate(String fullNameEn) async {
    final cleanInput = fullNameEn.trim();
    if (cleanInput.isEmpty) return '';

    final parts = cleanInput.split(RegExp(r'\s+'));
    final List<String> resultParts = [];

    // 1. Try local dictionary for each word
    bool allMatchedLocally = true;
    for (final part in parts) {
      final key = part.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (_knownNames.containsKey(key)) {
        resultParts.add(_knownNames[key]!);
      } else {
        allMatchedLocally = false;
        break;
      }
    }

    if (allMatchedLocally && resultParts.length == parts.length) {
      return resultParts.join(' ');
    }

    // 2. If any part was not in local dictionary, call lightweight translation endpoint
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=ar&dt=t&q=${Uri.encodeComponent(cleanInput)}',
      );

      final request = await client.getUrl(uri);
      final response = await request.close().timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final dynamic data = jsonDecode(body);
        if (data is List && data.isNotEmpty && data[0] is List) {
          final buffer = StringBuffer();
          for (final item in data[0]) {
            if (item is List && item.isNotEmpty) {
              buffer.write(item[0]);
            }
          }
          final translated = buffer.toString().trim();
          if (translated.isNotEmpty) {
            return translated;
          }
        }
      }
      client.close();
    } catch (e) {
      debugPrint('Online transliteration exception: $e');
    }

    // 3. Fallback: Hybrid dictionary + phonetic mapping
    final fallbackList = <String>[];
    for (final part in parts) {
      final key = part.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (_knownNames.containsKey(key)) {
        fallbackList.add(_knownNames[key]!);
      } else {
        fallbackList.add(_phoneticFallback(part));
      }
    }

    return fallbackList.join(' ');
  }

  static String _phoneticFallback(String text) {
    String t = text.toLowerCase();
    t = t.replaceAll('kh', 'خ');
    t = t.replaceAll('sh', 'ش');
    t = t.replaceAll('th', 'ث');
    t = t.replaceAll('ph', 'ف');
    t = t.replaceAll('gh', 'غ');
    t = t.replaceAll('ou', 'و');
    t = t.replaceAll('ee', 'ي');
    t = t.replaceAll('aa', 'ا');

    final map = {
      'a': 'ا', 'b': 'ب', 'c': 'ك', 'd': 'د', 'e': 'ي',
      'f': 'ف', 'g': 'ج', 'h': 'ه', 'i': 'ي', 'j': 'ج',
      'k': 'ك', 'l': 'ل', 'm': 'م', 'n': 'ن', 'o': 'و',
      'p': 'ب', 'q': 'ق', 'r': 'ر', 's': 'س', 't': 'ت',
      'u': 'و', 'v': 'ف', 'w': 'و', 'x': 'كس', 'y': 'ي', 'z': 'ز',
    };

    final buf = StringBuffer();
    for (int i = 0; i < t.length; i++) {
      final char = t[i];
      buf.write(map[char] ?? char);
    }
    return buf.toString();
  }
}
