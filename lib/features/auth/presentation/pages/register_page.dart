import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lypsis_siakad/core.dart';
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lypsis_siakad/features/auth/presentation/pages/login_page.dart';
// Assuming these dashboard pages will be created
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/admin_dashboard_page.dart';
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/dosen_dashboard_page.dart';
// import 'package:lypsis_siakad/features/dashboard/presentation/pages/mahasiswa_dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _nimController;
  late final TextEditingController _nidnController;

  String _role = 'mahasiswa';
  final List<Map<String, String>> _roleOptions = [
    {'value': 'mahasiswa', 'label': 'Mahasiswa'},
    {'value': 'dosen', 'label': 'Dosen'},
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nimController = TextEditingController();
    _nidnController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nimController.dispose();
    _nidnController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        email: _emailController.text,
        password: _passwordController.text,
        nama: _namaController.text,
        role: _role,
        nim: _role == 'mahasiswa' ? _nimController.text : null,
        nidn: _role == 'dosen' ? _nidnController.text : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => back(),
        ),
        title: Text(
          'Registrasi',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showLoading();
          } else {
            hideLoading();
            if (state is AuthAuthenticated) {
              ss("Registrasi berhasil!");
              offAll(LoginPage());
            } else if (state is AuthFailure) {
              se(state.message);
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: primaryColor.withAlpha(26), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Icon(Icons.person_add, size: 60, color: primaryColor),
                      const SizedBox(height: 16),
                      Text(
                        'Buat Akun Baru',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daftar untuk mengakses sistem akademik',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QTextField(
                        label: "Nama Lengkap",
                        controller: _namaController,
                        validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
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
                      QDropdownField(
                        label: "Role",
                        value: _role,
                        items: _roleOptions,
                        onChanged: (value, label) {
                          setState(() {
                            _role = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_role == 'mahasiswa')
                        QTextField(
                          label: "NIM",
                          controller: _nimController,
                          validator: (value) => value == null || value.isEmpty ? 'NIM wajib diisi' : null,
                          onChanged: (value) {},
                        ),
                      if (_role == 'dosen')
                        QTextField(
                          label: "NIDN",
                          controller: _nidnController,
                          validator: (value) => value == null || value.isEmpty ? 'NIDN wajib diisi' : null,
                          onChanged: (value) {},
                        ),
                      if (_role == 'mahasiswa' || _role == 'dosen') const SizedBox(height: 20),
                      QTextField(
                        label: "Password",
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) => value == null || value.isEmpty ? 'Password tidak boleh kosong' : null,
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                      QTextField(
                        label: "Konfirmasi Password",
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password tidak boleh kosong';
                          }
                          if (value != _passwordController.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return QButton(label: "Daftar", onPressed: state is AuthLoading ? null : _handleRegister);
                        },
                      ),
                      const SizedBox(height: 24),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey[600])),
                          TextButton(
                            onPressed: () => back(),
                            child: Text(
                              'Masuk Sekarang',
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Terms and Conditions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    'Dengan mendaftar, Anda menyetujui syarat dan ketentuan yang berlaku di sistem akademik ini.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
