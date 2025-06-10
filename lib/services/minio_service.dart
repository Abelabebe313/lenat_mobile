import 'dart:io';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;

class MinioService {
  late final Minio _minio;
  final String _bucketName;

  MinioService({
    required String endpoint,
    required String accessKey,
    required String secretKey,
    required String bucketName,
    bool useSSL = false,
  }) : _bucketName = bucketName {
    // Parse the endpoint to get host and port
    String host = endpoint;
    int port = 9000; // MinIO API port (not the web console port 9001)

    // Remove protocol if present
    if (host.startsWith('http://')) {
      host = host.substring(7);
    } else if (host.startsWith('https://')) {
      host = host.substring(8);
    }

    // Remove path if present
    if (host.contains('/')) {
      host = host.split('/')[0];
    }

    // Extract port if present, but override with API port
    if (host.contains(':')) {
      host = host.split(':')[0];
    }

    print('Using MinIO host: $host, port: $port');

    _minio = Minio(
      endPoint: host,
      port: port,
      accessKey: accessKey,
      secretKey: secretKey,
      useSSL: useSSL,
    );
  }

  Future<String> uploadFile(File file) async {
    try {
      final fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';

      // Create a stream from the file and convert to Uint8List
      final fileStream =
          file.openRead().map((chunk) => Uint8List.fromList(chunk));
      final fileSize = await file.length();

      // Upload the file
      await _minio.putObject(
        _bucketName,
        fileName,
        fileStream,
        size: fileSize,
        metadata: {
          'Content-Type': 'image/${path.extension(file.path).substring(1)}',
        },
        onProgress: (progress) {
          print(
              'Upload progress: ${(progress / fileSize * 100).toStringAsFixed(2)}%');
        },
      );

      // Get the URL of the uploaded file
      final url = await _minio.presignedGetObject(_bucketName, fileName);
      return url;
    } catch (e) {
      print('Error uploading file to MinIO: $e');
      rethrow;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await _minio.removeObject(_bucketName, fileName);
    } catch (e) {
      print('Error deleting file from MinIO: $e');
      rethrow;
    }
  }
}
