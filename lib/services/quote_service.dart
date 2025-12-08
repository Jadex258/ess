import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String _apiUrl = 'https://zenquotes.io/api/random';

  static Future<Map<String, dynamic>> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final quoteData = data.first;
          return {
            'content': quoteData['q'] ?? '',
            'author': quoteData['a'] ?? 'Unknown',
          };
        } else {
          throw Exception('No quotes returned from API');
        }
      } else {
        throw Exception('Failed to load quote: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'content': 'The only way to do great work is to love what you do.',
        'author': 'Steve Jobs',
        'tags': ['work', 'motivation'],
        'html': '',
      };
    }
  }
}

// Then in your widget:
Future<Map<String, dynamic>> fetchRandomQuote() async {
  return await QuoteService.fetchRandomQuote();
}