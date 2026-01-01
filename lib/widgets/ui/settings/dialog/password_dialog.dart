import 'package:flutter/material.dart';

enum ModoSenha { criar, validar }

class PasswordDialog extends StatefulWidget {
  final String title;
  final ModoSenha modo;
  final Future<bool> Function(String senha)? validarSenha;

  const PasswordDialog({
    super.key,
    required this.title,
    required this.modo,
    this.validarSenha,
  });

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();

  bool _obscureSenha = true;
  bool _obscureConfirmacao = true;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final senha = _senhaController.text.trim();
    final confirmacao = _confirmacaoController.text.trim();

    setState(() => _erro = null);
    
    if (widget.modo == ModoSenha.criar) {
      if (senha.isEmpty || confirmacao.isEmpty) {
        setState(() => _erro = 'Os campos não podem ser vazios');
        return;
      }

      if (senha != confirmacao) {
        setState(() => _erro = 'As senhas não coincidem');
        return;
      }

      Navigator.pop(context, senha);
      return;
    }
    
    if (senha.isEmpty) {
      setState(() => _erro = 'Informe a senha');
      return;
    }

    if (widget.validarSenha == null) return;

    setState(() => _carregando = true);

    final valida = await widget.validarSenha!(senha);

    if (!mounted) return;

    if (!valida) {
      setState(() {
        _erro = 'Senha incorreta';
        _carregando = false;
      });
      return;
    }

    Navigator.pop(context, senha);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SENHA
          TextField(
            maxLength: 20, 
            controller: _senhaController,
            obscureText: _obscureSenha,
            autofocus: true,
            enabled: !_carregando,
            decoration: InputDecoration(
              labelText: 'Senha',
              errorText: _erro,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSenha ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
              ),
            ),
          ),

          // CONFIRMAÇÃO (somente criar)
          if (widget.modo == ModoSenha.criar) ...[
            const SizedBox(height: 12),
            TextField(
              maxLength: 20, 
              controller: _confirmacaoController,
              obscureText: _obscureConfirmacao,
              enabled: !_carregando,
              decoration: InputDecoration(
                labelText: 'Confirmar senha',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmacao
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmacao = !_obscureConfirmacao,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _carregando ? null : () => Navigator.pop(context, null),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _carregando ? null : _confirmar,
          child: _carregando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('OK', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
