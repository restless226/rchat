import 'package:chat/src/services/encryption/encryption_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryptionService {

  late final Encrypter? _encrypter; /// being used for AES encryption
  final _iv = IV.fromLength(16);  /// Represents an Initialization Vector

  @override
  String decrypt(String encryptedText) {
    final _encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter!.decrypt(_encrypted, iv: this._iv);
  }

  @override
  String encrypt(String text) {
    return _encrypter!.encrypt(text, iv: _iv).base64;
  }
  
}