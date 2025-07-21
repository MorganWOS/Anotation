import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/media_content.dart';

class MediaService {
  static final ImagePicker _imagePicker = ImagePicker();
  static final AudioRecorder _audioRecorder = AudioRecorder();
  static bool _isRecording = false;

  // Solicitar permissões
  static Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  // Capturar foto da câmera
  static Future<MediaContent?> capturePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        return MediaContent.createImage(
          photo.path,
          photo.name,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao capturar foto: $e');
      return null;
    }
  }

  // Selecionar foto da galeria
  static Future<MediaContent?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return MediaContent.createImage(
          image.path,
          image.name,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
      return null;
    }
  }

  // Capturar vídeo da câmera
  static Future<MediaContent?> captureVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null) {
        return MediaContent.createVideo(
          video.path,
          video.name,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao capturar vídeo: $e');
      return null;
    }
  }

  // Selecionar vídeo da galeria
  static Future<MediaContent?> pickVideoFromGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        return MediaContent.createVideo(
          video.path,
          video.name,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao selecionar vídeo: $e');
      return null;
    }
  }

  // Iniciar gravação de áudio
  static Future<bool> startAudioRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String audioPath = '${appDocDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: audioPath,
        );

        _isRecording = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao iniciar gravação: $e');
      return false;
    }
  }

  // Parar gravação de áudio
  static Future<MediaContent?> stopAudioRecording() async {
    try {
      final String? audioPath = await _audioRecorder.stop();
      _isRecording = false;

      if (audioPath != null) {
        final File audioFile = File(audioPath);
        if (await audioFile.exists()) {
          return MediaContent.createAudio(
            audioPath,
            'audio_${DateTime.now().millisecondsSinceEpoch}.aac',
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao parar gravação: $e');
      return null;
    }
  }

  // Verificar se está gravando
  static bool get isRecording => _isRecording;

  // Cancelar gravação
  static Future<void> cancelAudioRecording() async {
    try {
      await _audioRecorder.cancel();
      _isRecording = false;
    } catch (e) {
      debugPrint('Erro ao cancelar gravação: $e');
    }
  }

  // Selecionar arquivo genérico
  static Future<MediaContent?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        
        // Determinar tipo de mídia baseado na extensão
        String? extension = file.extension?.toLowerCase();
        MediaType type = MediaType.text;
        
        if (extension != null) {
          if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
            type = MediaType.image;
          } else if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension)) {
            type = MediaType.video;
          } else if (['mp3', 'aac', 'wav', 'ogg', 'm4a'].contains(extension)) {
            type = MediaType.audio;
          }
        }

        return MediaContent(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: type,
          content: file.path!,
          createdAt: DateTime.now(),
          fileName: file.name,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao selecionar arquivo: $e');
      return null;
    }
  }

  // Limpar recursos
  static Future<void> dispose() async {
    if (_isRecording) {
      await _audioRecorder.stop();
    }
    await _audioRecorder.dispose();
  }
}
