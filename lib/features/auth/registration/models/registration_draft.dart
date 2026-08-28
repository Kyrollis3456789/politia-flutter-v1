/// Complete model holding the 8-milestone multi-step registration draft state.
class RegistrationDraft {
  // Milestone 1: Personal Identity
  String fullNameEn;
  String fullNameAr;
  DateTime? dateOfBirth;
  String? gender; // 'male' | 'female'
  String? nationalId;
  String? nickname;
  String? avatarPath;
  DateTime? skipAvatarUntil;
  String? birthLocation;

  // Milestone 2: Contact & Social Media
  String primaryPhone;
  bool isPrimaryPhoneVerified;
  List<String> secondaryPhones;
  String? landline;
  String email;
  bool isEmailVerified;
  String? whatsappNumber;
  bool sendWhatsappOtp;
  Map<String, String> socialLinks; // e.g. {'facebook': '@user', 'instagram': '@user'}

  // Milestone 3: Family Relations
  String? fatherNameOrPhone;
  String? motherNameOrPhone;
  String maritalStatus; // 'single' | 'married'
  String? spouseNameOrPhone;
  List<String> childrenNames;
  List<Map<String, String>> relatives; // [{'relation': 'brother', 'name': '...'}]

  // Milestone 4: Education & Career
  String educationCategory; // 'basic' | 'university' | 'working'
  // Basic
  String? basicStage; // 'Primary', 'Preparatory', 'Secondary'
  int? basicGrade; // 1 - 12
  String? basicSystem; // 'General/Thanaweya', 'American', 'IGCSE', 'Baccalaureate'
  String? schoolName;
  // University
  String? universityName;
  String? facultyName;
  int? academicYear; // 1 - 7
  // Career / Working
  bool isWorking;
  String? jobTitle;
  String? companyName;
  bool hasPostGraduate;
  String? postGraduateDegree; // 'Master', 'PhD'
  bool isRetired;

  // Milestone 5: Residential Locations
  String country;
  String governorate;
  String city;
  String streetAddress;
  String? buildingNumber;
  String? floorNumber;
  String? apartmentNumber;
  double? latitude;
  double? longitude;
  String? secondaryAddress;

  // Milestone 6: Church Commitment
  String primaryChurch;
  String? diocese;
  String? secondaryChurch;
  String? fatherOfConfession;
  String? deaconRank; // 'None', 'Epsaltos', 'Ognostis', 'Hypodeacon', 'Deacon'
  List<String> churchServices; // 'Sunday School', 'Scouting', 'Choir', etc.

  // Milestone 7: Hobbies & Languages
  String primaryLanguage;
  List<Map<String, dynamic>> additionalLanguages; // [{'language': 'French', 'proficiency': 4}]
  List<String> hobbies; // ['Reading', 'Drawing', 'Basketball', 'Football']
  List<String> customHobbies;

  // Milestone 8: Password & Credentials
  String password;
  String confirmPassword;

  RegistrationDraft({
    this.fullNameEn = '',
    this.fullNameAr = '',
    this.dateOfBirth,
    this.gender,
    this.nationalId,
    this.nickname,
    this.avatarPath,
    this.skipAvatarUntil,
    this.birthLocation,
    this.primaryPhone = '',
    this.isPrimaryPhoneVerified = false,
    this.secondaryPhones = const [],
    this.landline,
    this.email = '',
    this.isEmailVerified = false,
    this.whatsappNumber,
    this.sendWhatsappOtp = false,
    this.socialLinks = const {},
    this.fatherNameOrPhone,
    this.motherNameOrPhone,
    this.maritalStatus = 'single',
    this.spouseNameOrPhone,
    this.childrenNames = const [],
    this.relatives = const [],
    this.educationCategory = 'basic',
    this.basicStage,
    this.basicGrade,
    this.basicSystem,
    this.schoolName,
    this.universityName,
    this.facultyName,
    this.academicYear,
    this.isWorking = false,
    this.jobTitle,
    this.companyName,
    this.hasPostGraduate = false,
    this.postGraduateDegree,
    this.isRetired = false,
    this.country = 'Egypt',
    this.governorate = 'Cairo',
    this.city = 'Cairo',
    this.streetAddress = '',
    this.buildingNumber,
    this.floorNumber,
    this.apartmentNumber,
    this.latitude,
    this.longitude,
    this.secondaryAddress,
    this.primaryChurch = '',
    this.diocese,
    this.secondaryChurch,
    this.fatherOfConfession,
    this.deaconRank = 'None',
    this.churchServices = const [],
    this.primaryLanguage = 'Arabic',
    this.additionalLanguages = const [],
    this.hobbies = const [],
    this.customHobbies = const [],
    this.password = '',
    this.confirmPassword = '',
  });

