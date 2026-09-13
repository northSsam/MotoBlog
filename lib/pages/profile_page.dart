import 'package:flutter/material.dart';
import 'login_page.dart';

// Halaman profile pengguna
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // AppBar
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Foto profile
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            // Nama pengguna
            const Text(
              'Abrisam',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Pengguna MotoBlog',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Menu profile
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Menu Artikel
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

                  // Tentang MotoBlog
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
                            title: const Text('Tentang MotoBlog'),
                            content: const Text(
                              'MotoBlog adalah aplikasi blog informasi '
                              'dan tips seputar motor yang dibuat untuk '
                              'memudahkan pengguna membaca berbagai '
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

                  // Logout
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

            const SizedBox(height: 30),

            // Copyright
            const Text(
              'MotoBlog © 2026',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}