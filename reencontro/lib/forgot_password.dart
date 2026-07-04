import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSending = true);
    try {
      await AuthService.instance.sendPasswordReset(_controller.text);
      if (!mounted) {
        return;
      }
      Navigator.pushNamed(
        context,
        '/recover-password',
        arguments: _controller.text.trim(),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível enviar o link: $error'),
          backgroundColor: const Color(0xFFBA1A1A),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esquecer senha')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            SizedBox(
              height: 220,
              child: Lottie.asset('assets/animations/forgot password.json'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Recuperar acesso',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Indique o email ou telefone associado à conta. Vamos enviar um link real de recuperação.',
              style: TextStyle(color: Color(0xFF424752), height: 1.45),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Email ou telefone',
                  prefixIcon: Icon(Icons.mark_email_read_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Preencha o contacto';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _sendReset,
              icon: const Icon(Icons.send_outlined),
              label: Text(
                _isSending ? 'A enviar...' : 'Enviar link',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar ao login'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFD7E2FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_reset, color: Color(0xFF003F87), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enviámos um link de redefinição. Abra o email associado e conclua a alteração da senha.',
                      style: TextStyle(
                        color: Color(0xFF003F87),
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (contact != null)
              Text(
                'Contacto usado: $contact',
                style: const TextStyle(
                  color: Color(0xFF424752),
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Se o link não chegar, confirme o email ou telefone e tente novamente.',
              style: TextStyle(color: Color(0xFF424752), height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              },
              child: const Text(
                'Voltar ao login',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _redirectTimer = Timer(const Duration(milliseconds: 2400), () async {
      if (!mounted) {
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacementNamed(
        context,
        user == null ? '/login' : '/home',
      );
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: Lottie.asset('assets/animations/Welcome.json'),
          ),
        ),
      ),
    );
  }
}
