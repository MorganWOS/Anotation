import 'media_content.dart';

class Session {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastModified;
  final List<MediaContent> contents;
  final String? description;

  Session({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastModified,
    required this.contents,
    this.description,
  });

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['createdAt']),
      lastModified: DateTime.parse(map['lastModified']),
      contents: (map['contents'] as List)
          .map((content) => MediaContent.fromMap(content))
          .toList(),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'contents': contents.map((content) => content.toMap()).toList(),
      'description': description,
    };
  }

  Session copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastModified,
    List<MediaContent>? contents,
    String? description,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      contents: contents ?? this.contents,
      description: description ?? this.description,
    );
  }

  int get contentCount => contents.length;

  int get textCount => contents.where((c) => c.type == MediaType.text).length;
  int get imageCount => contents.where((c) => c.type == MediaType.image).length;
  int get videoCount => contents.where((c) => c.type == MediaType.video).length;
  int get audioCount => contents.where((c) => c.type == MediaType.audio).length;

  static Session createNew(String title, {String? description}) {
    final now = DateTime.now();
    return Session(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
      lastModified: now,
      contents: [],
      description: description,
    );
  }

  Session addContent(MediaContent content) {
    final updatedContents = [...contents, content];
    return copyWith(
      contents: updatedContents,
      lastModified: DateTime.now(),
    );
  }

  Session removeContent(String contentId) {
    final updatedContents = contents.where((c) => c.id != contentId).toList();
    return copyWith(
      contents: updatedContents,
      lastModified: DateTime.now(),
    );
  }

  Session updateContent(String contentId, MediaContent newContent) {
    final updatedContents = contents.map((c) => 
        c.id == contentId ? newContent : c).toList();
    return copyWith(
      contents: updatedContents,
      lastModified: DateTime.now(),
    );
  }

  String getFormattedLastModified() {
    final now = DateTime.now();
    final difference = now.difference(lastModified);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Agora';
        }
        return '${difference.inMinutes} min atrás';
      }
      return '${difference.inHours}h atrás';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${lastModified.day}/${lastModified.month}/${lastModified.year}';
    }
  }

  String getContentSummary() {
    if (contents.isEmpty) return 'Nenhum conteúdo';
    
    final List<String> parts = [];
    
    if (textCount > 0) parts.add('$textCount texto${textCount > 1 ? 's' : ''}');
    if (imageCount > 0) parts.add('$imageCount imagem${imageCount > 1 ? 'ns' : ''}');
    if (videoCount > 0) parts.add('$videoCount vídeo${videoCount > 1 ? 's' : ''}');
    if (audioCount > 0) parts.add('$audioCount áudio${audioCount > 1 ? 's' : ''}');
    
    return parts.join(' • ');
  }
}
