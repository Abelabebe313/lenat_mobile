import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  /// Share image to social media platforms
  Future<void> shareImage({
    required String imageUrl,
    required String description,
    String? subject,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/shared_image.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share the image
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: description,
          subject: subject ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing image: $e');
      rethrow;
    }
  }

  /// Save image to gallery
  Future<bool> saveImageToGallery({
    required String imageUrl,
    String? name,
  }) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return false;
      }

      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/shared_image.jpg');
        await tempFile.writeAsBytes(response.bodyBytes);
        
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
      return false;
    }
  }

  /// Share to specific social media platforms
  Future<void> shareToInstagram({
    required String imageUrl,
    String? caption,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/instagram_share.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share to Instagram
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: caption ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing to Instagram: $e');
      rethrow;
    }
  }

  /// Share to Facebook
  Future<void> shareToFacebook({
    required String imageUrl,
    String? description,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/facebook_share.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share to Facebook
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: description ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing to Facebook: $e');
      rethrow;
    }
  }

  /// Share to Twitter/X
  Future<void> shareToTwitter({
    required String imageUrl,
    String? text,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/twitter_share.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share to Twitter
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: text ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing to Twitter: $e');
      rethrow;
    }
  }

  /// Share to WhatsApp
  Future<void> shareToWhatsApp({
    required String imageUrl,
    String? message,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/whatsapp_share.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share to WhatsApp
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: message ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing to WhatsApp: $e');
      rethrow;
    }
  }

  /// Share to Telegram
  Future<void> shareToTelegram({
    required String imageUrl,
    String? caption,
  }) async {
    try {
      // Download the image with headers to handle 403 errors
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        // Create temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/telegram_share.jpg');
        await tempFile.writeAsBytes(bytes);

        // Share to Telegram
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: caption ?? 'Check out this amazing content!',
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sharing to Telegram: $e');
      rethrow;
    }
  }
} 