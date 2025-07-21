import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import 'pdf_viewer_screen.dart';
import 'video_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = 'Usuário';
  
  // Dados das categorias (baseado nas imagens)
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Ciclo Básico',
      'icon': Icons.school,
      'color': const Color(0xFF4F46E5),
      'items': ['Anatomia', 'Fisiologia', 'Histologia', 'Bioquímica'],
    },
    {
      'title': 'Disciplinas Clínicas',
      'icon': Icons.medical_services,
      'color': const Color(0xFF059669),
      'items': ['Periodontia', 'Endodontia', 'Prótese', 'Cirurgia'],
    },
    {
      'title': 'Técnicas e Procedimentos',
      'icon': Icons.build,
      'color': const Color(0xFF7C3AED),
      'items': ['Anestesia', 'Radiologia', 'Materiais', 'Ergonomia'],
    },
    {
      'title': 'Banco de Questões',
      'icon': Icons.quiz,
      'color': const Color(0xFFDC2626),
      'items': ['Simulados', 'Questões por tema', 'Provas antigas'],
    },
  ];
  
  // Dados dos resumos recentes
  final List<Map<String, dynamic>> _recentResumes = [
    {
      'title': '#1. Anatomia Dentária',
      'subtitle': 'Morfologia dos dentes',
      'icon': Icons.picture_as_pdf,
      'color': const Color(0xFF4F46E5),
    },
    {
      'title': '#2. Anatomia de Cabeça e Pescoço',
      'subtitle': 'Músculos e nervos',
      'icon': Icons.picture_as_pdf,
      'color': const Color(0xFF059669),
    },
    {
      'title': '#3. Fisiologia Oral',
      'subtitle': 'Funções do sistema estomatognático',
      'icon': Icons.picture_as_pdf,
      'color': const Color(0xFF7C3AED),
    },
  ];
  
  // Dados dos vídeos
  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Técnica Anestésica',
      'subtitle': 'Bloqueio do nervo alveolar inferior',
      'duration': '15:30',
      'thumbnail': Icons.play_circle_filled,
    },
    {
      'title': 'Exame Clínico',
      'subtitle': 'Semiologia oral',
      'duration': '22:15',
      'thumbnail': Icons.play_circle_filled,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openPDF(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(title: title),
      ),
    );
  }

  void _openVideo(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(title: title),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.menu_book, size: 20),
        ),
        title: const Text(
          'Resumos odonto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Página Inicial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Aulas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Mais',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildFavoritesPage();
      case 2:
        return _buildVideoPage();
      case 3:
        return _buildMorePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da página
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Página Inicial',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Menu de navegação horizontal principal
          _buildHorizontalNavigationMenu(),
          
          const SizedBox(height: 24),
          
          // Seção de resumos recentes
          _buildSectionTitle('Resumos Recentes'),
          const SizedBox(height: 16),
          _buildHorizontalList(_recentResumes, isResumeList: true),
          
          const SizedBox(height: 24),
          
          // Seção de vídeos
          _buildSectionTitle('Videoaulas'),
          const SizedBox(height: 16),
          _buildHorizontalList(_videos, isVideoList: true),
        ],
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⭐: Meus favoritos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• O usuário consegue salvar os resumos que ele preferir',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Há a opção de criar uma pasta e nomeá-la para ajudar na organização',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Uma possibilidade seria de salvar as anotações dos usuários nessa aba (mas nada concreto ainda)',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          
          // Grid de favoritos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: _recentResumes.length,
            itemBuilder: (context, index) {
              final resume = _recentResumes[index];
              return GestureDetector(
                onTap: () => _openPDF(resume['title']),
                child: Container(
                  decoration: BoxDecoration(
                    color: resume['color'],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: resume['color'].withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        resume['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        resume['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '▶️: Videoaulas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• Por conta do tamanho do vídeo possa ser que fique muito pesado, portanto o vídeo não precisa necessariamente estar carregado no app → pode ser feito um redirecionamento ao YouTube',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          
          // Lista de vídeos
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final video = _videos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  title: Text(
                    video['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video['subtitle']),
                      const SizedBox(height: 4),
                      Text(
                        'Duração: ${video['duration']}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _openVideo(video['title']),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMorePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '☰: Mais',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '• O único botão que terá novas funcionalidades é o "Configurações" e "Logout"',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Configurações → vai permitir alterações apenas no nome e foto do usuário',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Os outros botões vão redirecionar para as outras abas.',
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          
          // Menu items
          _buildMenuItem(
            icon: Icons.home,
            title: 'Página inicial',
            onTap: () => _onItemTapped(0),
          ),
          _buildMenuItem(
            icon: Icons.star,
            title: 'Favoritos',
            onTap: () => _onItemTapped(1),
          ),
          _buildMenuItem(
            icon: Icons.play_arrow,
            title: 'Aulas',
            onTap: () => _onItemTapped(2),
          ),
          _buildMenuItem(
            icon: Icons.settings,
            title: 'Configurações',
            onTap: _openSettings,
          ),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Sair/Logout',
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  // Método para criar seções de categorias expansíveis
  Widget _buildCategorySection(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: category['color'],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: category['color'].withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                category['icon'],
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Lista vertical dos itens da categoria
        ...category['items'].map<Widget>((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(
                Icons.description,
                color: category['color'],
              ),
              title: Text(item),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _openPDF(item),
            ),
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  // Método para criar títulos das seções
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
    );
  }

  // Método para criar listas horizontais
  Widget _buildHorizontalList(List<Map<String, dynamic>> items, {bool isResumeList = false, bool isVideoList = false}) {
    return SizedBox(
      height: isVideoList ? 120 : 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (isVideoList) {
            return _buildVideoCard(item);
          } else {
            return _buildResumeCard(item);
          }
        },
      ),
    );
  }

  // Card para resumos
  Widget _buildResumeCard(Map<String, dynamic> resume) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _openPDF(resume['title']),
        child: Container(
          decoration: BoxDecoration(
            color: resume['color'],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: resume['color'].withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                resume['icon'],
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  resume['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  resume['subtitle'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card para vídeos
  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _openVideo(video['title']),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        video['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video['subtitle'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duração: ${video['duration']}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para criar o menu de navegação horizontal principal
  Widget _buildHorizontalNavigationMenu() {
    return Column(
      children: [
        // Primeira linha de navegação
        Row(
          children: [
            Expanded(
              child: _buildNavigationCard(
                title: 'Ciclo Básico',
                icon: Icons.school,
                color: const Color(0xFF4F46E5),
                onTap: () => _openCategoryDetails(_categories[0]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNavigationCard(
                title: 'Disciplinas Clínicas',
                icon: Icons.medical_services,
                color: const Color(0xFF059669),
                onTap: () => _openCategoryDetails(_categories[1]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Segunda linha de navegação
        Row(
          children: [
            Expanded(
              child: _buildNavigationCard(
                title: 'Técnicas e Procedimentos',
                icon: Icons.build,
                color: const Color(0xFF7C3AED),
                onTap: () => _openCategoryDetails(_categories[2]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNavigationCard(
                title: 'Banco de Questões',
                icon: Icons.quiz,
                color: const Color(0xFFDC2626),
                onTap: () => _openCategoryDetails(_categories[3]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Método para criar cards de navegação
  Widget _buildNavigationCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryDetails(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category['icon'], color: category['color']),
                const SizedBox(width: 12),
                Text(
                  category['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...category['items'].map<Widget>((item) => ListTile(
              title: Text(item),
              onTap: () {
                Navigator.pop(context);
                _openPDF(item);
              },
            )).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

}
