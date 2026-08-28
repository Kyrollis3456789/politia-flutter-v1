/// Intelligent Coptic and Egyptian Christian Nickname / Handle Suggestion Engine.
/// Extracts the first name from an English or Arabic full name and derives
/// culturally authentic, liturgical and popular Egyptian Christian nicknames.
class NameSuggestionService {
  NameSuggestionService._();

  static final Map<String, ({String en, String ar})> _copticNicknames = {
    // K - Names
    'kyrollis': (en: 'Kiro', ar: 'كيرو'),
    'kyrollos': (en: 'Kiro', ar: 'كيرو'),
    'kirollos': (en: 'Kiro', ar: 'كيرو'),
    'kerolos': (en: 'Kiro', ar: 'كيرو'),
    'keroles': (en: 'Kiro', ar: 'كيرو'),
    'cyril': (en: 'Kiro', ar: 'كيرو'),
    'كيرلس': (en: 'Kiro', ar: 'كيرو'),
    'كاراس': (en: 'Karo', ar: 'كارو'),
    'karas': (en: 'Karo', ar: 'كارو'),
    'karass': (en: 'Karo', ar: 'كارو'),

    // M - Names
    'mina': (en: 'Mino', ar: 'مينو'),
    'meena': (en: 'Mino', ar: 'مينو'),
    'mena': (en: 'Mino', ar: 'مينو'),
    'مينا': (en: 'Mino', ar: 'مينو'),
    'maikel': (en: 'Miko', ar: 'ميكو'),
    'michael': (en: 'Miko', ar: 'ميكو'),
    'mikhail': (en: 'Miko', ar: 'ميكو'),
    'مايكل': (en: 'Miko', ar: 'ميكو'),
    'ميخائيل': (en: 'Miko', ar: 'ميكو'),
    'mark': (en: 'Marko', ar: 'ماركو'),
    'marcus': (en: 'Marko', ar: 'ماركو'),
    'morcos': (en: 'Marko', ar: 'ماركو'),
    'morkos': (en: 'Marko', ar: 'ماركو'),
    'مرقس': (en: 'Marko', ar: 'ماركو'),
    'مارك': (en: 'Marko', ar: 'ماركو'),
    'maryam': (en: 'Marioma', ar: 'مريومة'),
    'mary': (en: 'Marioma', ar: 'مريومة'),
    'marian': (en: 'Marioma', ar: 'مريومة'),
    'mariam': (en: 'Marioma', ar: 'مريومة'),
    'مريم': (en: 'Marioma', ar: 'مريومة'),
    'ماريان': (en: 'Marioma', ar: 'مريومة'),
    'marina': (en: 'Marino', ar: 'مارينو'),
    'مارينا': (en: 'Marino', ar: 'مارينو'),
    'maged': (en: 'Migoo', ar: 'ميجو'),
    'ماجد': (en: 'Migoo', ar: 'ميجو'),
    'magdy': (en: 'Magooda', ar: 'مجودة'),
    'مجدي': (en: 'Magooda', ar: 'مجودة'),
    'martina': (en: 'Marto', ar: 'مارتو'),
    'مارتينا': (en: 'Marto', ar: 'مارتو'),
    'monica': (en: 'Mona', ar: 'موني'),
    'مونيكا': (en: 'Mona', ar: 'موني'),

    // B - Names
    'bishoy': (en: 'Bisho', ar: 'بيشو'),
    'beshoy': (en: 'Bisho', ar: 'بيشو'),
    'بيشوي': (en: 'Bisho', ar: 'بيشو'),
    'boulos': (en: 'Polo', ar: 'بولو'),
    'paul': (en: 'Polo', ar: 'بولو'),
    'بولس': (en: 'Polo', ar: 'بولو'),
    'paula': (en: 'Polo', ar: 'بولو'),
    'بولا': (en: 'Polo', ar: 'بولو'),

    // A - Names
    'abanoub': (en: 'Beboo', ar: 'بيبو'),
    'abanob': (en: 'Beboo', ar: 'بيبو'),
    'أبانوب': (en: 'Beboo', ar: 'بيبو'),
    'ابانوب': (en: 'Beboo', ar: 'بيبو'),
    'antony': (en: 'Toni', ar: 'توني'),
    'anthony': (en: 'Toni', ar: 'توني'),
    'antonios': (en: 'Toni', ar: 'توني'),
    'أنطونيوس': (en: 'Toni', ar: 'توني'),
    'انطونيوس': (en: 'Toni', ar: 'توني'),
    'andrew': (en: 'Dody', ar: 'دودي'),
    'androw': (en: 'Dody', ar: 'دودي'),
    'أندرو': (en: 'Dody', ar: 'دودي'),
    'اندرو': (en: 'Dody', ar: 'دودي'),

    // P - Names
    'peter': (en: 'Peto', ar: 'بيتو'),
    'بيتر': (en: 'Peto', ar: 'بيتو'),
    'بطرس': (en: 'Peto', ar: 'بيتو'),
    'pearly': (en: 'Piro', ar: 'بيرو'),
    'بيرلي': (en: 'Piro', ar: 'بيرو'),

    // G - Names
    'george': (en: 'Gogo', ar: 'جوجو'),
    'girgis': (en: 'Gogo', ar: 'جوجو'),
    'giorgis': (en: 'Gogo', ar: 'جوجو'),
    'جورج': (en: 'Gogo', ar: 'جوجو'),
    'جرجس': (en: 'Gogo', ar: 'جوجو'),

    // D - Names
    'david': (en: 'Dodo', ar: 'دودو'),
    'dawood': (en: 'Dodo', ar: 'دودو'),
    'داود': (en: 'Dodo', ar: 'دودو'),
    'ديفيد': (en: 'Dodo', ar: 'دودو'),
    'demiana': (en: 'Didi', ar: 'ديدي'),
    'دميانة': (en: 'Didi', ar: 'ديدي'),

    // F - Names
    'fadi': (en: 'Fody', ar: 'فودي'),
    'fady': (en: 'Fody', ar: 'فودي'),
    'فادي': (en: 'Fody', ar: 'فودي'),

    // J / Y - Names
    'joseph': (en: 'Joe', ar: 'جو'),
    'youssef': (en: 'Joe', ar: 'جو'),
    'يوسف': (en: 'Joe', ar: 'جو'),
    'john': (en: 'Joni', ar: 'جوني'),
    'yohanna': (en: 'Joni', ar: 'جوني'),
    'youhanna': (en: 'Joni', ar: 'جوني'),
    'يوحنا': (en: 'Joni', ar: 'جوني'),
    'جون': (en: 'Joni', ar: 'جوني'),
    'youstina': (en: 'Yoyo', ar: 'يويو'),
    'justina': (en: 'Yoyo', ar: 'يويو'),
    'يوستينا': (en: 'Yoyo', ar: 'يويو'),

    // S - Names
    'shenouda': (en: 'Shosho', ar: 'شوشو'),
    'شنودة': (en: 'Shosho', ar: 'شوشو'),
    'samuel': (en: 'Samo', ar: 'سامو'),
    'صموئيل': (en: 'Samo', ar: 'سامو'),
    'sandra': (en: 'Sando', ar: 'ساندو'),
    'ساندرا': (en: 'Sando', ar: 'ساندو'),

    // V - Names
    'verona': (en: 'Vero', ar: 'فيرو'),
    'veronia': (en: 'Vero', ar: 'فيرو'),
    'فيرونيا': (en: 'Vero', ar: 'فيرو'),
    'فيرونا': (en: 'Vero', ar: 'فيرو'),

    // T - Names
    'thomas': (en: 'Tomi', ar: 'تومي'),
    'toma': (en: 'Tomi', ar: 'تومي'),
    'توما': (en: 'Tomi', ar: 'تومي'),
    'توماس': (en: 'Tomi', ar: 'تومي'),

    // I / C / R - Names
    'irene': (en: 'Reno', ar: 'رينو'),
    'إيريني': (en: 'Reno', ar: 'رينو'),
    'ايريني': (en: 'Reno', ar: 'رينو'),
    'christine': (en: 'Kiki', ar: 'كيكي'),
    'كريستين': (en: 'Kiki', ar: 'كيكي'),
    'rami': (en: 'Romo', ar: 'رومو'),
    'ramy': (en: 'Romo', ar: 'رومو'),
    'رامي': (en: 'Romo', ar: 'رومو'),
  };

  /// Suggests a nickname based on the given English or Arabic full name.
  /// Returns a record with English and Arabic suggestions.
  static ({String en, String ar})? suggestNickname({
    String? fullNameEn,
    String? fullNameAr,
  }) {
    // 1. Try English First Name
    if (fullNameEn != null && fullNameEn.trim().isNotEmpty) {
      final parts = fullNameEn.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        final firstName = parts.first.toLowerCase();
        if (_copticNicknames.containsKey(firstName)) {
          return _copticNicknames[firstName];
        }
        // Heuristic fallback for English:
        if (firstName.length >= 4) {
          final prefix = firstName.substring(0, 3);
          final capPrefix = prefix[0].toUpperCase() + prefix.substring(1);
          return (en: '${capPrefix}o', ar: '$capPrefixو');
        }
      }
    }

    // 2. Try Arabic First Name
    if (fullNameAr != null && fullNameAr.trim().isNotEmpty) {
      final parts = fullNameAr.trim().split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        final firstName = parts.first.trim();
        if (_copticNicknames.containsKey(firstName)) {
          return _copticNicknames[firstName];
        }
      }
    }

    return null;
  }
}
