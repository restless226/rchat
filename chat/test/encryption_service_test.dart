import 'package:chat/src/services/encryption/encryption_service_contract.dart';
import 'package:chat/src/services/encryption/encryption_service_impl.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IEncryptionService? _encryptionService;

  setUp(() {
    /// more the length more are the resources used by encryption algorithm which is AES in this case
    /// encryption performed is on device side not on server side, hence it should be efficient
    final _encrypter = Encrypter(AES(Key.fromLength(32)));
    _encryptionService = EncryptionService(_encrypter);
  });

  tearDown(() {});

  test('it encrypts plain text into base64', () {
    const _text = 'this is a plain text message';
    final _base64 = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    final _encrypted = _encryptionService!.encrypt(_text);

    expect(_base64.hasMatch(_encrypted), true);
  });

  test('it decrypts base64 encrypted text', () {
    const _text = 'this is a plain text message';
    final _encrypted = _encryptionService!.encrypt(_text);
    final _decrypted = _encryptionService!.decrypt(_encrypted);

    expect(_decrypted, _text);
  });
}
