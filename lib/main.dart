import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/citizen/citizen_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'widgets/animated_intro.dart';
import 'config/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services (Firebase or mock based on configuration)
  try {
    await ServiceLocator.instance.initialize();
    
    if (ServiceLocator.instance.hasInitializationError) {
      debugPrint('Service initialization warning: ${ServiceLocator.instance.initializationError}');
    }
    
    if (ServiceLocator.instance.isUsingFirebase) {
      debugPrint('✅ Using Firebase services');
    } else {
      debugPrint('🔧 Using mock services for development');
    }
  } catch (e) {
    debugPrint('❌ Service initialization failed: $e');
    debugPrint('Continuing with mock services...');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Civic Complaint Platform',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1), // Indigo
            brightness: Brightness.light,
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF8B5CF6),
            tertiary: const Color(0xFFEC4899),
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
          ),
        ),
        home: const SplashWrapper(),
      ),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showIntro = true;

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return AnimatedIntroScreen(
        onComplete: () {
          setState(() {
            _showIntro = false;
          });
        },
      );
    }
    return const AuthWrapper();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        debugPrint('🔍 AuthWrapper - Loading: ${authProvider.isLoading}, Authenticated: ${authProvider.isAuthenticated}');
        
        if (authProvider.isLoading) {
          debugPrint('⏳ Showing loading screen');
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          final user = authProvider.user;
          debugPrint('✅ User authenticated: ${user?.email}, Admin: ${user?.isAdmin}');
          if (user != null && user.isAdmin) {
            debugPrint('🔧 Navigating to Admin Home');
            return const AdminHomeScreen();
          } else {
            debugPrint('👤 Navigating to Citizen Home');
            return const CitizenHomeScreen();
          }
        }

        debugPrint('🔐 Showing Login Screen');
        return const LoginScreen();
      },
    );
  }
}
