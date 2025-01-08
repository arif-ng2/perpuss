import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;

  AuthProvider() {
    checkAuthStatus();
  }

  Future<bool> login(String username, String password) async {
    try {
      // Simulasi login sederhana
      if (username == 'admin' && password == 'admin123') {
        _isAuthenticated = true;
        _username = username;
        
        // Simpan status login dan username
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('username', username);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isAuthenticated = false;
      _username = null;
      
      // Hapus status login dan username
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isAuthenticated');
      await prefs.remove('username');
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      _username = prefs.getString('username');
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
  }
} 