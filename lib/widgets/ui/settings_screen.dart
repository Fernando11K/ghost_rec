import 'dart:async';

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

  Timer? _debounce;

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _pesquisa = value.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  List<Widget> get listaDeConfiguracoes => [
    // GERAL
    SettingsGroup(
      children: [
        SettingsItem(
          icon: Icons.language,
          title: 'Idioma',
          subtitle: languageLabel(_idioma),
          onTap: _showlanguageModal,
          iconColor: Colors.blue,
        ),
        SettingsItem(
          icon: Icons.crop_original,
          title: 'Tamanho da pré-visualização',
          subtitle: '($_tamanhoPrevisualizacao)',
          onTap: _showTamanhoModal,
          iconColor: Colors.deepPurpleAccent,
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
          iconColor: Colors.red,
        ),
        SettingsItem(
          icon: Icons.high_quality,
          title: 'Qualidade do Vídeo',
          subtitle: '($_qualidadeVideo)',
          onTap: _showQualidadeModal,
          iconColor: Colors.green,
        ),
        SettingsItem(
          icon: Icons.timer,
          title: 'Duração',
          subtitle: '(${_duracaoVideo.round()} min)',
          onTap: _showDuracaoModal,
          iconColor: Colors.orange,
        ),
      ],
    ),

    // SEGURANÇA
    SettingsGroup(
      children: [
        CheckboxListTile(
          value: _gravacaoSilenciosa,
          onChanged: (v) => setState(() => _gravacaoSilenciosa = v ?? false),
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
          onChanged: (v) => setState(() => _dispositivoLigado = v ?? false),
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
          iconColor: Colors.amber,
        ),
        SettingsItem(
          icon: Icons.privacy_tip,
          title: 'Política de privacidade',
          onTap: () {},
        ),
      ],
    ),
  ];

  List<Widget> get listaFiltrada {
    if (_pesquisa.isEmpty) return listaDeConfiguracoes;

    final termo = _pesquisa.toLowerCase();

    return listaDeConfiguracoes
        .map((widget) {
          if (widget is SettingsGroup) {
            final itensFiltrados = widget.children.where((child) {
              if (child is SettingsItem) {
                return child.title.toLowerCase().contains(termo);
              }
              if (child is CheckboxListTile) {
                final text = (child.title as Text?)?.data ?? '';
                return text.toLowerCase().contains(termo);
              }
              return false;
            }).toList();

            if (itensFiltrados.isEmpty) return null;

            return SettingsGroup(children: itensFiltrados);
          }

          return null;
        })
        .whereType<Widget>()
        .toList();
  }

  void _showlanguageModal() {
    showRadioModal(
      context: context,
      title: 'Idioma',
      value: _idioma,
      options: const {
        'pt_BR': 'Português (Portuguese)',
        'gn_BR': "Português de Portugal (Brazilian Guyanese)",
        'en_US': 'Inglês (English)',
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
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${duracaoTemp.round()} min',
                    textAlign: TextAlign.center,
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
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _duracaoVideo = duracaoTemp;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: _buildSearchBar()),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: listaFiltrada.length,
              itemBuilder: (_, int index) {
                return listaFiltrada[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      hintText: "Pesquisar nas Configurações",
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      leading: const Icon(Icons.search),
      onChanged: _onSearchChanged,
    );
  }
}
