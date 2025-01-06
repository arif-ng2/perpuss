import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/loan_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = BookProvider();
            provider.loadBooks();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = LoanProvider();
            provider.loadLoans();
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Digital Perpus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return FutureBuilder(
              future: auth.checkAuthStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
              },
            );
          },
        ),
      ),
    );
  }
}