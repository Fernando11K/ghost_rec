import 'package:flutter/material.dart';
import 'package:ghost_rec/utils/labels.dart';
import 'package:ghost_rec/widgets/ui/modals/radio_modal.dart';
import 'package:ghost_rec/widgets/ui/settings/settings_group.dart';
import 'package:ghost_rec/widgets/ui/settings/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== ESTADO =====
  String _idioma = 'pt_BR';
  String _tamanhoPrevisualizacao = 'Normal';
  String _camera = 'Traseira';
  String _qualidadeVideo = 'Alta';
  double _duracaoVideo = 5;
  bool _gravacaoSilenciosa = false;
  bool _appProtegido = false;
  bool _dispositivoLigado = false;
  String _pesquisa = '';

  // ===== MODAIS =====

  void _showlanguageModal() {
    showRadioModal(
      context: context,
      title: 'Idioma',
      value: _idioma,
      options: const {
        'pt_BR': 'Português (Portuguese)',
        'en_US': 'Inglês (English)',
        'gn_BR': "Português de Portugal (Brazilian Guyanese)",
      },
      onChanged: (v) => setState(() => _idioma = v),
    );
  }

  void _showTamanhoModal() {
    showRadioModal(
      context: context,
      title: 'Tamanho da visualização',
      value: _tamanhoPrevisualizacao,
      options: const {
        'Pequeno': 'Pequeno',
        'Normal': 'Normal',
        'Grande': 'Grande',
      },
      onChanged: (v) => setState(() => _tamanhoPrevisualizacao = v),
    );
  }

  void _showCameraModal() {
    showRadioModal(
      context: context,
      title: 'Câmera de vídeo',
      value: _camera,
      options: const {'Frontal': 'Frontal', 'Traseira': 'Traseira'},
      onChanged: (v) => setState(() => _camera = v),
    );
  }

  void _showQualidadeModal() {
    showRadioModal(
      context: context,
      title: 'Qualidade de vídeo',
      value: _qualidadeVideo,
      options: const {'Baixa': 'Baixa', 'Média': 'Média', 'Alta': 'Alta'},
      onChanged: (v) => setState(() => _qualidadeVideo = v),
    );
  }

  void _showDuracaoModal() {
    showDialog(
      context: context,
      builder: (context) {
        double duracaoTemp = _duracaoVideo;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text(
                'Duração do vídeo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${duracaoTemp.round()} min',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: duracaoTemp,
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '${duracaoTemp.round()} min',
                    onChanged: (v) {
                      setStateDialog(() {
                        duracaoTemp = v;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _duracaoVideo = duracaoTemp;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
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
                onChanged: (value) {
                  setState(() => _pesquisa = value.toLowerCase());
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (_, __) => const [],
          ),

          const SizedBox(height: 16),

          // GERAL
          SettingsGroup(
            children: [
              SettingsItem(
                icon: Icons.language,
                title: 'Idioma',
                subtitle: languageLabel(_idioma),
                onTap: _showlanguageModal,
              ),
              SettingsItem(
                icon: Icons.crop_original,
                title: 'Tamanho da pré-visualização',
                subtitle: '($_tamanhoPrevisualizacao)',
                onTap: _showTamanhoModal,
              ),
            ],
          ),

          // VÍDEO
          SettingsGroup(
            children: [
              SettingsItem(
                icon: Icons.videocam,
                title: 'Câmera de gravação',
                subtitle: '($_camera)',
                onTap: _showCameraModal,
              ),
              SettingsItem(
                icon: Icons.high_quality,
                title: 'Qualidade do Vídeo',
                subtitle: '($_qualidadeVideo)',
                onTap: _showQualidadeModal,
              ),
              SettingsItem(
                icon: Icons.timer,
                title: 'Duração',
                subtitle: '(${_duracaoVideo.round()} min)',
                onTap: _showDuracaoModal,
              ),
            ],
          ),

          // SEGURANÇA
          SettingsGroup(
            children: [
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
                secondary: const Icon(Icons.lock),
              ),
              CheckboxListTile(
                value: _dispositivoLigado,
                onChanged: (v) =>
                    setState(() => _dispositivoLigado = v ?? false),
                title: const Text('Manter dispositivo ligado'),
                secondary: const Icon(Icons.screen_lock_portrait),
              ),
            ],
          ),

          // SOBRE
          SettingsGroup(
            children: [
              SettingsItem(
                icon: Icons.star_rate,
                title: 'Avaliar aplicativo',
                onTap: () {},
              ),
              SettingsItem(
                icon: Icons.privacy_tip,
                title: 'Política de privacidade',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

