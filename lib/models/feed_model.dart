class FeedPostModel {
  final String id;
  final String userId;
  final bool isBookmarked;
  final bool isLiked;
  final String? description;
  final String state;
  final String mediaId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Media media;

  FeedPostModel({
    required this.id,
    required this.userId,
    required this.isBookmarked,
    required this.isLiked,
    this.description,
    required this.state,
    required this.mediaId,
    required this.createdAt,
    required this.updatedAt,
    required this.media,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    try {
      return FeedPostModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        isBookmarked: json['is_bookmarked'] as bool? ?? false,
        isLiked: json['is_liked'] as bool? ?? false,
        description: json['description']?.toString(),
        state: json['state']?.toString() ?? '',
        mediaId: json['media_id']?.toString() ?? '',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'].toString())
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'].toString())
            : DateTime.now(),
        media: Media.fromJson(json['media'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      print('Error parsing FeedPostModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_bookmarked': isBookmarked,
      'is_liked': isLiked,
      'description': description,
      'state': state,
      'media_id': mediaId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'media': media.toJson(),
    };
  }
}

class Media {
  final String id;
  final String ownerId;
  final String url;
  final String fileName;
  final DateTime createdAt;
  final String blurHash;

  Media({
    required this.id,
    required this.ownerId,
    required this.url,
    required this.fileName,
    required this.createdAt,
    required this.blurHash,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    try {
      return Media(
        id: json['id']?.toString() ?? '',
        ownerId: json['owner_id']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        fileName: json['file_name']?.toString() ?? '',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'].toString())
            : DateTime.now(),
        blurHash: json['blur_hash']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Media: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'url': url,
      'file_name': fileName,
      'created_at': createdAt.toIso8601String(),
      'blur_hash': blurHash,
    };
  }
}
