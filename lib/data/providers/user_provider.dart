import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/supabase_service.dart';

class UserProvider extends ChangeNotifier {
  final SupabaseService _supabaseService;
  
  bool _isLoading = false;
  String? _error;
  UserModel? _userProfile;
  
  UserProvider(this._supabaseService) {
    _loadUserProfile();
  }
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get userProfile => _userProfile;
  
  Future<void> _loadUserProfile() async {
    if (!_supabaseService.isAuthenticated) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      _userProfile = await _supabaseService.getUserProfile();
      print("profile got from supabase service");
      print(_userProfile?.address);
      
      // agar user nhi hai to bana do
      if (_userProfile != null && _supabaseService.currentUser != null) {
        if (_userProfile!.createdAt == null) {
          await _supabaseService.createUserProfile(_userProfile!);
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Update user profile fields
  Future<bool> updateUserProfile({
    String? address,
    String? phoneNumber,
    int? age,
    String? additionalInfo,
  }) async {
    if (_userProfile == null) return false;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Update local model
      _userProfile = _userProfile!.copyWith(
        address: address ?? _userProfile!.address,
        phoneNumber: phoneNumber ?? _userProfile!.phoneNumber,
        age: age ?? _userProfile!.age,
        additionalInfo: additionalInfo ?? _userProfile!.additionalInfo,
        updatedAt: DateTime.now(),
      );
      
      await _supabaseService.updateUserProfile(_userProfile!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteUserProfile() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _supabaseService.deleteUserProfile();
      
      // data reset kro, but basic info rakho
      if (_userProfile != null) {
        _userProfile = UserModel(
          id: _userProfile!.id,
          email: _userProfile!.email,
          displayName: _userProfile!.displayName,
          photoUrl: _userProfile!.photoUrl,
        );
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<void> refreshUserProfile() async {
    await _loadUserProfile();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}