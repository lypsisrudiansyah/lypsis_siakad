// ignore_for_file: all
// ignore_for_file: unused_import, dead_code
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  String _email = !kDebugMode ? '' : 'admin2@demo.com';
  String _password = !kDebugMode ? '' : '123456';
  bool _loading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _loading = true;
    if (mounted) setState(() {});

    try {
      showLoading();

      final user = await AuthService().signIn(_email, _password);

      hideLoading();

      if (user != null) {
        ss("Login berhasil!");

        // Navigate based on user role
        switch (user.role) {
          case 'admin':
            await offAll(const AdminDashboardView());
            break;
          case 'dosen':
            await offAll(const DosenDashboardView());
            break;
          case 'mahasiswa':
            await offAll(const MahasiswaDashboardView());
            break;
          default:
            se("Role tidak dikenali");
        }
      } else {
        se("Email atau password salah");
      }
    } catch (e) {
      se("Terjadi kesalahan: ${e.toString()}");
    }

    _loading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Header Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school,
                          size: 32,
                          color: primaryColor,
                        ),
                        Text(
                          'SIAKAD',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'Sistem Informasi Akademik',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Masuk ke Akun Anda',
                          style: TextStyle(
                            fontSize: fsXl,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        QTextField(
                          label: "Email",
                          value: _email,
                          onChanged: (value) {
                            _email = value;
                          },
                        ),

                        const SizedBox(height: 20),

                        QTextField(
                          label: "Password",
                          value: _password,
                          onChanged: (value) {
                            _password = value;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => to(const ForgotPasswordView()),
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        QButton(
                          label: "Masuk",
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 20),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () => to(const RegisterView()),
                              child: Text(
                                'Daftar Sekarang',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.flash_on,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Quick Login (Testing)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: QButton(
                              label: "Admin",
                              color: primaryColor,
                              onPressed: () {
                                _email = 'admin@demo.com';
                                _password = '123456';
                                setState(() {});
                                _handleLogin();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: QButton(
                              label: "Dosen",
                              color: successColor,
                              onPressed: () {
                                _email = 'dosen@demo.com';
                                _password = '123456';
                                setState(() {});
                                _handleLogin();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: QButton(
                              label: "Mahasiswa",
                              color: warningColor,
                              onPressed: () {
                                _email = 'mahasiswa@demo.com';
                                _password = '123456';
                                setState(() {});
                                _handleLogin();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// -----

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthUserEntiry?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Check if user exists in users table, if not create it
        await _ensureUserExists(response.user!);
        return await getUserProfile(response.user!.id);
      }
      return null;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }
  // ignore_for_file: all
}