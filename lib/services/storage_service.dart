import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

class StorageService {
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();
  final _logger = Logger('StorageService');

  Future<String?> uploadEventImage(XFile imageFile) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final bytes = await imageFile.readAsBytes();
      final String filePath = 'events/$fileName.${imageFile.name.split('.').last}';
      
      await _supabase.storage
          .from('event_images')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      final String imageUrl = _supabase.storage
          .from('event_images')
          .getPublicUrl(filePath);

      _logger.info('Image uploaded successfully: $filePath');
      return imageUrl;
    } catch (error) {
      _logger.severe('Error uploading image', error);
      return null;
    }
  }

  Future<XFile?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      return image;
    } catch (error) {
      _logger.severe('Error picking image', error);
      return null;
    }
  }
}
