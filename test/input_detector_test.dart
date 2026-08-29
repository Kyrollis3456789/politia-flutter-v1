import 'package:flutter_test/flutter_test.dart';
import 'package:politia/utils/input_detector.dart';

void main() {
  group('InputDetector - Smart Input Detection', () {
    test('Detects valid emails correctly', () {
      expect(InputDetector.detect('user@example.com'), equals(InputType.email));
      expect(InputDetector.detect('kyrollos.test@domain.org'), equals(InputType.email));
      expect(InputDetector.detect('  citizen@politia.gov.eg  '), equals(InputType.email));
    });

    test('Detects Egyptian mobile numbers correctly', () {
      expect(InputDetector.detect('01012345678'), equals(InputType.phone));
      expect(InputDetector.detect('01123456789'), equals(InputType.phone));
      expect(InputDetector.detect('01234567890'), equals(InputType.phone));
      expect(InputDetector.detect('01512345678'), equals(InputType.phone));
      expect(InputDetector.detect('+201012345678'), equals(InputType.phone));
    });

    test('Detects international E.164 phone numbers correctly', () {
      expect(InputDetector.detect('+14155552671'), equals(InputType.phone));
      expect(InputDetector.detect('+447911123456'), equals(InputType.phone));
    });

    test('Detects Member IDs strictly matching ^00\\d{9}\$', () {
      // 11 digits starting with 00
      expect(InputDetector.detect('00101234567'), equals(InputType.memberId));
      expect(InputDetector.detect('00019876543'), equals(InputType.memberId));
      expect(InputDetector.detect('00651234567'), equals(InputType.memberId));

      // Region & serial extraction
      expect(InputDetector.getMemberIdRegionCode('00101234567'), equals('10'));
      expect(InputDetector.getMemberIdSerial('00101234567'), equals('1234567'));
      expect(InputDetector.regionCodes['10'], equals('Asyut'));

      expect(InputDetector.getMemberIdRegionCode('00019876543'), equals('01'));
      expect(InputDetector.getMemberIdSerial('00019876543'), equals('9876543'));
      expect(InputDetector.regionCodes['01'], equals('Africa (Global)'));
    });

    test('Rejects invalid Member ID patterns as non-member-id', () {
      // Not starting with 00
      expect(InputDetector.detect('01101234567'), isNot(equals(InputType.memberId)));
      // 10 digits
      expect(InputDetector.detect('0010123456'), isNot(equals(InputType.memberId)));
      // 12 digits
      expect(InputDetector.detect('001012345678'), isNot(equals(InputType.memberId)));
    });

    test('Normalizes phone numbers to standard E.164 format', () {
      expect(InputDetector.normalizePhone('01012345678'), equals('+201012345678'));
      expect(InputDetector.normalizePhone('01123456789'), equals('+201123456789'));
      expect(InputDetector.normalizePhone('+201234567890'), equals('+201234567890'));
      expect(InputDetector.normalizePhone('+14155552671'), equals('+14155552671'));
    });
  });
}
