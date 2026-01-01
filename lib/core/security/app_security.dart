import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecurity {
  static const _storage = FlutterSecureStorage();

  static const _keySenha = 'app_password';
  static const _keyProtegido = 'app_protected';
  
  static Future<void> salvarSenha(String senha) async {
    await _storage.write(key: _keySenha, value: senha);
    await _storage.write(key: _keyProtegido, value: 'true');
  }
  
  static Future<void> removerSenha() async {
    await _storage.delete(key: _keySenha);
    await _storage.write(key: _keyProtegido, value: 'false');
  }
  
  static Future<bool> isProtegido() async {
    final v = await _storage.read(key: _keyProtegido);
    return v == 'true';
  }

  static Future<bool> validarSenha(String senhaDigitada) async {
    final senhaSalva = await _storage.read(key: _keySenha);
    return senhaSalva != null && senhaSalva == senhaDigitada;
  }
}
