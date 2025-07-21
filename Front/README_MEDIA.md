# Funcionalidades de Mídia - Anotation AI

## Novas Funcionalidades Implementadas

### 1. Captura de Fotos
- **Botão**: Câmera (azul claro)
- **Funcionalidade**: Permite capturar fotos usando a câmera do dispositivo
- **Formato**: JPG com qualidade otimizada (1920x1080, 85% de qualidade)

### 2. Gravação de Vídeos
- **Botão**: Filmadora (amarelo)
- **Funcionalidade**: Permite gravar vídeos usando a câmera do dispositivo
- **Duração**: Limitado a 5 minutos por vídeo
- **Reprodução**: Vídeos podem ser reproduzidos diretamente no app

### 3. Gravação de Áudio
- **Botão**: Microfone (verde/vermelho)
- **Funcionalidade**: Permite gravar áudio em tempo real
- **Estados**: 
  - Verde: Pronto para gravar
  - Vermelho: Gravando (mostrar "stop" icon)
- **Formato**: AAC com qualidade CD (44.1kHz, 128kbps)

### 4. Visualização de Mídia
- **Widget personalizado**: `MediaContentWidget`
- **Tipos suportados**: Texto, Imagem, Vídeo, Áudio
- **Funcionalidades**:
  - Cabeçalho com tipo de mídia e timestamp
  - Visualização inline de imagens
  - Player de vídeo com controles
  - Player de áudio com informações
  - Botão de exclusão para cada item

## Estrutura de Arquivos

```
lib/
├── models/
│   └── media_content.dart      # Modelo para conteúdo de mídia
├── services/
│   └── media_service.dart      # Serviço para operações de mídia
├── widgets/
│   └── media_content_widget.dart # Widget para exibir conteúdo de mídia
└── screens/
    └── home_screen.dart        # Tela principal com funcionalidades integradas
```

## Permissões Necessárias

O app solicita as seguintes permissões automaticamente:
- **Câmera**: Para capturar fotos e vídeos
- **Microfone**: Para gravar áudio
- **Armazenamento**: Para salvar e acessar arquivos de mídia
- **Fotos**: Para acessar galeria de fotos

## Dependências Adicionadas

```yaml
dependencies:
  image_picker: ^1.0.4          # Captura de fotos e vídeos
  video_player: ^2.8.1          # Reprodução de vídeos
  audio_waveforms: ^1.0.5       # Visualização de áudio
  record: ^5.0.4                # Gravação de áudio
  permission_handler: ^11.0.1    # Gerenciamento de permissões
  path_provider: ^2.1.1         # Acesso a diretórios do sistema
  file_picker: ^6.1.1           # Seleção de arquivos
```

## Como Usar

### Capturar Foto
1. Toque no botão da câmera (azul claro)
2. O app solicitará permissões se necessário
3. A câmera será aberta para capturar a foto
4. A foto aparecerá na sessão atual

### Gravar Vídeo
1. Toque no botão da filmadora (amarelo)
2. O app solicitará permissões se necessário
3. A câmera será aberta para gravar vídeo
4. O vídeo aparecerá na sessão com controles de reprodução

### Gravar Áudio
1. Toque no botão do microfone (verde)
2. O app solicitará permissões se necessário
3. A gravação iniciará (botão fica vermelho)
4. Toque novamente para parar a gravação
5. O áudio aparecerá na sessão com informações de duração

### Visualizar Conteúdo
- **Imagens**: Exibidas em tamanho completo
- **Vídeos**: Player com controles de play/pause
- **Áudios**: Informações do arquivo com duração
- **Todos**: Timestamp de criação e botão de exclusão

## Características Técnicas

### Otimizações
- Imagens são redimensionadas automaticamente
- Vídeos têm duração limitada para economizar espaço
- Áudios são comprimidos em formato AAC
- Cache inteligente para reprodução de mídia

### Gerenciamento de Memória
- Dispose automático de recursos de vídeo
- Limpeza de gravadores de áudio
- Gerenciamento de estado para gravação

### Interface do Usuário
- Botões coloridos para fácil identificação
- Feedback visual durante operações
- Mensagens de erro amigáveis
- Diálogos de permissão informativos

## Futuras Melhorias

- [ ] Edição básica de imagens
- [ ] Compressão de vídeos
- [ ] Transcrição de áudio para texto
- [ ] Sincronização com nuvem
- [ ] Organização por tags
- [ ] Busca por conteúdo de mídia
