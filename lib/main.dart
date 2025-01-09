import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/loan_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin/admin_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProxyProvider<BookProvider, LoanProvider>(
          create: (context) => LoanProvider(context.read<BookProvider>()),
          update: (context, bookProvider, previous) =>
              LoanProvider(bookProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Perpustakaan Digital',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Cek status login
        if (authProvider.username == null) {
          return const LoginScreen();
        }

        // Arahkan ke halaman sesuai role
        if (authProvider.isAdmin) {
          return const AdminHomeScreen();
        }

        return const HomeScreen();
      },
    );
  }
}