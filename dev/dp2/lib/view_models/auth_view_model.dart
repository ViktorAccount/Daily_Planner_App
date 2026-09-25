import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository//auth_repository.dart';

// AuthViewModel uses this repository to interact with Firebase Authentication.


class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  
  
  //
  //
  // Sign up
  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _authRepository.signUpWithEmailPassword(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Sign up failed: $e');
    }
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _authRepository.signInWithEmailPassword(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Sign in failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    notifyListeners();
  }

  // Get current user
  void getCurrentUser() {
    _user = _authRepository.getCurrentUser();
    notifyListeners();
  }
}
