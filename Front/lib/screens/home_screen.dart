import 'package:flutter/material.dart';
import '../data/models/session.dart';
import '../data/models/media_content.dart';
import '../shared/widgets/media_content_widget.dart';
import '../shared/widgets/media_toolbar.dart';
import '../data/datasources/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  int _selectedSessionIndex = 0;
  bool _isLoading = false;
  List<MediaContent> _apiMessages = [];
  String? _errorMessage;
  
  // Lista de sessões - inicia vazia para que o usuário comece sem sessões pré-criadas
  final List<Session> _sessions = [];

  Session? get _currentSession => _sessions.isEmpty ? null : _sessions[_selectedSessionIndex];

  @override
  void initState() {
    super.initState();
    // Carrega as sessões do usuário logado
    _loadUserSessions();
  }

  Future<void> _loadUserSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.fetchUserSessions();
      
      if (result['success']) {
        final List<Map<String, dynamic>> sessionsData = result['data'] as List<Map<String, dynamic>>;
        
        setState(() {
          _sessions.clear();
          // Converte os dados da API para objetos Session
          for (var sessionData in sessionsData) {
            _sessions.add(Session.fromMap(sessionData));
          }
          
          // Se há sessões, seleciona a primeira e carrega suas mensagens
          if (_sessions.isNotEmpty) {
            _selectedSessionIndex = 0;
            _isLoading = false;
            // Carrega mensagens da primeira sessão
            _loadSessionMessages();
          } else {
            _isLoading = false;
          }
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar sessões: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSessionMessages() async {
    if (_currentSession == null) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.fetchSessionMessages(_currentSession!.id);
      
      if (result['success']) {
        setState(() {
          _apiMessages = result['data'] as List<MediaContent>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar mensagens: $e';
        _isLoading = false;
      });
    }
  }

  List<MediaContent> get _allContents {
    // Combina conteúdos locais e da API
    final List<MediaContent> allContents = [];
    if (_currentSession != null) {
      allContents.addAll(_currentSession!.contents);
    }
    allContents.addAll(_apiMessages);
    
    // Ordena por data de criação
    allContents.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    
    return allContents;
  }

  void _addTextNote() async {
    if (_noteController.text.isNotEmpty && _currentSession != null) {
      final String messageText = _noteController.text;
      
      // Limpa o campo imediatamente para melhorar UX
      _noteController.clear();
      
      try {
        // Salva a mensagem na API
        final result = await ApiService.saveMessage(
          sessionId: _currentSession!.id,
          keyId: DateTime.now().millisecondsSinceEpoch.remainder(2147483647), // Garante key_id dentro do limite
          text: messageText,
        );
        
        if (result['success']) {
          // Recarrega as mensagens para incluir a nova com timestamp correto da API
          _loadSessionMessages();
        } else {
          // Se falhou, mostra erro e recoloca o texto no campo
          setState(() {
            _noteController.text = messageText;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar mensagem: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Se houve erro de conexão, recoloca o texto e mostra erro
        setState(() {
          _noteController.text = messageText;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro de conexão: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addMediaContent(MediaContent mediaContent) {
    if (_currentSession != null) {
      setState(() {
        _sessions[_selectedSessionIndex] = _currentSession!.addContent(mediaContent);
      });
    }
  }

  void _deleteContent(String contentId) {
    if (_currentSession != null) {
      setState(() {
        _sessions[_selectedSessionIndex] = _currentSession!.removeContent(contentId);
      });
    }
  }

  void _selectSession(int index) {
    setState(() {
      _selectedSessionIndex = index;
    });
    Navigator.pop(context); // Fecha o drawer
    _loadSessionMessages(); // Carrega mensagens da nova sessão
  }

  void _createNewSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTitle = '';
        bool isCreating = false; // Estado para mostrar loading
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova Sessão'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) => newTitle = value,
                    decoration: const InputDecoration(
                      hintText: 'Nome da sessão',
                      border: OutlineInputBorder(),
                    ),
                    enabled: !isCreating, // Desabilita durante criação
                  ),
                  if (isCreating) ...[
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Criando sessão...'),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isCreating ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: isCreating ? null : () async {
                    if (newTitle.isNotEmpty) {
                      setDialogState(() {
                        isCreating = true;
                      });
                      
                      try {
                        // Chama a API para criar a sessão no banco de dados
                        // A sessão será automaticamente associada ao usuário logado
                        final result = await ApiService.createSession(
                          sessionName: newTitle,
                        );
                        
                        if (result['success']) {
                          Navigator.pop(context); // Fecha o diálogo
                          Navigator.pop(context); // Fecha o drawer
                          
                          // Recarrega todas as sessões para incluir a nova
                          await _loadUserSessions();
                          
                          // Seleciona a última sessão (a nova criada)
                          if (_sessions.isNotEmpty) {
                            setState(() {
                              _selectedSessionIndex = _sessions.length - 1;
                            });
                            // Carrega mensagens da nova sessão
                            _loadSessionMessages();
                          }
                          
                          // Mostra mensagem de sucesso
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message']),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          // Se houve erro na API, mostra a mensagem
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message']),
                              backgroundColor: Colors.red,
                            ),
                          );
                          
                          setDialogState(() {
                            isCreating = false;
                          });
                        }
                      } catch (e) {
                        // Se houve erro inesperado, mostra mensagem genérica
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao criar sessão: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        
                        setDialogState(() {
                          isCreating = false;
                        });
                      }
                    }
                  },
                  child: const Text('Criar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentSession?.title ?? 'Anotation AI'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (_currentSession != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadSessionMessages,
            ),
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
            child: _buildContentList(),
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
  Widget _buildContentList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    
    // Se não há sessões, mostra mensagem para criar uma
    if (_sessions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma sessão criada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Abra o menu e crie sua primeira sessão',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    if (_allContents.isEmpty) {
      return const Center(
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
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _allContents.length,
      itemBuilder: (context, index) {
        final content = _allContents[index];
        return MediaContentWidget(
          mediaContent: content,
          onDelete: () => _deleteContent(content.id),
        );
      },
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
