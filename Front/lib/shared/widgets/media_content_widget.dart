import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/models/media_content.dart';
import '../../core/constants/app_theme.dart';

class MediaContentWidget extends StatefulWidget {
  final MediaContent mediaContent;
  final VoidCallback? onDelete;

  const MediaContentWidget({
    Key? key,
    required this.mediaContent,
    this.onDelete,
  }) : super(key: key);

  @override
  State<MediaContentWidget> createState() => _MediaContentWidgetState();
}

class _MediaContentWidgetState extends State<MediaContentWidget> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  
  // Audio player variables
  AudioPlayer? _audioPlayer;
  bool _isAudioInitialized = false;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.mediaContent.type == MediaType.video) {
      _initializeVideo();
    } else if (widget.mediaContent.type == MediaType.audio) {
      _initializeAudio();
    }
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.file(File(widget.mediaContent.content))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  void _initializeAudio() {
    _audioPlayer = AudioPlayer();
    
    _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer!.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer!.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
          _isAudioInitialized = true;
        });
      }
    });
  }

  Future<void> _playPauseAudio() async {
    if (_audioPlayer == null) return;

    if (_isPlaying) {
      await _audioPlayer!.pause();
    } else {
      await _audioPlayer!.play(DeviceFileSource(widget.mediaContent.content));
    }
  }

  Future<void> _seekAudio(Duration position) async {
    if (_audioPlayer == null) return;
    await _audioPlayer!.seek(position);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com informações
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.borderRadiusMedium),
                  topRight: Radius.circular(AppTheme.borderRadiusMedium),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconForType(widget.mediaContent.type),
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeLabel(widget.mediaContent.type),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          _formatDateTime(widget.mediaContent.createdAt),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.mediaContent.duration != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                      ),
                      child: Text(
                        _formatDuration(widget.mediaContent.duration!),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: widget.onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
            // Conteúdo da mídia
            _buildMediaContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    switch (widget.mediaContent.type) {
      case MediaType.text:
        return Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMedium),
          child: Text(
            widget.mediaContent.content,
            style: const TextStyle(fontSize: 16),
          ),
        );
      case MediaType.image:
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppTheme.borderRadiusMedium),
            bottomRight: Radius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Image.file(
            File(widget.mediaContent.content),
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        );
      case MediaType.video:
        return _buildVideoPlayer();
      case MediaType.audio:
        return _buildAudioPlayer();
    }
  }

  Widget _buildVideoPlayer() {
    if (!_isVideoInitialized || _videoController == null) {
      return Container(
        height: 200,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppTheme.borderRadiusMedium),
        bottomRight: Radius.circular(AppTheme.borderRadiusMedium),
      ),
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_videoController!),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      child: Column(
        children: [
          // Informações do arquivo
          Row(
            children: [
              Icon(
                Icons.audio_file,
                size: 24,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              Expanded(
                child: Text(
                  widget.mediaContent.fileName ?? 'Arquivo de Áudio',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          // Controles do player
          Row(
            children: [
              // Botão play/pause
              GestureDetector(
                onTap: _playPauseAudio,
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSmall),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              // Tempo atual
              Text(
                _formatDuration(_currentPosition),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              // Slider de progresso
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primaryColor,
                    inactiveTrackColor: AppTheme.primaryColor.withOpacity(0.3),
                    thumbColor: AppTheme.primaryColor,
                    overlayColor: AppTheme.primaryColor.withOpacity(0.2),
                    trackHeight: 2.0,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6.0,
                    ),
                  ),
                  child: Slider(
                    value: _totalDuration.inMilliseconds > 0
                        ? _currentPosition.inMilliseconds.toDouble()
                        : 0.0,
                    max: _totalDuration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      _seekAudio(Duration(milliseconds: value.round()));
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              // Tempo total
              Text(
                _formatDuration(_totalDuration.inMilliseconds > 0 
                    ? _totalDuration 
                    : widget.mediaContent.duration ?? Duration.zero),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(MediaType type) {
    switch (type) {
      case MediaType.text:
        return Icons.text_fields;
      case MediaType.image:
        return Icons.image;
      case MediaType.video:
        return Icons.video_camera_back;
      case MediaType.audio:
        return Icons.audio_file;
    }
  }

  String _getTypeLabel(MediaType type) {
    switch (type) {
      case MediaType.text:
        return 'Texto';
      case MediaType.image:
        return 'Imagem';
      case MediaType.video:
        return 'Vídeo';
      case MediaType.audio:
        return 'Áudio';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
