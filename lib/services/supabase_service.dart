import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  static Future<String?> uploadImage(File file) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final fileBytes = await file.readAsBytes();

      // Sử dụng uploadBinary để upload file (hỗ trợ tốt hơn cho nhiều nền tảng)
      final path = await _client.storage
          .from('images')
          .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      if (path.isEmpty) {
        throw Exception('Upload failed');
      }

      final imageUrl = _client.storage.from('images').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}