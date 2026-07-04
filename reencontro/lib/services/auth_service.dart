import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_models.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<String> _resolveEmail(String identifier) async {
    final trimmed = identifier.trim();
    if (trimmed.contains('@')) {
      return trimmed;
    }

    final normalizedPhone = trimmed.replaceAll(RegExp(r'[^0-9+]'), '');
    final snapshot = await _firestore
        .collection('volunteers')
        .where('phone', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Nenhum voluntário encontrado com este telefone.',
      );
    }

    return snapshot.docs.first.data()['email'] as String;
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    final email = await _resolveEmail(identifier);
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createVolunteer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final normalizedPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    await _firestore.collection('volunteers').doc(credential.user!.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'phone': normalizedPhone,
      'photoUrl':
          'https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&w=400&q=80',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendPasswordReset(String identifier) async {
    final email = await _resolveEmail(identifier);
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() => _auth.signOut();

  Stream<VolunteerProfile?> currentProfile() {
    final user = currentUser;
    if (user == null) {
      return const Stream<VolunteerProfile?>.empty();
    }

    return _firestore.collection('volunteers').doc(user.uid).snapshots().map((
      doc,
    ) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return VolunteerProfile.fromMap(doc.id, doc.data()!);
    });
  }
}
