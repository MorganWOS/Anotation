import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../data/datasources/media_service.dart';
import '../../data/models/media_content.dart';

class MediaToolbar extends StatefulWidget {
  final Function(MediaContent) onMediaAdded;
  final bool isRecording;

  const MediaToolbar({
    Key? key,
    required this.onMediaAdded,
    this.isRecording = false,
  }) : super(key: key);

  @override
  State<MediaToolbar> createState() => _MediaToolbarState();
}

class _MediaToolbarState extends State<MediaToolbar>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isRecordingAudio = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _requestPermissions() async {
    final hasPermissions = await MediaService.requestPermissions();
    if (!hasPermissions && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissões necessárias não foram concedidas'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _handleMediaAction(Future<MediaContent?> Function() action) async {
    await _requestPermissions();
    
    try {
      final mediaContent = await action();
      if (mediaContent != null) {
        widget.onMediaAdded(mediaContent);
        _toggleExpanded(); // Fecha a barra após adicionar mídia
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _toggleAudioRecording() async {
    if (_isRecordingAudio) {
      // Parar gravação
      final audioContent = await MediaService.stopAudioRecording();
      if (audioContent != null) {
        widget.onMediaAdded(audioContent);
      }
      setState(() {
        _isRecordingAudio = false;
      });
    } else {
      // Iniciar gravação
      await _requestPermissions();
      final started = await MediaService.startAudioRecording();
      if (started) {
        setState(() {
          _isRecordingAudio = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível iniciar a gravação'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showMediaSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            const Text(
              'Adicionar Mídia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            _MediaSourceButton(
              icon: Icons.camera_alt,
              title: 'Câmera (Foto)',
              subtitle: 'Tirar uma foto',
              onTap: () {
                Navigator.pop(context);
                _handleMediaAction(MediaService.capturePhoto);
              },
            ),
            _MediaSourceButton(
              icon: Icons.photo_library,
              title: 'Galeria (Foto)',
              subtitle: 'Escolher da galeria',
              onTap: () {
                Navigator.pop(context);
                _handleMediaAction(MediaService.pickImageFromGallery);
              },
            ),
            _MediaSourceButton(
              icon: Icons.videocam,
              title: 'Câmera (Vídeo)',
              subtitle: 'Gravar um vídeo',
              onTap: () {
                Navigator.pop(context);
                _handleMediaAction(MediaService.captureVideo);
              },
            ),
            _MediaSourceButton(
              icon: Icons.video_library,
              title: 'Galeria (Vídeo)',
              subtitle: 'Escolher da galeria',
              onTap: () {
                Navigator.pop(context);
                _handleMediaAction(MediaService.pickVideoFromGallery);
              },
            ),
            _MediaSourceButton(
              icon: Icons.attach_file,
              title: 'Arquivo',
              subtitle: 'Escolher arquivo',
              onTap: () {
                Navigator.pop(context);
                _handleMediaAction(MediaService.pickFile);
              },
            ),
            const SizedBox(height: AppTheme.spacingMedium),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          // Barra expandida com opções
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _animation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMedium,
                    vertical: AppTheme.spacingSmall,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MediaActionButton(
                        icon: Icons.camera_alt,
                        label: 'Foto',
                        onTap: () => _handleMediaAction(MediaService.capturePhoto),
                      ),
                      _MediaActionButton(
                        icon: Icons.videocam,
                        label: 'Vídeo',
                        onTap: () => _handleMediaAction(MediaService.captureVideo),
                      ),
                      _MediaActionButton(
                        icon: _isRecordingAudio ? Icons.stop : Icons.mic,
                        label: _isRecordingAudio ? 'Parar' : 'Áudio',
                        isActive: _isRecordingAudio,
                        onTap: _toggleAudioRecording,
                      ),
                      _MediaActionButton(
                        icon: Icons.attach_file,
                        label: 'Arquivo',
                        onTap: _showMediaSourceDialog,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Barra principal
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              children: [
                // Botão de expandir/recolher
                IconButton(
                  onPressed: _toggleExpanded,
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.add),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                // Indicador de gravação se estiver gravando
                if (_isRecordingAudio) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: AppTheme.spacingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                      border: Border.all(color: AppTheme.errorColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.errorColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        const Text(
                          'Gravando áudio...',
                          style: TextStyle(
                            color: AppTheme.errorColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Expanded(
                    child: Text(
                      'Toque no + para adicionar mídia',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _MediaActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSmall,
          vertical: AppTheme.spacingMedium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSmall),
              decoration: BoxDecoration(
                color: isActive 
                    ? AppTheme.errorColor 
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: isActive 
                    ? Colors.white 
                    : AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive 
                    ? AppTheme.errorColor 
                    : AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaSourceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MediaSourceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSmall),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }
}
