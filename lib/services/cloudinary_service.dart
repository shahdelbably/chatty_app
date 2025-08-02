import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:developer';

class CloudinaryService {
  final String cloudName = 'dbv3qwjpu';
  final String uploadPreset = 'user_profile_pic';

  final Dio dio = Dio();

  Future<String> uploadImage(File imageFile) async {
    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        log(
          "Image uploaded to Cloudinary successfully: ${response.data['secure_url']}",
        );
        return response.data['secure_url'];
      } else {
        log(
          "Failed to upload image to Cloudinary. Status: ${response.statusCode}, Data: ${response.data}",
        );
        throw Exception(
          'Failed to upload image to Cloudinary: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      log("Dio error uploading image: $e");
      if (e.response != null) {
        log("Dio error response: ${e.response?.data}");
      }
      throw Exception(
        'Network or server error during image upload: ${e.message}',
      );
    } catch (e) {
      log("Unexpected error uploading image: $e");
      rethrow;
    }
  }
}
