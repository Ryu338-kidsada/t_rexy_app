import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
 
enum AuthStatus { idle, loading, success, error }
 
/// จัดการ state ของการล็อกอิน/สมัครสมาชิก
/// หน้า UI (Login/Signup) จะ "ฟัง" ตัวนี้ผ่าน Provider แล้วอัปเดตหน้าจอเอง
/// เช่น ตอน status เป็น loading ให้โชว์ spinner ในปุ่ม, error ให้โชว์ข้อความสีแดง
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
 
  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();
 
  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
 
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  User? get currentUser => _authRepository.currentUser;
 
  /// คืนค่า true = สำเร็จ, false = ไม่สำเร็จ (ดู errorMessage ต่อได้)
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading();
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    }
  }
 
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading();
    try {
      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      _setSuccess();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    }
  }
 
  Future<void> signOut() async {
    await _authRepository.signOut();
    _status = AuthStatus.idle;
    notifyListeners();
  }
 
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }
 
  void _setSuccess() {
    _status = AuthStatus.success;
    _errorMessage = null;
    notifyListeners();
  }
 
  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}