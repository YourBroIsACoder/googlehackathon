// AI Service using Google Gemini API
// Configure your API key in lib/config/ai_config.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ai_config.dart';

class AIService {
  /// Analyze complaint description and suggest category, priority, and improvements
  static Future<Map<String, dynamic>?> analyzeComplaint({
    required String title,
    required String description,
    String? imageBase64,
  }) async {
    try {
      if (!AIConfig.isConfigured) {
        // Return mock analysis if API key not configured
        return _getMockAnalysis(title, description);
      }

      final prompt = _buildPrompt(title, description);
      
      final response = await http.post(
        Uri.parse('${AIConfig.baseUrl}?key=${AIConfig.geminiApiKey}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return _parseAIResponse(text);
      } else {
        print('AI API Error: ${response.statusCode} - ${response.body}');
        return _getMockAnalysis(title, description);
      }
    } catch (e) {
      print('AI Service Error: $e');
      return _getMockAnalysis(title, description);
    }
  }

  static String _buildPrompt(String title, String description) {
    return '''
Analyze this civic complaint and provide suggestions:

Title: $title
Description: $description

Please provide:
1. Suggested category (pothole, brokenStreetlight, garbage, waterLeakage, roadHazard, other)
2. Suggested priority (1=High, 2=Medium, 3=Low)
3. A brief improvement suggestion for the description
4. Any safety concerns

Format your response as JSON:
{
  "suggestedCategory": "category_name",
  "suggestedPriority": 1,
  "improvementSuggestion": "suggestion text",
  "safetyConcerns": "concerns text"
}
''';
  }

  static Map<String, dynamic> _parseAIResponse(String response) {
    try {
      // Try to extract JSON from the response
      final jsonMatch = RegExp(r'\{[^}]+\}').firstMatch(response);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!);
      }
    } catch (e) {
      print('Error parsing AI response: $e');
    }
    return _getMockAnalysis('', '');
  }

  static Map<String, dynamic> _getMockAnalysis(String title, String description) {
    // Mock AI analysis
    String category = 'other';
    int priority = 2;

    final lowerDesc = description.toLowerCase();
    if (lowerDesc.contains('pothole') || lowerDesc.contains('road')) {
      category = 'pothole';
      priority = 1;
    } else if (lowerDesc.contains('light') || lowerDesc.contains('streetlight')) {
      category = 'brokenStreetlight';
      priority = 2;
    } else if (lowerDesc.contains('garbage') || lowerDesc.contains('trash') || lowerDesc.contains('waste')) {
      category = 'garbage';
      priority = 2;
    } else if (lowerDesc.contains('water') || lowerDesc.contains('leak')) {
      category = 'waterLeakage';
      priority = 1;
    } else if (lowerDesc.contains('hazard') || lowerDesc.contains('danger')) {
      category = 'roadHazard';
      priority = 1;
    }

    return {
      'suggestedCategory': category,
      'suggestedPriority': priority,
      'improvementSuggestion': 'Consider adding more specific details about the location and impact.',
      'safetyConcerns': lowerDesc.contains('danger') || lowerDesc.contains('hazard') 
          ? 'This issue may pose safety risks. Please prioritize.' 
          : 'No immediate safety concerns detected.',
    };
  }
}




