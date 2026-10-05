import 'package:flutter/material.dart';

import 'login_page.dart';

// Halaman profile pengguna
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // RESPONSIVE: MediaQuery
    // Mengambil ukuran layar perangkat.
    // ============================================================
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Di bawah 600 px = mobile.
    // 600 px ke atas = desktop/web.
    final isMobile = screenWidth < 600;

    // ============================================================
    // RESPONSIVE: Ukuran profile
    // ============================================================
    final avatarRadius = isMobile ? 55.0 : 70.0;
    final avatarIconSize = isMobile ? 60.0 : 75.0;

    // ============================================================
    // RESPONSIVE: Lebar menu
    // Pada desktop dibatasi supaya tidak terlalu lebar.
    // ============================================================
    final menuWidth = isMobile
        ? screenWidth - 40
        : screenWidth > 900
            ? 700.0
            : screenWidth - 120;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: menuWidth,

            child: Column(
              children: [
                // ==================================================
                // RESPONSIVE: Jarak atas
                // ==================================================
                SizedBox(
                  height: isMobile ? 30 : 45,
                ),

                // ==================================================
                // FOTO PROFILE
                // ==================================================
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.person,
                    size: avatarIconSize,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // NAMA PENGGUNA
                // ==================================================
                Text(
                  'Abrisam',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Pengguna MotoBlog',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(
                  height: isMobile ? 30 : 40,
                ),

                // ==================================================
                // MENU PROFILE
                // ==================================================
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      // ==================================================
                      // MENU ARTIKEL
                      // ==================================================
                      ListTile(
                        leading: const Icon(
                          Icons.article,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Artikel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {},
                      ),

                      const Divider(height: 1),

                      // ==================================================
                      // TENTANG MOTOBLOG
                      // ==================================================
                      ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Tentang MotoBlog',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Tentang MotoBlog',
                                ),
                                content: const Text(
                                  'MotoBlog adalah aplikasi blog '
                                  'informasi dan tips seputar motor '
                                  'yang dibuat untuk memudahkan '
                                  'pengguna membaca berbagai '
                                  'informasi otomotif.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      const Divider(height: 1),

                      // ==================================================
                      // LOGOUT
                      // ==================================================
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: isMobile ? 30 : 40,
                ),

                // ==================================================
                // COPYRIGHT
                // ==================================================
                Text(
                  'MotoBlog © 2026',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isMobile ? 13 : 14,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}