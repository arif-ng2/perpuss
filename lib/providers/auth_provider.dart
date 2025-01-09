import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _role;
  static const String _usersKey = 'users';
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';

  // Kredensial admin tetap
  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin123';

  String? get username => _username;
  String? get role => _role;
  bool get isAdmin => _role == 'admin';

  Future<bool> register(String username, String password) async {
    if (username == adminUsername) {
      throw Exception('Username tidak tersedia');
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    final users = usersJson != null 
        ? Map<String, dynamic>.from(json.decode(usersJson)) 
        : <String, dynamic>{};

    // Cek apakah username sudah ada
    if (users.containsKey(username)) {
      return false;
    }

    // Simpan user baru
    users[username] = {
      'password': password,
      'role': 'user',
      'joinDate': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_usersKey, json.encode(users));
    return true;
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username dan password harus diisi');
    }

    // Cek kredensial admin
    if (username == adminUsername) {
      if (password == adminPassword) {
        await _setLoggedInUser(username, 'admin');
        return;
      }
      throw Exception('Password salah');
    }

    // Cek kredensial user biasa
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) {
      throw Exception('Username tidak ditemukan');
    }

    final users = Map<String, dynamic>.from(json.decode(usersJson));
    final user = users[username];

    if (user == null) {
      throw Exception('Username tidak ditemukan');
    }

    if (user['password'] != password) {
      throw Exception('Password salah');
    }

    await _setLoggedInUser(username, user['role']);
  }

  Future<void> _setLoggedInUser(String username, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_roleKey, role);
    
    _username = username;
    _role = role;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_roleKey);
    _username = null;
    _role = null;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString(_usernameKey);
    _role = prefs.getString(_roleKey);
    notifyListeners();
  }

  // Mendapatkan informasi user
  Future<Map<String, dynamic>?> getUserInfo(String username) async {
    if (username == adminUsername) {
      return {
        'username': adminUsername,
        'role': 'admin',
        'joinDate': '2024-01-01T00:00:00.000',
      };
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) return null;

    final users = Map<String, dynamic>.from(json.decode(usersJson));
    return users[username];
  }
} 