import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goToLogin,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                // BACKGROUND
                Positioned.fill(child: Container(color: Colors.white)),

                // KIRI ATAS — kiriatas.svg
                // viewBox 152×135: ring orange + solid circle kanan atas SVG
                // Posisi: kiri atas layar, sebagian terpotong kiri & atas
                Positioned(
                  top: -height * 0.04,
                  left: -width * 0.18,
                  width: width * 0.50,
                  height: width * 0.37,
                  child: SvgPicture.asset(
                    'lib/asset/kiriatas.svg',
                    fit: BoxFit.fill,
                  ),
                ),

                // KANAN ATAS — kananatas.svg
                // viewBox 238×275: blob navy + blob orange gradient + ring navy
                // Posisi: kanan atas layar, sebagian terpotong kanan & atas
                Positioned(
                  top: -height * 0.06,
                  right: -width * 0.20,
                  width: width * 0.70,
                  height: width * 0.80,
                  child: SvgPicture.asset(
                    'lib/asset/kananatas.svg',
                    fit: BoxFit.fill,
                    alignment: Alignment.topRight,
                  ),
                ),

                // BAWAH — bawah.svg
                // viewBox 399×212: semua pills diagonal dalam 1 file
                // Posisi: kiri bawah layar, sebagian terpotong bawah & kiri
                Positioned(
                  bottom: -height * 0.02,
                  left: -width * 0.60,
                  width: width * 1.20,
                  height: width * 0.45,
                  child: SvgPicture.asset(
                    'lib/asset/bawah.svg',
                    fit: BoxFit.fill,
                    alignment: Alignment.bottomLeft,
                  ),
                ),

                // LOGO + TAGLINE (center)
                Positioned.fill(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo MARCON
                          SvgPicture.asset(
                            'lib/asset/marconlogo.svg',
                            width: width * 0.62,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: height * 0.028),

                          // Tagline
                          Text(
                            'Marketing Control & Monitoring',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: (width * 0.048).clamp(16.0, 24.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D2B45),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // VERSI (bottom center, di atas dekorasi)
                Positioned(
                  bottom: height * 0.048,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      'Versi 1.0.0',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: (width * 0.038).clamp(13.0, 18.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D2B45),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
