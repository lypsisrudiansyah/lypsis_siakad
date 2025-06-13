import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reusekit/core.dart'; // Assuming primaryColor and navigation (to, offAll) are here
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lypsis_siakad/views/login_view.dart'; // Fallback
import 'package:lypsis_siakad/views/admin_dashboard_view.dart';
import 'package:lypsis_siakad/views/dosen_dashboard_view.dart';
import 'package:lypsis_siakad/views/mahasiswa_dashboard_view.dart';
import 'package:lypsis_siakad/injection_container.dart'; // For GetIt instance

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Dispatch event to check auth status after animations have a chance to start
    Future.delayed(const Duration(milliseconds: 500), () {
       BlocProvider.of<AuthBloc>(context).add(AuthCheckStatusRequested());
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.8, curve: Curves.elasticOut)),
    );

    _animationController.forward();
  }

  void _navigateBasedOnRole(String role) {
    // Ensure navigation happens after build if called from BlocListener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (role.toLowerCase()) {
        case 'admin':
          offAll(const AdminDashboardView());
          break;
        case 'dosen':
          offAll(const DosenDashboardView());
          break;
        case 'mahasiswa':
          offAll(const MahasiswaDashboardView());
          break;
        default:
          offAll(const LoginView());
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Assuming primaryColor is globally available
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _navigateBasedOnRole(state.user.role);
          } else if (state is AuthUnauthenticated || state is AuthFailure) {
             // Delay navigation to allow splash animations to be seen
            Future.delayed(const Duration(milliseconds: 1500), () { // Adjusted delay
              offAll(const LoginView());
            });
          } else if (state is AuthNavigationToLogin) {
             Future.delayed(const Duration(milliseconds: 1500), () {
              offAll(const LoginView());
            });
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(25),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Icon(Icons.school, size: 60, color: primaryColor),
                      ),
                      const SizedBox(height: 30),
                      const Text('SIAKAD', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                      const SizedBox(height: 10),
                      Text('Sistem Informasi Akademik', style: TextStyle(fontSize: 16, color: Colors.white.withAlpha(204), fontWeight: FontWeight.w300)),
                      const SizedBox(height: 50),
                      SizedBox(width: 40, height: 40, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(178)), strokeWidth: 3)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}