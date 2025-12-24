import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/ai_config.dart';

class AIChatService {
  /// Send a message to the AI assistant and get a response
  static Future<String> sendMessage({
    required String message,
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      if (!AIConfig.isConfigured) {
        // Return mock response if API key not configured
        return _getMockResponse(message);
      }

      final prompt = _buildChatPrompt(message, conversationHistory);
      
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
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if response has the expected structure
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text.trim();
        } else {
          debugPrint('AI API Response structure error: $data');
          return _getMockResponse(message);
        }
      } else {
        debugPrint('AI API Error: ${response.statusCode} - ${response.body}');
        return _getMockResponse(message);
      }
    } catch (e) {
      debugPrint('AI Chat Service Error: $e');
      return _getMockResponse(message);
    }
  }

  static String _buildChatPrompt(String message, List<Map<String, String>> history) {
    final systemPrompt = '''
You are a friendly and helpful AI assistant for the Civic Complaint Platform. You're here to help citizens with civic issues, but you're also conversational and can respond to greetings and general questions.

**Your Personality:**
- Friendly, approachable, and conversational
- Always respond to greetings like "hi", "hello", "how are you" warmly
- Helpful and encouraging about civic participation
- Use a casual, supportive tone

**When users ask about civic issues, help them with:**
1. **Complaint Guidance**: Writing effective complaints and choosing categories
2. **Process Information**: How the complaint system works and timelines
3. **Category Selection**: Pothole, streetlight, garbage, water leakage, road hazard, other
4. **Priority Assessment**: High/Medium/Low priority based on safety and impact
5. **General Civic Help**: Community engagement and civic responsibilities

**Available Complaint Categories:**
- **Pothole**: Road damage, cracks, holes
- **Broken Streetlight**: Non-functioning lighting  
- **Garbage**: Waste issues, overflowing bins
- **Water Leakage**: Pipe problems, drainage
- **Road Hazard**: Traffic safety issues
- **Other**: Any civic issue not listed

**Priority Levels:**
- **High**: Safety hazards, urgent failures, health risks
- **Medium**: Quality of life issues, moderate problems  
- **Low**: Minor aesthetic issues, non-urgent maintenance

**Platform Features:**
- Real-time complaint tracking with status updates
- Photo attachments and GPS location
- Reward points for active citizens
- Admin dashboard for authorities

**Response Style:**
- Be warm and conversational
- Respond to all messages, even casual greetings
- For civic questions: provide specific, actionable advice
- Use emojis appropriately to be friendly
- Keep responses helpful but not overly long
- Encourage civic participation when relevant

**Current Conversation:**''';

    String conversationContext = '';
    for (final entry in history.take(10)) { // Last 10 messages for context
      conversationContext += '\nUser: ${entry['user']}\nAssistant: ${entry['assistant']}';
    }

    return '''$systemPrompt
$conversationContext

User: $message
Assistant:''';
  }

  static String _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Handle greetings and casual messages
    if (lowerMessage.contains('hi') || lowerMessage.contains('hello') || 
        lowerMessage.contains('hey') || lowerMessage == 'h') {
      return '''👋 **Hi there!**

Great to see you! I'm your civic assistant, here to help with any community issues or questions you might have.

I can help you with:
• **Reporting civic problems** (potholes, streetlights, etc.)
• **Understanding the complaint process**
• **Choosing the right category** for your issue
• **Writing effective complaints**

What's on your mind today? Feel free to ask me anything! 😊''';
    }
    
    if (lowerMessage.contains('how are you') || lowerMessage.contains('how r u')) {
      return '''😊 **I'm doing great, thanks for asking!**

I'm here and ready to help you with any civic issues or questions. Whether you need to report a problem in your community or just want to learn about how the system works, I'm here for you!

What can I help you with today?''';
    }
    
    if (lowerMessage.contains('thank') || lowerMessage.contains('thanks')) {
      return '''🙏 **You're very welcome!**

Happy to help! If you have any other questions about civic complaints or community issues, just let me know. I'm always here to assist! 😊''';
    }
    
    // Complaint-related responses
    if (lowerMessage.contains('pothole') || lowerMessage.contains('road')) {
      return '''🛣️ **Pothole Report Guidance**

For effective pothole reports, include:
• **Exact location** (street name, nearest intersection)
• **Size description** (small crack, large hole, etc.)
• **Traffic impact** (lane blocking, vehicle damage risk)
• **Photo** if possible

**Priority**: Usually High if it's blocking traffic or causing vehicle damage, Medium for smaller potholes.

Would you like help writing your pothole complaint?''';
    }
    
    if (lowerMessage.contains('streetlight') || lowerMessage.contains('light')) {
      return '''💡 **Streetlight Issue Guidance**

For streetlight reports, include:
• **Specific location** (pole number if visible, nearby landmarks)
• **Problem type** (completely out, flickering, dim)
• **Safety impact** (dark intersection, pedestrian area)
• **Duration** (how long it's been broken)

**Priority**: High for busy intersections or pedestrian areas, Medium for residential streets.

Need help describing your streetlight issue?''';
    }
    
    if (lowerMessage.contains('garbage') || lowerMessage.contains('trash') || lowerMessage.contains('waste')) {
      return '''🗑️ **Garbage Issue Guidance**

For waste-related complaints, include:
• **Location details** (address, landmark)
• **Problem type** (overflowing bins, illegal dumping, missed collection)
• **Health/smell concerns**
• **Duration** (how long it's been an issue)

**Priority**: High if it's a health hazard, Medium for regular overflow issues.

What specific garbage issue are you reporting?''';
    }
    
    if (lowerMessage.contains('water') || lowerMessage.contains('leak')) {
      return '''💧 **Water Issue Guidance**

For water-related problems, include:
• **Exact location** (address, meter number if visible)
• **Problem severity** (small drip, major burst, flooding)
• **Water waste amount** (estimate if possible)
• **Property damage risk**

**Priority**: High for major leaks or flooding, Medium for minor leaks.

Describe your water issue and I'll help you report it effectively!''';
    }
    
    if (lowerMessage.contains('category') || lowerMessage.contains('type')) {
      return '''📋 **Complaint Categories**

Choose the best category for your issue:

🛣️ **Pothole** - Road damage, cracks, holes
💡 **Broken Streetlight** - Non-functioning lighting
🗑️ **Garbage** - Waste issues, overflowing bins
💧 **Water Leakage** - Pipe problems, drainage
⚠️ **Road Hazard** - Traffic safety issues
📝 **Other** - Any civic issue not listed above

What type of issue are you experiencing? I can help you choose the right category!''';
    }
    
    if (lowerMessage.contains('priority') || lowerMessage.contains('urgent')) {
      return '''⚡ **Priority Levels**

**🔴 High Priority (1)**
- Immediate safety hazards
- Major infrastructure failures
- Health risks or emergencies

**🟡 Medium Priority (2)**
- Quality of life issues
- Moderate infrastructure problems
- Non-emergency but important issues

**🟢 Low Priority (3)**
- Minor aesthetic issues
- Non-urgent maintenance
- Cosmetic improvements

Describe your issue and I'll help determine the appropriate priority level!''';
    }
    
    if (lowerMessage.contains('how') && (lowerMessage.contains('work') || lowerMessage.contains('process'))) {
      return '''🔄 **How the Complaint Process Works**

1. **Submit** your complaint with details and photos
2. **Automatic categorization** and priority assignment
3. **Admin review** by local authorities
4. **Status updates**: Open → In Progress → Resolved
5. **Earn points** for active civic participation!

**Timeline**: Most issues are reviewed within 24-48 hours. Resolution time varies by priority and complexity.

**Tracking**: You can track your complaint status in real-time through the app.

Ready to submit a complaint? I'm here to help!''';
    }
    
    if (lowerMessage.contains('points') || lowerMessage.contains('reward')) {
      return '''🎉 **Reward System**

Earn points for civic participation:
• **First complaint**: Bonus points!
• **Each complaint**: Regular points
• **Complaint resolved**: Additional points

Points encourage community engagement and recognize active citizens who help improve their neighborhoods.

Your civic participation makes a difference! 🏆''';
    }
    
    // General helpful response
    return '''👋 **Hello! I'm your Civic Assistant!**

I'm here to chat and help you with civic issues! I can assist with:

🛣️ **Reporting Problems**: Potholes, streetlights, garbage, water leaks
📋 **Choosing Categories**: Find the right type for your complaint  
⚡ **Priority Help**: Understand urgency levels
📝 **Writing Tips**: Make complaints more effective
🔄 **Process Info**: Learn how everything works

**Just ask me anything like:**
• "Hi, how are you?" (I love to chat! 😊)
• "Help me report a pothole"
• "What category for broken streetlight?"
• "How does the complaint process work?"

What would you like to talk about? 🏙️''';
  }

  /// Check if API key is configured
  static bool get isConfigured => AIConfig.isConfigured;
}