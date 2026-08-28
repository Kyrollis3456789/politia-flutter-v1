/// Egyptian Governorates and Dioceses/Churches catalog for multi-step signup.
class EgyptianLocationsData {
  static const Map<String, List<String>> governoratesAndCities = {
    'Cairo': ['Nasr City', 'Heliopolis', 'Maadi', 'Zamalek', 'Shubra', 'New Cairo', 'El Marg', 'Helwan'],
    'Giza': ['Dokki', 'Mohandessin', '6th of October', 'Sheikh Zayed', 'Haram', 'Faisal', 'Imbaba'],
    'Alexandria': ['Sidi Gaber', 'Stanley', 'Montaza', 'Smouha', 'Mansheya', 'Miami', 'Gleem'],
    'Assiut': ['Assiut City', 'Dairut', 'Manfalut', 'Abnoub', 'El Qusiya', 'Dayr Durunka'],
    'Sohag': ['Sohag City', 'Akhmim', 'Girga', 'Tahta', 'Tima', 'El Maragha'],
    'Minya': ['Minya City', 'Mallawi', 'Samalut', 'Beni Mazar', 'Maghagha', 'Abu Qurqas'],
    'Qena': ['Qena City', 'Nag Hammadi', 'Qus', 'Dishna', 'Farshut'],
    'Luxor': ['Luxor City', 'Armant', 'Esna', 'Karnak'],
    'Aswan': ['Aswan City', 'Kom Ombo', 'Edfu', 'Daraw'],
    'Dakahlia': ['Mansoura', 'Mit Ghamr', 'Talkha', 'Dikirnis'],
    'Gharbia': ['Tanta', 'El Mahalla El Kubra', 'Zifta', 'Kafr El Zayat'],
    'Sharqia': ['Zagazig', '10th of Ramadan', 'Bilbeis', 'Faqous'],
    'Port Said': ['Port Said City', 'Port Fouad'],
    'Suez': ['Suez City', 'Arbaeen', 'Attaka'],
    'Red Sea': ['Hurghada', 'El Gouna', 'Safaga', 'Marsa Alam'],
  };

  static const Map<String, List<String>> churchesByGovernorate = {
    'Cairo': [
      'St. Mark Coptic Orthodox Cathedral, Abbassia',
      'The Hanging Church (El Muallaqa), Old Cairo',
      'St. George Church, Heliopolis',
      'St. Mary Church, Zeitoun',
      'St. Mark Church, Cleopatra',
      'St. Mary & Archangel Michael, Shubra',
    ],
    'Giza': [
      'St. Mark Church, Dokki',
      'St. Mary Church, Omrania',
      'Archangel Michael Church, 6th of October',
      'St. George Church, Agouza',
    ],
    'Alexandria': [
      'St. Mark Coptic Orthodox Cathedral, Ramleh',
      'St. George Church, Sporting',
      'St. Mary Church, Smouha',
      'St. Mina Monastery & Cathedral, Mariout',
    ],
    'Assiut': [
      'St. Mary Monastery (Dronka / Durunka)',
      'Archangel Michael Cathedral, Assiut',
      'St. George Church, Assiut',
      'Holy Virgin Mary Church, Dairut',
    ],
    'Minya': [
      'St. Mark Cathedral, Minya',
      'St. George Church, Mallawi',
      'Virgin Mary Church, Samalut',
    ],
    'Sohag': [
      'St. George Church, Sohag',
      'White Monastery (Deir Anba Shenouda)',
      'Red Monastery (Deir Anba Bishoy)',
    ],
  };

  static String getDioceseForGovernorate(String governorate) {
    switch (governorate) {
      case 'Assiut':
        return 'Diocese of Assiut & Dronka';
      case 'Cairo':
        return 'Holy Archdiocese of Cairo';
      case 'Alexandria':
        return 'Holy Archdiocese of Alexandria';
      case 'Giza':
        return 'Diocese of Giza & 6th of October';
      case 'Minya':
        return 'Diocese of Minya & Abu Qurqas';
      case 'Sohag':
        return 'Diocese of Sohag & Manshat';
      default:
        return 'Diocese of $governorate';
    }
  }

  static const List<String> hobbiesList = [
    'Bible Study & Reflection',
    'Coptic Hymns (Tasbeha)',
    'Church History & Patristics',
    'Sunday School Teaching',
    'Scouting & Camping',
    'Choir & Sacred Music',
    'Drawing & Iconography',
    'Reading & Literature',
    'Football',
    'Basketball',
    'Chess',
    'Software & Coding',
    'Photography & Media',
    'Charity & Social Outreach',
  ];

  static const List<String> universitiesList = [
    'Cairo University',
    'Ain Shams University',
    'Alexandria University',
    'Assiut University',
    'Mansoura University',
    'Helwan University',
    'Zagazig University',
    'Sohag University',
    'Minya University',
    'German University in Cairo (GUC)',
    'American University in Cairo (AUC)',
    'British University in Egypt (BUE)',
  ];

  static const List<String> facultiesList = [
    'Faculty of Medicine',
    'Faculty of Pharmacy',
    'Faculty of Dentistry',
    'Faculty of Engineering',
    'Faculty of Computer & Artificial Intelligence',
    'Faculty of Commerce & Business',
    'Faculty of Law',
    'Faculty of Arts & Humanities',
    'Faculty of Science',
    'Faculty of Mass Communication',
    'Faculty of Applied Arts',
  ];
}
