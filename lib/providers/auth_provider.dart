import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  bool _isInitialized = false;

  Future<void> login(String username, String password) async {
    final auth = AuthModel(username: username, password: password);
    
    if (auth.isValidCredentials()) {
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _isInitialized = true;
    notifyListeners();
  }
} 