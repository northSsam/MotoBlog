// Halaman Login MotoBlog

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk input username
  final TextEditingController usernameController = TextEditingController();

  // Controller untuk input password
  final TextEditingController passwordController = TextEditingController();

  // Mengatur apakah password ditampilkan
  bool isPasswordVisible = false;

  // Proses login
  void login() {
    // Mengecek input kosong
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password wajib diisi'),
        ),
      );

      return;
    }

    // Masuk ke HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ===== RESPONSIVE: MediaQuery =====
    // Mengambil ukuran layar.
    final screenWidth = MediaQuery.sizeOf(context).width;

    // ===== RESPONSIVE: LayoutBuilder =====
    // Menentukan apakah tampilan mobile atau desktop/web.
    final isMobile = screenWidth < 600;

    // Lebar form menyesuaikan ukuran layar.
    final formWidth = isMobile
        ? screenWidth * 0.88
        : screenWidth >= 1000
            ? 480.0
            : 430.0;

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      body: SafeArea(
        child: Stack(
          children: [
            // Dekorasi merah muda di bagian bawah
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: isMobile ? 300 : 400,
                height: isMobile ? 250 : 320,
                decoration: BoxDecoration(
                  color: const Color(0xffffeeee),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),

            // Isi halaman
            Center(
              child: SingleChildScrollView(
                // ===== RESPONSIVE: MediaQuery =====
                // Padding menyesuaikan ukuran layar.
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 30,
                  vertical: 20,
                ),

                child: SizedBox(
                  // ===== RESPONSIVE: MediaQuery =====
                  // Form tidak terlalu lebar di desktop.
                  width: formWidth,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo motor sederhana
                      Container(
                        // ===== RESPONSIVE: MediaQuery =====
                        width: isMobile ? 90 : 105,
                        height: isMobile ? 90 : 105,
                        decoration: BoxDecoration(
                          color: const Color(0xffffe5e5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.two_wheeler,
                          size: isMobile ? 55 : 65,
                          color: Colors.red,
                        ),
                      ),

                      SizedBox(
                        height: isMobile ? 18 : 22,
                      ),

                      // Nama aplikasi
                      // ===== RESPONSIVE: FittedBox =====
                      // Supaya tulisan tidak overflow pada layar kecil.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isMobile ? 32 : 38,
                              fontWeight: FontWeight.bold,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Moto',
                                style: TextStyle(
                                  color: Color(0xff202124),
                                ),
                              ),
                              TextSpan(
                                text: 'Blog',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Deskripsi
                      // ===== RESPONSIVE: Flexible =====
                      Flexible(
                        child: Text(
                          'Informasi dan tips seputar dunia motor',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: isMobile ? 35 : 45,
                      ),

                      // Input username
                      TextField(
                        controller: usernameController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                          ),
                          filled: true,
                          fillColor: Colors.white,

                          // ===== RESPONSIVE: MediaQuery =====
                          contentPadding: EdgeInsets.symmetric(
                            vertical: isMobile ? 17 : 19,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffdddddd),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffdddddd),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Input password
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible =
                                    !isPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,

                          // ===== RESPONSIVE: MediaQuery =====
                          contentPadding: EdgeInsets.symmetric(
                            vertical: isMobile ? 17 : 19,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffdddddd),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xffdddddd),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: isMobile ? 25 : 30,
                      ),

                      // Tombol Login
                      // ===== RESPONSIVE: Expanded =====
                      SizedBox(
                        width: double.infinity,
                        height: isMobile ? 52 : 56,
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Link Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ===== RESPONSIVE: Flexible =====
                          Flexible(
                            child: const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                color: Color(0xff444444),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              // Membuka halaman Register
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}