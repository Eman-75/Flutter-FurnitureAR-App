import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageKitService {
  static final String _uploadUrl = "https://upload.imagekit.io/api/v1/files/upload";
  static final String _privateKey = "private_QzWAypJsB1HtTD4jkT+W4+osFFE=";

  static Future<String?> uploadFile(File file) async {
    final uri = Uri.parse("https://upload.imagekit.io/api/v1/files/upload");

    final request = http.MultipartRequest("POST", uri);
    final privateKey = "private_QzWAypJsB1HtTD4jkT+W4+osFFE=";

    final auth = base64Encode(utf8.encode("$privateKey:"));
    request.headers['Authorization'] = 'Basic $auth';

    request.fields['fileName'] = file.path.split('/').last;
    request.fields['useUniqueFileName'] = 'true';

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print("📩 Response body: $responseBody");

    final jsonResponse = jsonDecode(responseBody);

    if (response.statusCode == 200 && jsonResponse['url'] != null) {
      return jsonResponse['url'];
    } else {
      print("❌ Upload failed. Code: ${response.statusCode}");
      if (jsonResponse.containsKey("message")) {
        print("❗ Error Message: ${jsonResponse['message']}");
      }
      return null;
    }
  }

  static Future<void> deleteFileFromURL(String url) async {
    try {
      final fileId = extractFileIdFromUrl(url);
      if (fileId == null) return;

      final response = await http.delete(
        Uri.parse('https://upload.imagekit.io/api/v1/files/$fileId'),
        headers: {
          'Authorization': 'Basic YOUR_IMAGEKIT_AUTH_HEADER',
        },
      );

      if (response.statusCode == 204) {
        print('✅ File deleted from ImageKit: $fileId');
      } else {
        print('❌ Failed to delete file: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in deleteFileFromURL: $e');
    }
  }

// Helper to extract file ID from URL
  static String? extractFileIdFromUrl(String url) {
    final regex = RegExp(r'/([^/]+)\?tr=');
    final match = regex.firstMatch(url);
    return match != null ? match.group(1) : null;
  }


  static Future<void> saveProductToFirestore(String imageUrl, String modelUrl) async {
    await FirebaseFirestore.instance.collection('products').add({
      'image_url': imageUrl,
      'model_url': modelUrl,
    });
  }
}