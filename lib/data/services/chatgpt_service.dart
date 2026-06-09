import 'package:dio/dio.dart';

class ChatGptService {
   final Dio _dio;

  ChatGptService(String apiKey)
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.openai.com/v1',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
          ),
        );

  Future<String> getFarmingCommodityInfo(String query) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-5.4',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant specialized in farming commodities, agricultural products, market prices, and farming practices. Provide concise and informative responses about farming-related queries.',
            },
            {'role': 'user', 'content': query},
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        },
      );

      if (response.statusCode == 200) {
        final choices = response.data['choices'] as List;
        if (choices.isNotEmpty) {
          return choices[0]['message']['content'].toString().trim();
        }
      }

      return 'Sorry, I could not process your request at this time.';
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return 'API key is invalid. Please configure your OpenAI API key.';
      } else if (e.response?.statusCode == 429) {
        return 'Rate limit exceeded. Please try again later.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}
