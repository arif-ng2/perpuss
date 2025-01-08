import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = prefs.getString(_currentUserKey);
    if (currentUser != null) {
      _username = currentUser;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil daftar user yang sudah ada
    final usersJson = prefs.getString(_usersKey);
    final users = usersJson != null ? Map<String, String>.from(json.decode(usersJson)) : <String, String>{};
    
    // Cek apakah username sudah digunakan
    if (users.containsKey(username)) {
      return false;
    }
    
    // Tambahkan user baru
    users[username] = password;
    await prefs.setString(_usersKey, json.encode(users));
    
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil daftar user
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return false;
    
    final users = Map<String, String>.from(json.decode(usersJson));
    
    // Cek kredensial
    if (users[username] == password) {
      _username = username;
      _isLoggedIn = true;
      await prefs.setString(_currentUserKey, username);
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    _username = null;
    _isLoggedIn = false;
    notifyListeners();
  }
} 