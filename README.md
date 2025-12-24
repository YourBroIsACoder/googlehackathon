# 🏙️ Civic Complaint Platform

A modern, AI-powered civic complaint management system built with Flutter, Firebase, and Gemini AI. Empowering communities to report and track civic issues efficiently.

![Civic Complaint Platform](https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&h=400&q=80)

## ✨ Features

### 🎯 **Core Functionality**
- **Real-time Complaint Management** - Submit, track, and resolve civic issues
- **AI-Powered Assistant** - Intelligent guidance using Google Gemini API
- **Firebase Integration** - Secure authentication and real-time database
- **Admin Dashboard** - Comprehensive management tools for authorities
- **Photo Uploads** - Visual evidence for complaint submissions
- **Priority System** - Automatic categorization (High/Medium/Low)

### 🎨 **User Experience**
- **Beautiful UI** - Professional civic-themed design with city backgrounds
- **Responsive Design** - Works seamlessly on web, mobile, and tablet
- **Real-time Updates** - Live status tracking and notifications
- **Intuitive Navigation** - Clean, user-friendly interface

### 🤖 **AI Assistant Features**
- **Conversational Interface** - Natural language interaction
- **Complaint Guidance** - Help with writing effective complaints
- **Category Selection** - Smart suggestions for complaint types
- **Process Information** - Explains how the system works
- **Priority Assessment** - Helps determine urgency levels

## 🚀 Live Demo

**Production URL**: [https://civic-complaint-platform-nhryt1tw0-thepipbuzz010-6335s-projects.vercel.app](https://civic-complaint-platform-nhryt1tw0-thepipbuzz010-6335s-projects.vercel.app)

### Test Accounts
- **Citizen**: Register with any email
- **Admin**: Contact administrator for admin access

## 🛠️ Tech Stack

- **Frontend**: Flutter (Web/Mobile)
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **AI**: Google Gemini API
- **Deployment**: Vercel
- **State Management**: Provider
- **UI**: Material Design 3

## 📱 Supported Platforms

- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 11+)
- ✅ **PWA** (Progressive Web App)

## 🏗️ Project Structure

```
lib/
├── config/           # Configuration files
│   ├── ai_config.dart
│   ├── firebase_config.dart
│   └── service_locator.dart
├── models/           # Data models
├── providers/        # State management
├── screens/          # UI screens
│   ├── auth/        # Authentication screens
│   ├── citizen/     # Citizen features
│   └── admin/       # Admin dashboard
├── services/         # Business logic
│   ├── ai_chat_service.dart
│   ├── auth_service.dart
│   ├── complaint_service.dart
│   └── storage_service.dart
└── widgets/          # Reusable components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Firebase account
- Google AI Studio account (for Gemini API)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/civic-complaint-platform.git
   cd civic-complaint-platform
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project
   - Add web app configuration
   - Update `lib/config/firebase_config.dart`
   - Add `google-services.json` for Android (if needed)

4. **Configure AI Assistant**
   - Get Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Update `lib/config/ai_config.dart`

5. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   ```

## 🌐 Deployment

### Vercel Deployment

1. **Build for web**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Vercel**
   ```bash
   # Install Vercel CLI
   npm install -g vercel
   
   # Deploy
   vercel --prod
   ```

3. **Or use deployment script**
   ```bash
   # Windows
   deploy-static.bat
   
   # Mac/Linux
   ./deploy.sh
   ```

## 🔧 Configuration

### Environment Variables

Create these in your deployment environment:

- `FIREBASE_API_KEY` - Firebase API key
- `FIREBASE_PROJECT_ID` - Firebase project ID
- `GEMINI_API_KEY` - Google Gemini API key

### Firebase Setup

1. **Authentication**
   - Enable Email/Password authentication
   - Configure authorized domains

2. **Firestore Database**
   - Create database in test mode
   - Deploy security rules from `firestore.rules`

3. **Storage**
   - Enable Firebase Storage for image uploads

## 📊 Features Overview

### For Citizens
- 📝 **Submit Complaints** - Report civic issues with photos and location
- 📱 **Track Status** - Real-time updates on complaint progress
- 🤖 **AI Assistance** - Get help with complaint writing and categorization
- 🏆 **Reward Points** - Earn points for active civic participation

### For Administrators
- 📋 **Dashboard** - Overview of all complaints and statistics
- ⚡ **Quick Actions** - Update status, assign priority, add comments
- 📈 **Analytics** - Track resolution times and complaint trends
- 👥 **User Management** - Manage citizen accounts and permissions

### AI Assistant Capabilities
- 💬 **Natural Conversation** - Friendly, helpful responses
- 📝 **Complaint Guidance** - Help writing effective complaints
- 🏷️ **Category Selection** - Smart suggestions for complaint types
- ⚡ **Priority Assessment** - Help determine urgency levels
- 📚 **Process Information** - Explain how the system works

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 🙏 Acknowledgments

- **Flutter Team** - Amazing cross-platform framework
- **Firebase** - Reliable backend services
- **Google AI** - Powerful Gemini API
- **Unsplash** - Beautiful civic imagery
- **Community** - For feedback and contributions

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/civic-complaint-platform/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/civic-complaint-platform/discussions)
- **Email**: support@civicplatform.com

## 🗺️ Roadmap

- [ ] **Mobile Apps** - Native Android and iOS apps
- [ ] **Push Notifications** - Real-time complaint updates
- [ ] **Geolocation** - Automatic location detection
- [ ] **Multi-language** - Support for multiple languages
- [ ] **Analytics Dashboard** - Advanced reporting and insights
- [ ] **API Integration** - Connect with government systems
- [ ] **Offline Support** - Work without internet connection

---

**Building Better Communities Together** 🏙️

Made with ❤️ for civic engagement and community improvement.