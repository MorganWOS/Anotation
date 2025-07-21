import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class PDFViewerScreen extends StatefulWidget {
  final String title;
  
  const PDFViewerScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool _isFavorite = false;
  final List<String> _notes = [];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Implementar mecanismo de segurança contra screenshots
    _preventScreenshots();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _preventScreenshots() {
    // Implementar prevenção de screenshots
    // Por exemplo, usando plugins ou métodos nativos
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Adicionado aos favoritos' : 'Removido dos favoritos'),
        backgroundColor: _isFavorite ? Colors.green : Colors.orange,
      ),
    );
  }

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text);
        _noteController.clear();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implementar compartilhamento (apenas para usuários autorizados)
              _showShareDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Área do PDF
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_as_pdf,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visualização do PDF estará aqui',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implementar abertura do PDF
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ao clicar em um resumo, o usuário será transportado para uma outra página já com o PDF (resumo)'),
                          ),
                        );
                      },
                      child: const Text('Abrir PDF'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Área de anotações
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.note_add, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Suas Anotações',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Lista de anotações
                  Expanded(
                    child: _notes.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma anotação ainda',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _notes.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_notes[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  // Campo de nova anotação
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            decoration: const InputDecoration(
                              hintText: 'Adicionar anotação...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onSubmitted: (_) => _addNote(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addNote,
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartilhar'),
        content: const Text('A interface do PDF será igual ao do leitor de PDF do Microsoft Edge, pois nele tem a opção de grifar e anotar\n\nAlem disso, na aba terá a opção de salvar/favoritar → ao favoritar, o PDF vai para a aba "Meus favoritos"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
