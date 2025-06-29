import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lypsis_siakad/core.dart';
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
// Assuming these views will be created later
// import 'package:lypsis_siakad/features/auth/presentation/pages/forgot_password_page.dart';
// import 'package:lypsis_siakad/features/auth/presentation/pages/register_page.dart';
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/admin_dashboard_page.dart';
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/dosen_dashboard_page.dart';
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/mahasiswa_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController =
        TextEditingController(text: !kDebugMode ? '' : 'admin@demo.com');
    _passwordController =
        TextEditingController(text: !kDebugMode ? '' : '123456');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthSignInRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _quickLogin(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
    _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showLoading();
          } else if (state is AuthFailure) {
            hideLoading();
            se(state.message);
          } else if (state is AuthAuthenticated) {
            hideLoading();
            ss("Login berhasil!");
            // Navigate based on user role
            switch (state.user.role.toLowerCase()) {
              case 'admin':
                // offAll(const AdminDashboardPage());
                break;
              case 'dosen':
                // offAll(const DosenDashboardPage());
                break;
              case 'mahasiswa':
                // offAll(const MahasiswaDashboardPage());
                break;
              default:
                se("Role tidak dikenali: ${state.user.role}");
            }
          }
        },
        child: SafeArea(
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
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 20),
                          QTextField(
                            label: "Password",
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 12),
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // to(const ForgotPasswordPage())
                              },
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
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return QButton(
                                label: "Masuk",
                                onPressed:
                                    state is AuthLoading ? null : _handleLogin,
                              );
                            },
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
                                onPressed: () {
                                  // to(const RegisterPage())
                                },
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
                if (kDebugMode)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: _buildQuickLoginButtons(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginButtons() {
    return Container(
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
                  onPressed: () => _quickLogin('admin@demo.com', '123456'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QButton(
                  label: "Dosen",
                  color: successColor,
                  onPressed: () => _quickLogin('dosen@demo.com', '123456'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QButton(
                  label: "Mahasiswa",
                  color: warningColor,
                  onPressed: () => _quickLogin('mahasiswa@demo.com', '123456'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}