  /// Computed user age from [dateOfBirth]
  int? get calculatedAge {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toJson() => {
        'fullNameEn': fullNameEn,
        'fullNameAr': fullNameAr,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': gender,
        'nationalId': nationalId,
        'nickname': nickname,
        'avatarPath': avatarPath,
        'skipAvatarUntil': skipAvatarUntil?.toIso8601String(),
        'birthLocation': birthLocation,
        'primaryPhone': primaryPhone,
        'isPrimaryPhoneVerified': isPrimaryPhoneVerified,
        'secondaryPhones': secondaryPhones,
        'landline': landline,
        'email': email,
        'isEmailVerified': isEmailVerified,
        'whatsappNumber': whatsappNumber,
        'sendWhatsappOtp': sendWhatsappOtp,
        'socialLinks': socialLinks,
        'fatherNameOrPhone': fatherNameOrPhone,
        'motherNameOrPhone': motherNameOrPhone,
        'maritalStatus': maritalStatus,
        'spouseNameOrPhone': spouseNameOrPhone,
        'childrenNames': childrenNames,
        'relatives': relatives,
        'educationCategory': educationCategory,
        'basicStage': basicStage,
        'basicGrade': basicGrade,
        'basicSystem': basicSystem,
        'schoolName': schoolName,
        'universityName': universityName,
        'facultyName': facultyName,
        'academicYear': academicYear,
        'isWorking': isWorking,
        'jobTitle': jobTitle,
        'companyName': companyName,
        'hasPostGraduate': hasPostGraduate,
        'postGraduateDegree': postGraduateDegree,
        'isRetired': isRetired,
        'country': country,
        'governorate': governorate,
        'city': city,
        'streetAddress': streetAddress,
        'buildingNumber': buildingNumber,
        'floorNumber': floorNumber,
        'apartmentNumber': apartmentNumber,
        'latitude': latitude,
        'longitude': longitude,
        'secondaryAddress': secondaryAddress,
        'primaryChurch': primaryChurch,
        'diocese': diocese,
        'secondaryChurch': secondaryChurch,
        'fatherOfConfession': fatherOfConfession,
        'deaconRank': deaconRank,
        'churchServices': churchServices,
        'primaryLanguage': primaryLanguage,
        'additionalLanguages': additionalLanguages,
        'hobbies': hobbies,
        'customHobbies': customHobbies,
      };

  factory RegistrationDraft.fromJson(Map<String, dynamic> json) {
    return RegistrationDraft(
      fullNameEn: json['fullNameEn'] ?? '',
      fullNameAr: json['fullNameAr'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      gender: json['gender'],
      nationalId: json['nationalId'],
      nickname: json['nickname'],
      avatarPath: json['avatarPath'],
      skipAvatarUntil: json['skipAvatarUntil'] != null ? DateTime.tryParse(json['skipAvatarUntil']) : null,
      birthLocation: json['birthLocation'],
      primaryPhone: json['primaryPhone'] ?? '',
      isPrimaryPhoneVerified: json['isPrimaryPhoneVerified'] ?? false,
      secondaryPhones: List<String>.from(json['secondaryPhones'] ?? []),
      landline: json['landline'],
      email: json['email'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      whatsappNumber: json['whatsappNumber'],
      sendWhatsappOtp: json['sendWhatsappOtp'] ?? false,
      socialLinks: Map<String, String>.from(json['socialLinks'] ?? {}),
      fatherNameOrPhone: json['fatherNameOrPhone'],
      motherNameOrPhone: json['motherNameOrPhone'],
      maritalStatus: json['maritalStatus'] ?? 'single',
      spouseNameOrPhone: json['spouseNameOrPhone'],
      childrenNames: List<String>.from(json['childrenNames'] ?? []),
      relatives: List<Map<String, String>>.from(
        (json['relatives'] as List? ?? []).map((e) => Map<String, String>.from(e)),
      ),
      educationCategory: json['educationCategory'] ?? 'basic',
      basicStage: json['basicStage'],
      basicGrade: json['basicGrade'],
      basicSystem: json['basicSystem'],
      schoolName: json['schoolName'],
      universityName: json['universityName'],
      facultyName: json['facultyName'],
      academicYear: json['academicYear'],
      isWorking: json['isWorking'] ?? false,
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      hasPostGraduate: json['hasPostGraduate'] ?? false,
      postGraduateDegree: json['postGraduateDegree'],
      isRetired: json['isRetired'] ?? false,
      country: json['country'] ?? 'Egypt',
      governorate: json['governorate'] ?? 'Cairo',
      city: json['city'] ?? 'Cairo',
      streetAddress: json['streetAddress'] ?? '',
      buildingNumber: json['buildingNumber'],
      floorNumber: json['floorNumber'],
      apartmentNumber: json['apartmentNumber'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      secondaryAddress: json['secondaryAddress'],
      primaryChurch: json['primaryChurch'] ?? '',
      diocese: json['diocese'],
      secondaryChurch: json['secondaryChurch'],
      fatherOfConfession: json['fatherOfConfession'],
      deaconRank: json['deaconRank'] ?? 'None',
      churchServices: List<String>.from(json['churchServices'] ?? []),
      primaryLanguage: json['primaryLanguage'] ?? 'Arabic',
      additionalLanguages: List<Map<String, dynamic>>.from(json['additionalLanguages'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      customHobbies: List<String>.from(json['customHobbies'] ?? []),
    );
  }
}
