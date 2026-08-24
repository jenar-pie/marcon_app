import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // BACKGROUND
              Positioned.fill(child: Container(color: const Color(0xFFF4F7FA))),

              // KIRI ATAS — kiriatas.svg
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
              Positioned(
                top: -height * 0.06,
                right: -width * 0.20,
                width: width * 0.65,
                height: width * 0.70,
                child: SvgPicture.asset(
                  'lib/asset/kananatas.svg',
                  fit: BoxFit.fill,
                  alignment: Alignment.topRight,
                ),
              ),

              // BAWAH — bawah.svg
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

              // LOGIN CONTENT & FORM
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // LOGO
                        SvgPicture.asset(
                          'lib/asset/marconlogo.svg',
                          width: width * 0.55,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 16),

                        // TAGLINE / TITLE (Plus Jakarta Sans)
                        Text(
                          'Selamat Datang di Marcon',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: (width * 0.052).clamp(18.0, 26.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Visibilitas lebih baik, hasil lebih besar',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: (width * 0.038).clamp(13.0, 18.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // FORM INPUTS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // USERNAME LABEL
                            Text(
                              'Username',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6B2B1B),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // USERNAME FIELD
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE09B),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _usernameController,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A2511),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'email@perusahaan.com',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFA88B52),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // PASSWORD LABEL
                            Text(
                              'Password',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6B2B1B),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // PASSWORD FIELD
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE09B),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A2511),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Password User',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFA88B52),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF6B2B1B),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // REMEMBER ME & FORGOT PASSWORD ROW
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // INGAT SAYA
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFD4B07B),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: _rememberMe
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Color(0xFFFE5D00),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ingat saya',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6B2B1B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // LUPA PASSWORD?
                                GestureDetector(
                                  onTap: () {
                                    // Action for forgot password
                                  },
                                  child: Text(
                                    'Lupa Password?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFE5D00),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // LOGIN BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFE5D00),
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shadowColor: const Color(0xFFFE5D00)
                                      .withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
