import 'package:flutter/material.dart';
import 'package:ghost_rec/core/security/app_security.dart';
import 'package:ghost_rec/widgets/ui/settings/dialog/password_dialog.dart';

class LockScreen extends StatefulWidget {
  final Widget child;

  const LockScreen({super.key, required this.child});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with WidgetsBindingObserver {
  bool _desbloqueado = false;
  bool _dialogAberto = false;
  bool _loading = true; // <-- estado de loading inicial

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarProtecao();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    // Aqui você pode executar qualquer ação, ex: fechar loading ou mudar de tela  
      _verificarProtecao();
    }
  }

  Future<void> _verificarProtecao() async {
    
    setState(() => _loading = true); // inicia loading

    final protegido = await AppSecurity.isProtegido();

    if (!mounted) return;

    if (!protegido) {
      setState(() {
        _desbloqueado = true;
        _loading = false;
      });
      return;
    }

    setState(() {
      _desbloqueado = false;
      _loading = false; // termina loading
    });

    _abrirDialog();
  }

  Future<void> _abrirDialog() async {
    if (_dialogAberto) return;
    _dialogAberto = true;

    final senha = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PasswordDialog(
        title: 'Digite a senha para acessar o aplicativo',
        modo: ModoSenha.validar,
        validarSenha: (s) => AppSecurity.validarSenha(s),
      ),
    );

    _dialogAberto = false;

    if (!mounted) return;

    if (senha != null) {
      setState(() => _desbloqueado = true);
    } else {
      _abrirDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // 🔹 Tela de loading com fundo branco e indicador azul
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue, // indicador azul
          ),
        ),
      );
    }

    if (_desbloqueado) return widget.child;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/icon/ghostrec_logo.png', height: 200),
              const SizedBox(height: 12),
              const Text(
                'GhostRec',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
