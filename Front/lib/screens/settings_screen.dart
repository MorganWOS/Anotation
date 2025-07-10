import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _autoSave = true;
  String _selectedLanguage = 'Português';
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
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
            (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
          _buildSliderTile(
            'Tamanho da Fonte',
            'Ajusta o tamanho do texto',
            _fontSize,
            Icons.text_fields,
            12.0,
            20.0,
            (value) {
              setState(() {
                _fontSize = value;
              });
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
            (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
          ),
          _buildSwitchTile(
            'Salvamento Automático',
            'Salva suas anotações automaticamente',
            _autoSave,
            Icons.save,
            (value) {
              setState(() {
                _autoSave = value;
              });
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
            (value) {
              setState(() {
                _selectedLanguage = value!;
              });
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
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
}
