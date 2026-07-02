import 'dart:convert';
import 'dart:io';

/// VetAI yordamchisi uchun repozitoriy.
/// Gemini API orqali to'liq chat muloqotini amalga oshiradi.
class AiRepository {
  /// Gemini API orqali savol-javob qilish.
  /// Chat tarixini va API kalitni qabul qiladi.
  Future<String> getAiResponse(List<Map<String, String>> history, String apiKey) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);
    
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
      );
      
      final request = await client.postUrl(url);
      request.headers.set('Content-Type', 'application/json');

      final body = {
        'contents': history.map((msg) {
          return {
            'role': msg['role'] == 'user' ? 'user' : 'model',
            'parts': [
              {'text': msg['text']}
            ],
          };
        }).toList(),
        'systemInstruction': {
          'parts': [
            {
              'text':
                  'Siz VetUz ilovasining shaxsiy va aqlli VetAI yordamchisisiz. Veterinariya, chorvachilik, hayvonlar parvarishi, kasalliklar, parvarishlash qoidalari, dorilar, emlashlar va barcha chorva/ferma masalalarida professional maslahatlar berasiz. Har doim foydalanuvchining savollariga o\'zbek tilida, aniq, samimiy va juda batafsil javob bering. Agar foydalanuvchi hayvonning jiddiy kasalligi haqida so\'rasa, javob oxirida har doim "Aniq tashxis va davolash uchun yaqin oradagi veterinarga murojaat qilishingizni tavsiya qilamiz" deb eslatib o\'ting.'
            }
          ]
        }
      };

      request.write(jsonEncode(body));
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseBody) as Map<String, dynamic>;
        final candidates = json['candidates'] as List<dynamic>?;
        
        if (candidates != null && candidates.isNotEmpty) {
          final first = candidates.first as Map<String, dynamic>;
          final content = first['content'] as Map<String, dynamic>?;
          if (content != null) {
            final parts = content['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              final firstPart = parts.first as Map<String, dynamic>;
              return firstPart['text'] as String? ?? 'Xato: Javob matni bo\'sh.';
            }
          }
        }
        return 'Tizim xatosi: Sun\'iy intellekt javobini tahlil qilib bo\'lmadi.';
      } else {
        final responseBody = await response.transform(utf8.decoder).join();
        try {
          final errJson = jsonDecode(responseBody) as Map<String, dynamic>;
          final error = errJson['error'] as Map<String, dynamic>?;
          final message = error?['message'] as String?;
          if (message != null) {
            return 'API Xatosi: $message';
          }
        } catch (_) {}
        return 'Server xatosi: ${response.statusCode}';
      }
    } catch (e) {
      return 'Ulanish xatosi: Iltimos, internet aloqasini tekshiring. ($e)';
    } finally {
      client.close();
    }
  }
}
