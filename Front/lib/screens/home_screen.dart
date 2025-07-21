import 'package:flutter/material.dart';
import '../data/models/session.dart';
import '../data/models/media_content.dart';
import '../shared/widgets/media_content_widget.dart';
import '../shared/widgets/media_toolbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  int _selectedSessionIndex = 0;
  
  // Lista de sessões com suporte a mídia
  final List<Session> _sessions = [
    Session(
      id: '1',
      title: 'Sessão 1 - Ideias Principais',
      createdAt: DateTime.now().subtract(const Duration(days: 0)),
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      contents: [
        MediaContent.createText('Primeira anotação da sessão 1'),
        MediaContent.createText('Segunda anotação importante'),
      ],
    ),
    Session(
      id: '2', 
      title: 'Sessão 2 - Reunião',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      lastModified: DateTime.now().subtract(const Duration(hours: 8)),
      contents: [
        MediaContent.createText('Pontos discutidos na reunião'),
        MediaContent.createText('Ações a serem tomadas'),
      ],
    ),
    Session(
      id: '3',
      title: 'Sessão 3 - Estudos',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      lastModified: DateTime.now().subtract(const Duration(days: 2)),
      contents: [
        MediaContent.createText('Conceitos aprendidos'),
        MediaContent.createText('Dúvidas para revisar'),
      ],
    ),
  ];

  Session get _currentSession => _sessions[_selectedSessionIndex];

  void _addTextNote() {
    if (_noteController.text.isNotEmpty) {
      final textContent = MediaContent.createText(_noteController.text);
      setState(() {
        _sessions[_selectedSessionIndex] = _currentSession.addContent(textContent);
        _noteController.clear();
      });
    }
  }

  void _addMediaContent(MediaContent mediaContent) {
    setState(() {
      _sessions[_selectedSessionIndex] = _currentSession.addContent(mediaContent);
    });
  }

  void _deleteContent(String contentId) {
    setState(() {
      _sessions[_selectedSessionIndex] = _currentSession.removeContent(contentId);
    });
  }

  void _selectSession(int index) {
    setState(() {
      _selectedSessionIndex = index;
    });
    Navigator.pop(context); // Fecha o drawer
  }

  void _createNewSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTitle = '';
        return AlertDialog(
          title: const Text('Nova Sessão'),
          content: TextField(
            onChanged: (value) => newTitle = value,
            decoration: const InputDecoration(
              hintText: 'Nome da sessão',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTitle.isNotEmpty) {
                  final newSession = Session.createNew(newTitle);
                  setState(() {
                    _sessions.add(newSession);
                    _selectedSessionIndex = _sessions.length - 1;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context); // Fecha o drawer
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentSession.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Anotation AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Suas Sessões',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  final isSelected = index == _selectedSessionIndex;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple.withOpacity(0.1) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
                        child: Icon(
                          Icons.note,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      title: Text(
                        session.title,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.deepPurple : null,
                        ),
                      ),
                      subtitle: Text(
                        '${session.getContentSummary()} • ${session.getFormattedLastModified()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () => _selectSession(index),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.deepPurple),
              title: const Text(
                'Nova Sessão',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _createNewSession,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de conteúdo de mídia
          Expanded(
            child: _currentSession.contents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum conteúdo ainda',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Adicione textos, imagens, áudios ou vídeos',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentSession.contents.length,
                    itemBuilder: (context, index) {
                      final content = _currentSession.contents[index];
                      return MediaContentWidget(
                        mediaContent: content,
                        onDelete: () => _deleteContent(content.id),
                      );
                    },
                  ),
          ),
          // Barra de ferramentas de mídia
          MediaToolbar(
            onMediaAdded: _addMediaContent,
          ),
          // Campo de entrada de texto
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Digite sua anotação...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTextNote(),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: _addTextNote,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
