import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _nama = '';
  String _role = 'mahasiswa';
  String _nim = '';
  String _nidn = '';
  bool _loading = false;

  final List<Map<String, String>> _roleOptions = [
    {'value': 'mahasiswa', 'label': 'Mahasiswa'},
    {'value': 'dosen', 'label': 'Dosen'},
  ];

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_password != _confirmPassword) {
      se("Password dan konfirmasi password tidak sama");
      return;
    }

    if (_role == 'mahasiswa' && _nim.isEmpty) {
      se("NIM wajib diisi untuk mahasiswa");
      return;
    }

    if (_role == 'dosen' && _nidn.isEmpty) {
      se("NIDN wajib diisi untuk dosen");
      return;
    }

    _loading = true;
    setState(() {});

    try {
      showLoading();
      
      final user = await AuthService().signUp(
        email: _email,
        password: _password,
        nama: _nama,
        role: _role,
        nim: _role == 'mahasiswa' ? _nim : null,
        nidn: _role == 'dosen' ? _nidn : null,
      );
      
      if (user != null) {
        ss("Registrasi berhasil! Silakan login.");
        await to(const LoginView());
      } else {
        se("Registrasi gagal");
      }
    } catch (e) {
      se("Terjadi kesalahan: ${e.toString()}");
    } finally {
      hideLoading();
      _loading = false;
      setState(() {});
    }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () => back(),
        ),
        title: Text(
          'Registrasi',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 60,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Buat Akun Baru',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daftar untuk mengakses sistem akademik',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
                      value: _nama,
                      onChanged: (value) {
                        _nama = value;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    QTextField(
                      label: "Email",
                      value: _email,
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    QDropdownField(
                      label: "Role",
                      value: _role,
                      items: _roleOptions,
                      onChanged: (value, label) {
                        _role = value;
                        setState(() {});
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Conditional field based on role
                    if (_role == 'mahasiswa')
                      QTextField(
                        label: "NIM",
                        value: _nim,
                        onChanged: (value) {
                          _nim = value;
                        },
                      ),
                    
                    if (_role == 'dosen')
                      QTextField(
                        label: "NIDN",
                        value: _nidn,
                        onChanged: (value) {
                          _nidn = value;
                        },
                      ),
                    
                    if (_role == 'mahasiswa' || _role == 'dosen')
                      const SizedBox(height: 20),
                    
                    QTextField(
                      label: "Password",
                      value: _password,
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    QTextField(
                      label: "Konfirmasi Password",
                      value: _confirmPassword,
                      onChanged: (value) {
                        _confirmPassword = value;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    QButton(
                      label: "Daftar",
                      onPressed: _handleRegister,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () => back(),
                          child: Text(
                            'Masuk Sekarang',
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
              
              const SizedBox(height: 40),
              
              // Terms and Conditions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                  ),
                ),
                child: Text(
                  'Dengan mendaftar, Anda menyetujui syarat dan ketentuan yang berlaku di sistem akademik ini.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
