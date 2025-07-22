import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../data/datasources/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _prefsService = PreferencesService();
  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _autoSave = true;
  String _selectedLanguage = 'Português';
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await _prefsService.init();
    setState(() {
      _isDarkMode = _prefsService.isDarkMode;
      _enableNotifications = _prefsService.isNotificationsEnabled;
      _autoSave = _prefsService.isAutoSaveEnabled;
      _selectedLanguage = _prefsService.selectedLanguage;
      _fontSize = _prefsService.fontSize;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Seção Aparência
          _buildSectionHeader('Aparência'),
          _buildSwitchTile(
            'Modo Escuro',
            'Alterna entre tema claro e escuro',
            _isDarkMode,
            Icons.dark_mode,
            (value) async {
              setState(() {
                _isDarkMode = value;
              });
              await _prefsService.setDarkMode(value);
              _showRestartMessage();
            },
          ),
          _buildSliderTile(
            'Tamanho da Fonte',
            'Ajusta o tamanho do texto',
            _fontSize,
            Icons.text_fields,
            12.0,
            20.0,
            (value) async {
              setState(() {
                _fontSize = value;
              });
              await _prefsService.setFontSize(value);
              _showRestartMessage();
            },
          ),
          
          const SizedBox(height: 24),
          
          // Seção Funcionalidades
          _buildSectionHeader('Funcionalidades'),
          _buildSwitchTile(
            'Notificações',
            'Receba lembretes sobre suas anotações',
            _enableNotifications,
            Icons.notifications,
            (value) async {
              setState(() {
                _enableNotifications = value;
              });
              await _prefsService.setNotificationsEnabled(value);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? 'Notificações ativadas' : 'Notificações desativadas'
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          _buildSwitchTile(
            'Salvamento Automático',
            'Salva suas anotações automaticamente',
            _autoSave,
            Icons.save,
            (value) async {
              setState(() {
                _autoSave = value;
              });
              await _prefsService.setAutoSaveEnabled(value);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? 'Salvamento automático ativado' : 'Salvamento automático desativado'
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Seção Idioma
          _buildSectionHeader('Idioma'),
          _buildDropdownTile(
            'Idioma do Aplicativo',
            'Selecione o idioma preferido',
            _selectedLanguage,
            Icons.language,
            ['Português', 'Inglês', 'Espanhol'],
            (value) async {
              setState(() {
                _selectedLanguage = value!;
              });
              await _prefsService.setSelectedLanguage(value!);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Idioma alterado para $value'),
                  backgroundColor: Colors.green,
                ),
              );
              _showRestartMessage();
            },
          ),
          
          const SizedBox(height: 24),
          
          // Seção Conta
          _buildSectionHeader('Conta'),
          _buildActionTile(
            'Fazer Logout',
            'Sair da conta atual',
            Icons.logout,
            Colors.red,
            () {
              _showLogoutDialog();
            },
          ),
          
          const SizedBox(height: 24),
          
          // Seção Sobre
          _buildSectionHeader('Sobre'),
          _buildActionTile(
            'Sobre o Aplicativo',
            'Informações sobre o Anotation AI',
            Icons.info,
            Colors.deepPurple,
            () {
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value,
      IconData icon, Function(bool) onChanged) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildSliderTile(String title, String subtitle, double value,
      IconData icon, double min, double max, Function(double) onChanged) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 8),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / 2).round(),
              label: value.round().toString(),
              onChanged: onChanged,
              activeColor: Colors.deepPurple,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, String value,
      IconData icon, List<String> options, Function(String?) onChanged) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: value,
              isExpanded: true,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon,
      Color color, Function() onTap) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Logout'),
          content: const Text('Tem certeza de que deseja sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sobre o Anotation AI'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Versão: 1.0.0'),
              SizedBox(height: 8),
              Text('Desenvolvido para organizar suas anotações de forma inteligente.'),
              SizedBox(height: 8),
              Text('© 2024 Anotation AI'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showRestartMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text('Reinicie o aplicativo para aplicar as mudanças'),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> _performLogout() async {
    try {
      // Mostra loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Faz logout na API
      await ApiService.logout();
      
      // Limpa preferências locais (mantém configurações de aparência)
      // Não limpa todas as preferências, apenas tokens
      
      // Fecha o loading
      Navigator.of(context).pop();
      
      // Navega para login e remove todas as telas do stack
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
      
      // Mostra mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Fecha o loading se ainda estiver aberto
      Navigator.of(context).pop();
      
      // Mostra erro mas ainda faz logout local
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro no logout: $e'),
          backgroundColor: Colors.orange,
        ),
      );
      
      // Mesmo com erro na API, faz logout local
      await ApiService.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    }
  }
}
