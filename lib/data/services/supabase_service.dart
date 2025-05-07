import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/constants.dart';
import '../models/user_model.dart';

import 'package:top_ai_24_assignment/env.dart';

class SupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
    clientId: androidClientId

  );

  User? get currentUser => _supabaseClient.auth.currentUser;
  
  bool get isAuthenticated => currentUser != null;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
      
      return response.user;
    } catch (e) {
      rethrow;
    }
  }
  

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile() async {
    if (!isAuthenticated) return null;
    
    try {
      final response = await _supabaseClient
          .from(AppConstants.usersTable)
          .select()
          .eq('id', currentUser!.id)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      print('exception occured in getuserprofile');
      // If user doesn't exist, return a base model
      if (e is PostgrestException && e.code == 'PGRST116') {
        return UserModel(
          id: currentUser!.id,
          email: currentUser!.email ?? '',
          displayName: currentUser!.userMetadata?['full_name'],
          photoUrl: currentUser!.userMetadata?['avatar_url'],
        );
      }
      rethrow;
    }
  }

  Future<UserModel> createUserProfile(UserModel user) async {
    try {
      await _supabaseClient
          .from(AppConstants.usersTable)
          .insert(user.toJson());
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      await _supabaseClient
          .from(AppConstants.usersTable)
          .update(user.toJson())
          .eq('id', user.id);
      
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserProfile() async {
  if (!isAuthenticated) return;

  try {
    await _supabaseClient
        .from(AppConstants.usersTable)
        .update({
          'address': null,
          'phone_number': null,
          'age': null,
          'additional_info': null,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', currentUser!.id);
  } catch (e) {
    rethrow;
  }
}
}