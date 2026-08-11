import 'package:firebase_auth/firebase_auth.dart';
 
/// จัดการการติดต่อกับ Firebase Auth โดยตรง
/// แยกออกมาต่างหาก เพื่อให้ UI (หน้า Login/Signup) ไม่ต้องรู้จัก FirebaseAuth เลย
/// ถ้าจะเพิ่ม Google/Facebook login ทีหลัง แก้แค่ไฟล์นี้ไฟล์เดียว ไม่ต้องแตะ UI
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
 
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
 
  /// stream บอกสถานะล็อกอินแบบ real-time (เอาไว้เช็คว่า user ล็อกอินค้างอยู่ไหม)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
 
  User? get currentUser => _firebaseAuth.currentUser;
 
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }
 
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // บันทึกชื่อ user ไว้ใน Firebase Auth profile
      await credential.user?.updateDisplayName(displayName.trim());
      await credential.user?.reload();
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }
 
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
 
  /// แปล error code ของ Firebase ให้เป็นข้อความภาษาไทยที่ user อ่านเข้าใจ
  /// (ปกติ Firebase จะโยน error code ภาษาอังกฤษดิบๆ มา ไม่เหมาะเอาไปโชว์ตรงๆ)
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'user-disabled':
        return 'บัญชีนี้ถูกระงับการใช้งาน';
      case 'user-not-found':
        return 'ไม่พบบัญชีนี้ในระบบ';
      case 'wrong-password':
      case 'invalid-credential':
        return 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
      case 'email-already-in-use':
        return 'อีเมลนี้มีผู้ใช้งานแล้ว';
      case 'weak-password':
        return 'รหัสผ่านสั้นเกินไป (ต้องอย่างน้อย 6 ตัวอักษร)';
      case 'network-request-failed':
        return 'เชื่อมต่ออินเทอร์เน็ตไม่ได้ ลองใหม่อีกครั้ง';
      default:
        return 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง';
    }
  }
}
 
/// Exception ที่มีข้อความไทยพร้อมโชว์ให้ user เห็นได้เลย ไม่ต้องแปลซ้ำใน UI
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
 
  @override
  String toString() => message;
}