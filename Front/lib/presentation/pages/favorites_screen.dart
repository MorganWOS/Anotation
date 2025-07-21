import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import 'pdf_viewer_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, dynamic>> _folders = [
    {
      'name': 'Anatomia',
      'items': [
        {'title': '#1. Anatomia Dentária', 'subtitle': 'Morfologia dos dentes'},
        {'title': '#2. Anatomia de Cabeça e Pescoço', 'subtitle': 'Músculos e nervos'},
      ],
    },
    {
      'name': 'Procedimentos',
      'items': [
        {'title': '#3. Fisiologia Oral', 'subtitle': 'Funções do sistema estomatognático'},
      ],
    },
  ];

  void _createNewFolder() {
    showDialog(
      context: context,
      builder: (context) {
        String folderName = '';
        return AlertDialog(
          title: const Text('Nova Pasta'),
          content: TextField(
            onChanged: (value) => folderName = value,
            decoration: const InputDecoration(
              hintText: 'Nome da pasta',
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
                if (folderName.isNotEmpty) {
                  setState(() {
                    _folders.add({
                      'name': folderName,
                      'items': [],
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFolder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Pasta'),
        content: Text('Tem certeza que deseja excluir a pasta "${_folders[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _folders.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _openFolder(Map<String, dynamic> folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderContentScreen(folder: folder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Meus Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: _createNewFolder,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O usuário consegue salvar os resumos que ele preferir',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Há a opção de criar uma pasta e nomeá-la para ajudar na organização',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uma possibilidade seria de salvar as anotações dos usuários nessa aba (mas nada concreto ainda)',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            
            // Lista de pastas
            Expanded(
              child: _folders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 80,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma pasta criada ainda',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Toque no + para criar uma nova pasta',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _folders.length,
                      itemBuilder: (context, index) {
                        final folder = _folders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.folder,
                              color: AppTheme.primaryColor,
                              size: 40,
                            ),
                            title: Text(
                              folder['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              '${folder['items'].length} item(s)',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'open',
                                  child: Text('Abrir'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Excluir'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'open') {
                                  _openFolder(folder);
                                } else if (value == 'delete') {
                                  _deleteFolder(index);
                                }
                              },
                            ),
                            onTap: () => _openFolder(folder),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FolderContentScreen extends StatefulWidget {
  final Map<String, dynamic> folder;
  
  const FolderContentScreen({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderContentScreen> createState() => _FolderContentScreenState();
}

class _FolderContentScreenState extends State<FolderContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(widget.folder['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.folder['items'].isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      size: 80,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Pasta vazia',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Adicione resumos aos favoritos para vê-los aqui',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: widget.folder['items'].length,
                itemBuilder: (context, index) {
                  final item = widget.folder['items'][index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                      title: Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        item['subtitle'],
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.folder['items'].removeAt(index);
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(title: item['title']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
