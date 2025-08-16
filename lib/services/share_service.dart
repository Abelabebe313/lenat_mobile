import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  /// Validate if the URL is a valid image URL
  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      return path.endsWith('.jpg') || 
             path.endsWith('.jpeg') || 
             path.endsWith('.png') || 
             path.endsWith('.gif') || 
             path.endsWith('.webp') ||
             path.endsWith('.bmp');
    } catch (e) {
      return false;
    }
  }

  /// Download image from URL and return as bytes
  Future<Uint8List> _downloadImage(String imageUrl) async {
    try {
      debugPrint('Downloading image from: $imageUrl');
      
      // Validate URL format
      if (!_isValidImageUrl(imageUrl)) {
        debugPrint('Warning: URL may not be a valid image URL: $imageUrl');
      }
      
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
          'Accept': 'image/*',
          'Accept-Encoding': 'gzip, deflate',
        },
      );
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        debugPrint('Image downloaded successfully: ${bytes.length} bytes');
        
        // Check if we actually got image data
        if (bytes.length < 100) {
          debugPrint('Warning: Downloaded data seems too small for an image: ${bytes.length} bytes');
        }
        
        return bytes;
      } else {
        throw Exception('Failed to download image: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      rethrow;
    }
  }

  /// Create temporary file from image bytes
  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(bytes);
      
      // Verify file was created and has content
      if (await tempFile.exists() && await tempFile.length() > 0) {
        debugPrint('Temporary file created successfully: ${tempFile.path} (${await tempFile.length()} bytes)');
        return tempFile;
      } else {
        throw Exception('Failed to create temporary file or file is empty');
      }
    } catch (e) {
      debugPrint('Error creating temp file: $e');
      rethrow;
    }
  }

  /// Save image to gallery using image_gallery_saver_plus
  Future<bool> saveImageToGallery({
    required String imageUrl,
    String? name,
  }) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          debugPrint('Storage permission denied');
          return false;
        }
      }

      // Download the image
      final bytes = await _downloadImage(imageUrl);
      
      // Generate unique filename
      final fileName = name ?? 'lenat_content_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Save to gallery using image_gallery_saver_plus
      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: fileName,
      );

      if (result['isSuccess'] == true) {
        debugPrint('Image saved successfully: ${result['filePath']}');
        return true;
      } else {
        debugPrint('Failed to save image: $result');
        return false;
      }
    } catch (e) {
      debugPrint('Error saving image to gallery: $e');
      return false;
    }
  }

  /// Share image using legacy Share API (reliable method)
  Future<void> shareImageLegacy({
    required String imageUrl,
    required String description,
    String? subject,
  }) async {
    try {
      debugPrint('Starting image share process...');
      
      final bytes = await _downloadImage(imageUrl);
      final fileName = 'shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempFile = await _createTempFile(bytes, fileName);

      debugPrint('Sharing image file: ${tempFile.path}');
      
      // Use the legacy Share API (more reliable)
      final shareText = description.trim().isNotEmpty 
          ? description 
          : 'Check out this amazing content from Lenat Mobile!';
      
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: shareText,
      );

      debugPrint('Image shared successfully!');
      
      // Clean up temp file after sharing
      await tempFile.delete();
      debugPrint('Temporary file cleaned up');
    } catch (e) {
      debugPrint('Error sharing image: $e');
      rethrow;
    }
  }

  /// Share text only (fallback when image sharing fails)
  Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject ?? 'Check out this amazing content!',
      );
    } catch (e) {
      debugPrint('Error sharing text: $e');
      rethrow;
    }
  }
} 