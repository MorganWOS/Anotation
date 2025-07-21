enum MediaType {
  text,
  image,
  video,
  audio,
}

class MediaContent {
  final String id;
  final MediaType type;
  final String content; // Para texto, será o texto; para mídia, será o caminho do arquivo
  final String? thumbnail; // Para vídeos, pode ter thumbnail
  final DateTime createdAt;
  final Duration? duration; // Para áudios e vídeos
  final String? fileName; // Nome original do arquivo

  MediaContent({
    required this.id,
    required this.type,
    required this.content,
    this.thumbnail,
    required this.createdAt,
    this.duration,
    this.fileName,
  });

  factory MediaContent.fromMap(Map<String, dynamic> map) {
    return MediaContent(
      id: map['id'],
      type: MediaType.values[map['type']],
      content: map['content'],
      thumbnail: map['thumbnail'],
      createdAt: DateTime.parse(map['createdAt']),
      duration: map['duration'] != null ? Duration(milliseconds: map['duration']) : null,
      fileName: map['fileName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'content': content,
      'thumbnail': thumbnail,
      'createdAt': createdAt.toIso8601String(),
      'duration': duration?.inMilliseconds,
      'fileName': fileName,
    };
  }

  static MediaContent createText(String text) {
    return MediaContent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MediaType.text,
      content: text,
      createdAt: DateTime.now(),
    );
  }

  static MediaContent createImage(String imagePath, String? fileName) {
    return MediaContent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MediaType.image,
      content: imagePath,
      createdAt: DateTime.now(),
      fileName: fileName,
    );
  }

  static MediaContent createVideo(String videoPath, String? fileName, {String? thumbnail, Duration? duration}) {
    return MediaContent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MediaType.video,
      content: videoPath,
      thumbnail: thumbnail,
      createdAt: DateTime.now(),
      duration: duration,
      fileName: fileName,
    );
  }

  static MediaContent createAudio(String audioPath, String? fileName, {Duration? duration}) {
    return MediaContent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MediaType.audio,
      content: audioPath,
      createdAt: DateTime.now(),
      duration: duration,
      fileName: fileName,
    );
  }
}
