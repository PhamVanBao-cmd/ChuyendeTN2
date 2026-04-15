import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AiScanService {
  static const apiKey = "AIzaSyDfE2sYEHlBEHQh1-QGUUdC84CRd_1N7ps";

  static Future<Map<String, dynamic>?> analyzeImage(File image) async {
    final bytes = await image.readAsBytes();
    String base64Image = base64Encode(bytes);

    final url =
        "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$apiKey";

    final body = {
      "contents": [
        {
          "parts": [
            {
              "text": """
Đọc thông tin sức khỏe từ ảnh và trả JSON:

{
  "systolic": number,
  "diastolic": number,
  "heartRate": number,
  "bloodSugar": number,
  "cholesterol": number
}

Chỉ trả JSON.
"""
            },
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64Image
              }
            }
          ]
        }
      ]
    };

    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      String text =
      data['candidates'][0]['content']['parts'][0]['text'];

      final start = text.indexOf("{");
      final end = text.lastIndexOf("}") + 1;

      return jsonDecode(text.substring(start, end));
    }

    return null;
  }
}