import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class UploadService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> uploadAndInfer(File imageFile) async {
    final token = await _storage.read(key: "access");
    if (token == null) return null;

    // STEP 1: Upload Image
    final uploadUrl = Uri.parse("${Constants.baseUrl}/uploads/");

    var request = http.MultipartRequest("POST", uploadUrl);
    request.headers["Authorization"] = "Bearer $token";
    request.fields["upload_type"] = "image";
    request.files.add(
      await http.MultipartFile.fromPath("file", imageFile.path),
    );

    final uploadResponse = await request.send();

    if (uploadResponse.statusCode != 201) {
      return null;
    }

    final uploadData =
        jsonDecode(await uploadResponse.stream.bytesToString());

    final uploadId = uploadData["id"];

    // STEP 2: Run Inference
    final inferenceUrl =
        Uri.parse("${Constants.baseUrl}/uploads/$uploadId/run_inference/");

    final inferenceResponse = await http.post(
      inferenceUrl,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (inferenceResponse.statusCode == 200) {
      return jsonDecode(inferenceResponse.body);
    }

    return null;
  }
}
