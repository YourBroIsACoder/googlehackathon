/// AI Configuration for Gemini API
/// 
/// SETUP INSTRUCTIONS:
/// 1. Get your Gemini API key from Google AI Studio: https://makersuite.google.com/app/apikey
/// 2. Replace 'YOUR_GEMINI_API_KEY' below with your actual API key
/// 3. Keep this file secure and don't commit API keys to version control
/// 
/// FREE TIER LIMITS (Gemini 1.5 Flash):
/// - 15 requests per minute
/// - 1,500 requests per day  
/// - Rate limits are generous for development and small apps
/// - Gemini Flash is optimized for speed and efficiency
class AIConfig {
  /// Your Gemini API key
  /// Get it from: https://makersuite.google.com/app/apikey
  static const String geminiApiKey = 'AIzaSyDQ0H_-WAYwgB0EZ81l1GeAHWhpuvWcoP0';
  
  /// Check if API key is configured
  static bool get isConfigured => geminiApiKey != 'YOUR_GEMINI_API_KEY';
  
  /// Base URL for Gemini API (using Gemini Flash for free tier)
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
}