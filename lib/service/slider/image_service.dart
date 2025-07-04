import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';

class ImageService {
  Future uploadImage(
      String route, String token, String method, String imageId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes?.toList();
      final fileName = result.files.first.name;

      var request = http.MultipartRequest(
          method, Uri.parse("${ApiContants.baseApi}/$route/$imageId"));

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          fileBytes!,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      try {
        await request.send();
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao enviar a imagem: $e');
        }
      }
    }
  }
}
