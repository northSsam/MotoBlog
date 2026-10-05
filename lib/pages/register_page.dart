// Halaman Register MotoBlog

import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller input username
  final TextEditingController usernameController =
      TextEditingController();

  // Controller input password
  final TextEditingController passwordController =
      TextEditingController();

  // Controller konfirmasi password
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Mengatur tampilan password
  bool isPasswordVisible = false;

  // Mengatur tampilan konfirmasi password
  bool isConfirmPasswordVisible = false;

  // Proses register
  void register() {
    // Mengecek input kosong
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi'),
        ),
      );
      return;
    }

    // Mengecek password
    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak sama'),
        ),
      );
      return;
    }

    // Karena register masih UI saja,
    // setelah berhasil kembali ke Login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Register berhasil'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // Membuat input field
  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    VoidCallback? onVisibilityPressed,
    bool showVisibility = false,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,

        // Icon sebelah kiri
        prefixIcon: Icon(icon),

        // Icon mata password
        suffixIcon: showVisibility
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: onVisibilityPressed,
              )
            : null,

        filled: true,
        fillColor: Colors.white,

        // RESPONSIVE:
        // Padding input dapat disesuaikan dengan ukuran layar.
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 17,
            ),

        // Border normal
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xffdddddd),
          ),
        ),

        // Border saat tidak dipilih
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xffdddddd),
          ),
        ),

        // Border saat dipilih
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // RESPONSIVE: MediaQuery
    // Mengambil ukuran layar perangkat.
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Di bawah 600 px = mobile.
    // 600 px ke atas = desktop/web.
    final isMobile = screenWidth < 600;

    // RESPONSIVE: Lebar form
    // Desktop dibatasi supaya form tidak terlalu lebar.
    final formWidth = isMobile
        ? double.infinity
        : screenWidth > 900
            ? 500.0
            : screenWidth - 120;


    // RESPONSIVE: Padding horizontal
    final horizontalPadding = isMobile ? 32.0 : 50.0;

    // RESPONSIVE: Ukuran logo
    // =========================================================
    final logoSize = isMobile ? 80.0 : 95.0;
    final logoIconSize = isMobile ? 48.0 : 58.0;

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      body: SafeArea(
        child: Stack(
          children: [
            // ======================================================
            // Dekorasi merah di bawah
            // ======================================================
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                // RESPONSIVE: ukuran dekorasi
                width: isMobile ? 300 : 360,
                height: isMobile ? 250 : 300,
                decoration: BoxDecoration(
                  color: const Color(0xffffeeee),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),

            // ======================================================
            // Isi halaman
            // ======================================================
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Center(
                child: SizedBox(
                  width: formWidth,

                  child: Column(
                    children: [
                      // RESPONSIVE: jarak atas
                      SizedBox(
                        height: isMobile ? 25 : 40,
                      ),

                      // ==================================================
                      // Tombol kembali
                      // ==================================================
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: isMobile ? 20 : 25,
                      ),

                      // ==================================================
                      // Logo
                      // ==================================================
                      Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: const BoxDecoration(
                          color: Color(0xffffe5e5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.two_wheeler,
                          size: logoIconSize,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // Judul MotoBlog
                      // ==================================================
                      // RESPONSIVE: FittedBox mencegah teks
                      // terlalu lebar pada layar kecil.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isMobile ? 30 : 36,
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

                      // ==================================================
                      // Deskripsi
                      // ==================================================
                      const Text(
                        'Buat akun untuk bergabung di MotoBlog',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(
                        height: isMobile ? 35 : 40,
                      ),

                      // ==================================================
                      // USERNAME
                      // ==================================================
                      inputField(
                        controller: usernameController,
                        hint: 'Username',
                        icon: Icons.person_outline,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 17 : 19,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // PASSWORD
                      // ==================================================
                      inputField(
                        controller: passwordController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: !isPasswordVisible,
                        showVisibility: true,
                        onVisibilityPressed: () {
                          setState(() {
                            isPasswordVisible =
                                !isPasswordVisible;
                          });
                        },
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 17 : 19,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // CONFIRM PASSWORD
                      // ==================================================
                      inputField(
                        controller: confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: !isConfirmPasswordVisible,
                        showVisibility: true,
                        onVisibilityPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        contentPadding: EdgeInsets.symmetric(
                          vertical: isMobile ? 17 : 19,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Tombol Register
                      SizedBox(
                        width: double.infinity,

                        // RESPONSIVE: tinggi tombol
                        height: isMobile ? 52 : 56,

                        child: ElevatedButton(
                          onPressed: register,
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
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // Link kembali ke Login
                      // ==================================================
                      // RESPONSIVE: FittedBox menjaga Row agar
                      // tidak overflow pada layar kecil.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun? ',
                              style: TextStyle(
                                color: Color(0xff444444),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // RESPONSIVE: jarak bawah
                      SizedBox(
                        height: screenHeight < 700 ? 25 : 40,
                      ),
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