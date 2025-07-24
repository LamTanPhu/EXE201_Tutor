import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class SupabaseService {
  static final _client = Supabase.instance.client;
  static const String _bucketName = 'images';
  static const int _maxFileSize = 5 * 1024 * 1024; //5MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png'];


  static Future<String?> uploadImage(File file, {String? oldFilePath, bool upsert = true}) async {
    try {
      // Kiểm tra kích thước file
      final fileSize = await file.length();
      if (fileSize > _maxFileSize) {
        throw Exception('Kích thước file vượt quá giới hạn 5MB');
      }

      // Kiểm tra định dạng file
      final extension = path.extension(file.path).toLowerCase().replaceAll('.', '');
      if (!_allowedExtensions.contains(extension)) {
        throw Exception('Định dạng file không được hỗ trợ. Chỉ chấp nhận: ${_allowedExtensions.join(', ')}');
      }

      // Tạo tên file duy nhất
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final fileBytes = await file.readAsBytes();

      // Upload ảnh mới
      final response = await _client.storage.from(_bucketName).uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(
              contentType: 'image/$extension',
              cacheControl: '3600', // Cache 1 giờ
              upsert: upsert,
            ),
          );

      if (response.isEmpty) {
        throw Exception('Không thể upload ảnh lên Supabase Storage');
      }

      // Xóa ảnh cũ nếu có
      if (oldFilePath != null && oldFilePath.isNotEmpty) {
        final oldFileName = oldFilePath.split('/').last;
        try {
          await _client.storage.from(_bucketName).remove([oldFileName]);
        } catch (e) {
          // Log lỗi xóa file cũ nhưng không làm gián đoạn quá trình
          print('Lỗi khi xóa ảnh cũ: $e');
        }
      }

      // Lấy public URL của ảnh
      final imageUrl = _client.storage.from(_bucketName).getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      throw Exception('Không thể upload ảnh: $e');
    }
  }

  /// Xóa file trong bucket
  static Future<void> deleteImage(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      await _client.storage.from(_bucketName).remove([fileName]);
    } catch (e) {
      throw Exception('Không thể xóa ảnh: $e');
    }
  }
}