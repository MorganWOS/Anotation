# Telas do App "Resumos odonto"

Este documento descreve as telas criadas para o aplicativo Flutter baseado nas imagens fornecidas.

## 🔐 Tela de Login
**Arquivo:** `lib/presentation/pages/login_screen.dart`

### Funcionalidades:
- Campos de usuário e senha
- Botão de login funcional
- Link para cadastro
- Validação de campos
- Integração com AuthService
- Design moderno com tema customizado

### Características:
- Interface limpa e profissional
- Feedback visual durante o login
- Navegação para home após login bem-sucedido
- Botão de teste para desenvolvimento

---

## 🏠 Tela Principal (Home)
**Arquivo:** `lib/presentation/pages/home_screen.dart`

### Estrutura:
- **AppBar** com logo "Resumos odonto" e notificações
- **Bottom Navigation** com 4 abas:
  - 🏠 Página Inicial
  - ⭐ Favoritos
  - ▶️ Aulas
  - ☰ Mais

### Aba Página Inicial:
- Grid 2x2 com categorias principais:
  - **Ciclo Básico** (Anatomia, Fisiologia, Histologia, Bioquímica)
  - **Disciplinas Clínicas** (Periodontia, Endodontia, Prótese, Cirurgia)
  - **Técnicas e Procedimentos** (Anestesia, Radiologia, Materiais)
  - **Banco de Questões** (Simulados, Questões por tema)

### Aba Favoritos:
- Exibe resumos salvos pelo usuário
- Opção de criar pastas organizadas
- Cards com resumos favoritados
- Funcionalidade de organização pessoal

### Aba Videoaulas:
- Lista de vídeos educacionais
- Indicação de duração
- Redirecionamento para YouTube (otimização de tamanho)
- Thumbnails personalizados

### Aba Mais:
- Menu de configurações
- Navegação entre abas
- Opções de logout
- Links para outras seções

---

## 📄 Tela de Visualização de PDF
**Arquivo:** `lib/presentation/pages/pdf_viewer_screen.dart`

### Funcionalidades:
- Área de visualização do PDF
- Sistema de anotações integrado
- Botão de favoritar/desfavoritar
- Compartilhamento controlado
- Interface similar ao Microsoft Edge PDF viewer

### Características:
- **Área Superior**: Visualização do PDF
- **Área Inferior**: Painel de anotações
- **Segurança**: Prevenção de screenshots
- **Interatividade**: Grifar e anotar conteúdo

### Anotações:
- Campo para adicionar novas anotações
- Lista de anotações salvas
- Opção de deletar anotações
- Sincronização com favoritos

---

## 🎥 Tela de Videoaulas
**Arquivo:** `lib/presentation/pages/video_screen.dart`

### Funcionalidades:
- Player de vídeo placeholder
- Informações do vídeo
- Botão de redirecionamento para YouTube
- Lista de vídeos relacionados
- Otimização de tamanho do app

### Características:
- **Área do Player**: Simulação do player de vídeo
- **Informações**: Título, descrição, duração
- **Navegação**: Vídeos relacionados
- **Performance**: Redirecionamento externo para economizar espaço

---

## ⭐ Tela de Favoritos
**Arquivo:** `lib/presentation/pages/favorites_screen.dart`

### Funcionalidades:
- Organização por pastas
- Criação de pastas personalizadas
- Gestão de itens favoritados
- Acesso rápido aos conteúdos salvos

### Características:
- **Criação de Pastas**: Organização personalizada
- **Gestão de Conteúdo**: Adicionar/remover favoritos
- **Navegação**: Acesso direto aos PDFs
- **Interface**: Cards organizados por categoria

### Exemplo de Organização:
```
📁 Anatomia
  - #1. Anatomia Dentária
  - #2. Anatomia de Cabeça e Pescoço

📁 Procedimentos
  - #3. Fisiologia Oral
```

---

## ⚙️ Tela de Configurações
**Arquivo:** `lib/presentation/pages/settings_screen.dart`

### Funcionalidades:
- Edição de perfil do usuário
- Alteração de nome
- Troca de foto de perfil
- Logout do sistema

### Características:
- **Perfil**: Avatar circular e informações
- **Campos Editáveis**: Nome do usuário
- **Campos Somente Leitura**: Email
- **Ações**: Salvar alterações e logout

### Limitações (conforme especificação):
- Apenas nome e foto podem ser alterados
- Email é somente visualização
- Foco na simplicidade e usabilidade

---

## 🎨 Tema e Design

### Paleta de Cores:
- **Primária**: Azul índigo (#6366F1)
- **Secundária**: Verde (#10B981)
- **Accent**: Âmbar (#F59E0B)
- **Backgrounds**: Tons de cinza claro
- **Textos**: Escala de cinza escuro

### Componentes:
- **Cards**: Sombras suaves e bordas arredondadas
- **Botões**: Estilo Material Design 3
- **Inputs**: Bordas arredondadas e preenchimento
- **Navegação**: Bottom navigation com ícones

### Características do Design:
- Interface limpa e profissional
- Foco na usabilidade odontológica
- Consistência visual em todas as telas
- Responsividade para diferentes tamanhos de tela

---

## 🔧 Arquitetura do Projeto

### Estrutura de Pastas:
```
lib/
├── core/
│   └── constants/
│       └── app_theme.dart
├── presentation/
│   └── pages/
│       ├── login_screen.dart
│       ├── home_screen.dart
│       ├── pdf_viewer_screen.dart
│       ├── video_screen.dart
│       ├── favorites_screen.dart
│       └── settings_screen.dart
└── main.dart
```

### Navegação:
- **Inicial**: Login screen
- **Principal**: Home com bottom navigation
- **Detalhes**: PDF viewer e video player
- **Configurações**: Settings e profile

### Estados:
- Gerenciamento de estado local com StatefulWidget
- Navegação com Navigator.push/pop
- Dados temporários em memória (para demonstração)

---

## 🚀 Próximos Passos

### Implementações Futuras:
1. **Backend Integration**: Conectar com APIs reais
2. **Authentication**: Sistema de login completo
3. **PDF Rendering**: Integração com bibliotecas de PDF
4. **Video Streaming**: Player de vídeo nativo
5. **Security**: Prevenção de screenshots e DRM
6. **Offline Support**: Cache de conteúdo
7. **Push Notifications**: Notificações de novos conteúdos
8. **Analytics**: Tracking de uso e engajamento

### Melhorias UX/UI:
1. **Animations**: Transições suaves
2. **Loading States**: Indicadores de carregamento
3. **Error Handling**: Tratamento de erros elegante
4. **Accessibility**: Suporte a leitores de tela
5. **Dark Mode**: Tema escuro opcional

---

## 📱 Funcionalidades Implementadas

### ✅ Completas:
- Tela de login funcional
- Navegação entre telas
- Sistema de abas (bottom navigation)
- Interface de favoritos
- Configurações de usuário
- Tema customizado

### 🔄 Em Desenvolvimento:
- Visualização de PDF
- Player de vídeo
- Sistema de anotações
- Prevenção de screenshots

### 📋 Planejadas:
- Integração com backend
- Sistema de pagamento
- Notificações push
- Sincronização na nuvem

---

Este documento serve como guia de referência para o desenvolvimento e manutenção das telas do aplicativo "Resumos odonto", baseado nas especificações e imagens fornecidas.
