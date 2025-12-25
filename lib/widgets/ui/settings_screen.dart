import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== ESTADO =====
  String _idioma = 'pt_BR';
  String _tamanhoPreview = 'Normal';
  String _camera = 'Traseira';
  String _qualidadeVideo = 'Alta';
  double _duracaoVideo = 5;
  bool _gravacaoSilenciosa = false;
  bool _appProtegido = false;

  // ===== LABELS =====
  String get idiomaLabel {
    switch (_idioma) {
      case 'pt_BR':
        return 'Português (Portuguese)';
      case 'en_US':
        return 'English';
      case 'gn_BR':
        return "Português de Portugal (Brazilian Guyanese)";
      default:
        return '';
    }
  }

  // ===== MODAIS =====

  void _showIdiomaModal() {
    _showRadioModal(
      title: 'Idioma',
      value: _idioma,
      options: const {
        'pt_BR': 'Português (Portuguese)',
        'en_US': 'English',
        'gn_BR': "Português de Portugal (Brazilian Guyanese)",
      },
      onChanged: (v) => setState(() => _idioma = v),
    );
  }

  void _showTamanhoModal() {
    _showRadioModal(
      title: 'Tamanho da visualização',
      value: _tamanhoPreview,
      options: const {
        'Pequeno': 'Pequeno',
        'Normal': 'Normal',
        'Grande': 'Grande',
      },
      onChanged: (v) => setState(() => _tamanhoPreview = v),
    );
  }

  void _showCameraModal() {
    _showRadioModal(
      title: 'Câmera de vídeo',
      value: _camera,
      options: const {'Frontal': 'Frontal', 'Traseira': 'Traseira'},
      onChanged: (v) => setState(() => _camera = v),
    );
  }

  void _showQualidadeModal() {
    _showRadioModal(
      title: 'Qualidade de vídeo',
      value: _qualidadeVideo,
      options: const {'Baixa': 'Baixa', 'Média': 'Média', 'Alta': 'Alta'},
      onChanged: (v) => setState(() => _qualidadeVideo = v),
    );
  }

  void _showDuracaoModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Duração: ${_duracaoVideo.round()} min',
                style: const TextStyle(fontSize: 16),
              ),
              Slider(
                value: _duracaoVideo,
                min: 1,
                max: 60,
                divisions: 59,
                label: '${_duracaoVideo.round()} min',
                onChanged: (v) => setState(() => _duracaoVideo = v),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== MODAL GENÉRICO RADIO =====
  void _showRadioModal({
    required String title,
    required String value,
    required Map<String, String> options,
    required ValueChanged<String> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return RadioGroup<String>(
          groupValue: value,
          onChanged: (v) {
            onChanged(v!);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...options.entries.map(
                (e) => RadioListTile(value: e.key, title: Text(e.value)),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // SEARCH
          SearchAnchor(
            isFullScreen: true,
            builder: (context, controller) {
              return SearchBar(
                hintText: "Pesquisar nas Configurações",
                controller: controller,
                elevation: const WidgetStatePropertyAll(0),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                onTap: controller.openView,
                onChanged: (_) => controller.openView(),
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (_, __) => const [],
          ),

          const SizedBox(height: 16),

          // GERAL
          settingsGroup([
            settingsItem(
              icon: Icons.language,
              title: 'Idioma',
              subtitle: '($idiomaLabel)',
              onTap: _showIdiomaModal,
            ),
            settingsItem(
              icon: Icons.text_fields,
              title: 'Tamanho ($_tamanhoPreview)',
              subtitle: '($_tamanhoPreview)',
              onTap: _showTamanhoModal,
            ),
          ]),

          // VÍDEO
          settingsGroup([
            settingsItem(
              icon: Icons.videocam,
              title: 'Câmera de gravação',
              subtitle: '($_camera)',
              onTap: _showCameraModal,
            ),
            settingsItem(
              icon: Icons.high_quality,
              title: 'Qualidade do Vídeo',
              subtitle: '($_qualidadeVideo)',
              onTap: _showQualidadeModal,
            ),
            settingsItem(
              icon: Icons.timer,
              title: 'Duração',
              subtitle: '(${_duracaoVideo.round()} min)',
              onTap: _showDuracaoModal,
            ),
          ]),

          // SEGURANÇA
          settingsGroup([
            CheckboxListTile(
              value: _gravacaoSilenciosa,
              onChanged: (v) =>
                  setState(() => _gravacaoSilenciosa = v ?? false),
              title: const Text('Gravação silenciosa'),
              secondary: const Icon(Icons.volume_off),
            ),            
            CheckboxListTile(
              value: _appProtegido,
              onChanged: (v) => setState(() => _appProtegido = v ?? false),
              title: const Text('App protegido'),
              subtitle: Text(_appProtegido ? 'Protegido' : 'Não protegido'),
              secondary: const Icon(Icons.lock),
            ),
            settingsItem(
              icon: Icons.screen_lock_portrait,
              title: 'Manter dispositivo ligado',
              onTap: () {},
            ),
          ]),

          // SOBRE
          settingsGroup([
            settingsItem(
              icon: Icons.star_rate,
              title: 'Avaliar aplicativo',
              onTap: () {},
            ),
            settingsItem(
              icon: Icons.privacy_tip,
              title: 'Política de privacidade',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }
}

// ===== HELPERS =====
Widget settingsItem({
  required IconData icon,
  required String title,
  String? subtitle,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.grey.shade700),
    title: Text(title, style: const TextStyle(fontSize: 16)),
    subtitle: Text(subtitle ?? ''),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

Widget settingsGroup(List<Widget> children) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(children: children),
  );
}
