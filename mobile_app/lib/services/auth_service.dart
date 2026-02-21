import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("${Constants.baseUrl}/login/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        await _storage.write(key: "access", value: data["access"]);
        await _storage.write(key: "refresh", value: data["refresh"]);
        await _storage.write(key: "username", value: username);
        
        return {"success": true, "message": "Login successful"};
      } else if (response.statusCode == 401) {
        return {"success": false, "message": "Invalid credentials. Please check your username and password."};
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = "Login failed. Please try again.";
        
        if (errorData.containsKey("detail")) {
          errorMessage = errorData["detail"];
        }
        
        return {"success": false, "message": errorMessage};
      }
    } catch (e) {
      return {"success": false, "message": "Network error. Please check your connection and try again."};
    }
  }

  static Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final url = Uri.parse("${Constants.baseUrl}/signup/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return {"success": true, "message": "Account created successfully. Please login."};
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        String errorMessage = "Invalid input data";
        
        if (errorData.containsKey("username")) {
          errorMessage = "Username already exists or is invalid";
        } else if (errorData.containsKey("email")) {
          errorMessage = "Email already exists or is invalid";
        } else if (errorData.containsKey("password")) {
          errorMessage = "Password is too weak or invalid";
        }
        
        return {"success": false, "message": errorMessage};
      } else {
        return {"success": false, "message": "Signup failed. Please try again."};
      }
    } catch (e) {
      return {"success": false, "message": "Network error. Please check your connection."};
    }
  }

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {"success": false, "message": "Google sign-in cancelled"};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Store Google user info
        await _storage.write(key: "google_user", value: jsonEncode({
          "email": user.email,
          "name": user.displayName,
          "photo_url": user.photoURL,
        }));
        
        // For now, simulate successful login
        // TODO: Integrate with backend for Google OAuth
        await _storage.write(key: "access", value: "mock_google_token");
        await _storage.write(key: "username", value: user.email ?? "google_user");
        
        return {"success": true, "message": "Google sign-in successful", "user": user};
      }
      
      return {"success": false, "message": "Google sign-in failed"};
    } catch (e) {
      return {"success": false, "message": "Google sign-in error: ${e.toString()}"};
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "access");
  }

  static Future<String?> getUsername() async {
    return await _storage.read(key: "username");
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
