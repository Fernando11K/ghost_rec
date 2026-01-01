import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginAttempts {
  static const _armazenamento = FlutterSecureStorage();

  static const String _chaveTentativas = 'login_tentativas';
  static const String _chavePrimeiraTentativa = 'login_primeira_tentativa';

  static const int maximoTentativas = 5;
  static const Duration janelaTempo = Duration(minutes: 5);
  
  static Future<bool> podeTentar() async {
    final String? tentativasStr = await _armazenamento.read(
      key: _chaveTentativas,
    );
    final String? primeiraTentativaStr = await _armazenamento.read(
      key: _chavePrimeiraTentativa,
    );

    if (tentativasStr == null || primeiraTentativaStr == null) {
      return true;
    }

    final int tentativas = int.parse(tentativasStr);
    final DateTime primeiraTentativa = DateTime.fromMillisecondsSinceEpoch(
      int.parse(primeiraTentativaStr),
    );

    final DateTime agora = DateTime.now();
    
    if (agora.difference(primeiraTentativa) > janelaTempo) {
      await resetar();
      return true;
    }

    return tentativas < maximoTentativas;
  }

  static Future<void> registrarFalha() async {
    final DateTime agora = DateTime.now();

    final String? tentativasStr = await _armazenamento.read(
      key: _chaveTentativas,
    );
    final String? primeiraTentativaStr = await _armazenamento.read(
      key: _chavePrimeiraTentativa,
    );

    if (tentativasStr == null || primeiraTentativaStr == null) {
      await _armazenamento.write(key: _chaveTentativas, value: '1');
      await _armazenamento.write(
        key: _chavePrimeiraTentativa,
        value: agora.millisecondsSinceEpoch.toString(),
      );
      return;
    }

    final int tentativas = int.parse(tentativasStr);
    final DateTime primeiraTentativa = DateTime.fromMillisecondsSinceEpoch(
      int.parse(primeiraTentativaStr),
    );

    // Se janela expirou, reinicia
    if (agora.difference(primeiraTentativa) > janelaTempo) {
      await resetar();
      await registrarFalha();
      return;
    }

    await _armazenamento.write(
      key: _chaveTentativas,
      value: (tentativas + 1).toString(),
    );
  }

  /// Limpa tentativas após sucesso
  static Future<void> resetar() async {
    await _armazenamento.delete(key: _chaveTentativas);
    await _armazenamento.delete(key: _chavePrimeiraTentativa);
  }

  /// Tempo restante de bloqueio
  static Future<Duration?> tempoRestante() async {
    final String? primeiraTentativaStr = await _armazenamento.read(
      key: _chavePrimeiraTentativa,
    );
    if (primeiraTentativaStr == null) return null;

    final DateTime primeiraTentativa = DateTime.fromMillisecondsSinceEpoch(
      int.parse(primeiraTentativaStr),
    );

    final Duration tempoDecorrido = DateTime.now().difference(
      primeiraTentativa,
    );

    if (tempoDecorrido >= janelaTempo) return null;

    return janelaTempo - tempoDecorrido;
  }
}
