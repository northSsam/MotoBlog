// Halaman utama MotoBlog

import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import 'frompages.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  // Constructor halaman Home
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan index halaman pada bottom navigation
  int currentIndex = 0;

  // Menyimpan data artikel dari API
  Future<List<Post>>? posts;

  @override
  void initState() {
    super.initState();

    // Mengambil artikel saat halaman pertama dibuka
    loadPosts();
  }

  // Mengambil data artikel dari API
  void loadPosts() {
    setState(() {
      posts = ApiService.getPosts();
    });
  }

  // Mengatur perpindahan halaman bottom navigation
  void changePage(int index) {
    // Jika memilih menu tambah artikel
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FormPage(),
        ),
      ).then((_) {
        // Memuat ulang artikel setelah kembali dari form
        loadPosts();
      });

      return;
    }

    // Mengubah halaman yang sedang aktif
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ===== RESPONSIVE: MediaQuery =====
    // Mengambil ukuran layar untuk menyesuaikan tampilan.
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Menentukan ukuran padding berdasarkan layar.
    final horizontalPadding = screenWidth >= 1000
        ? 40.0
        : screenWidth >= 600
            ? 28.0
            : 16.0;

    // Menampilkan halaman profile
    if (currentIndex == 2) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF7F7),

        // Halaman profile
        body: const ProfilePage(),

        // Bottom navigation
        bottomNavigationBar: buildBottomNav(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),

      // AppBar utama
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF2028),
        elevation: 0,

        // Judul aplikasi
        title: const Text(
          'MotoBlog',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Tombol refresh
        actions: [
          IconButton(
            onPressed: loadPosts,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // Refresh halaman dengan cara tarik ke bawah
      body: RefreshIndicator(
        onRefresh: () async {
          loadPosts();
        },

        // Mengambil data artikel
        child: FutureBuilder<List<Post>>(
          future: posts,

          // Menampilkan hasil dari API
          builder: (context, snapshot) {
            // Tampilan ketika sedang mengambil data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF2028),
                ),
              );
            }

            // Tampilan jika API mengalami error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Gagal mengambil artikel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tombol mencoba mengambil data lagi
                    ElevatedButton(
                      onPressed: loadPosts,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            // Mengambil data artikel dari hasil API
            final data = snapshot.data ?? [];

            return LayoutBuilder(
              builder: (context, constraints) {
                // ===== RESPONSIVE: LayoutBuilder =====
                // Di bawah 600 = mobile
                // 600 ke atas = tablet / desktop / web
                final isMobile = constraints.maxWidth < 600;

                // ===== RESPONSIVE: Expanded =====
                // Menentukan jumlah kolom artikel berdasarkan ukuran layar.
                final crossAxisCount = isMobile ? 1 : 2;

                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    30,
                  ),
                  children: [
                    // Banner utama MotoBlog
                    buildHero(),

                    const SizedBox(height: 24),

                    // Judul bagian artikel
                    Row(
                      children: [
                        // ===== RESPONSIVE: Expanded =====
                        // Memberikan ruang fleksibel untuk judul.
                        const Expanded(
                          child: Text(
                            'Artikel Terbaru',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Jumlah artikel
                        Text(
                          '${data.length} artikel',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Tampilan jika belum ada artikel
                    if (data.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text('Belum ada artikel'),
                        ),
                      ),

                    // ===== RESPONSIVE: LayoutBuilder =====
                    // Mobile = 1 kolom
                    // Desktop/Web = 2 kolom
                    if (data.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,

                          // Jarak horizontal antar card
                          crossAxisSpacing: 16,

                          // Jarak vertikal antar card
                          mainAxisSpacing: 16,

                          // Ukuran card menyesuaikan layar
                          childAspectRatio: isMobile ? 0.90 : 0.82,
                        ),
                        itemBuilder: (context, index) {
                          return buildArticleCard(
                            data[index],
                            index,
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: buildBottomNav(),
    );
  }

  // Membuat banner utama MotoBlog
  Widget buildHero() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ===== RESPONSIVE: LayoutBuilder =====
        final isMobile = constraints.maxWidth < 600;

        // ===== RESPONSIVE: MediaQuery =====
        final screenWidth = MediaQuery.sizeOf(context).width;

        // Ukuran banner mengikuti layar
        final heroHeight = isMobile
            ? 150.0
            : screenWidth >= 1000
                ? 190.0
                : 170.0;

        return Container(
          height: heroHeight,

          // Tampilan background banner
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF2028),
                Color(0xFFE50914),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
          ),

          // Isi banner
          child: Stack(
            children: [
              // Icon motor sebagai hiasan
              Positioned(
                right: isMobile ? -30 : -20,
                bottom: isMobile ? -20 : -25,
                child: Icon(
                  Icons.two_wheeler,
                  size: isMobile ? 150 : 190,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),

              // ===== RESPONSIVE: Flexible =====
              // Membuat area teks dapat menyesuaikan ruang.
              Padding(
                padding: EdgeInsets.all(isMobile ? 20 : 28),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ===== RESPONSIVE: FittedBox =====
                      // Menyesuaikan ukuran teks agar tidak overflow.
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Dunia Motor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 26 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ===== RESPONSIVE: FittedBox =====
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isMobile
                              ? 'Temukan tips, review, dan berita terbaru\nseputar motor.'
                              : 'Temukan tips, review, dan berita terbaru seputar motor.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 13 : 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Membuat card artikel
  Widget buildArticleCard(Post post, int index) {
    // Mengambil URL foto dari database
    final imageUrl = post.imageUrl;

    return GestureDetector(
      // Membuka detail artikel ketika card ditekan
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              post: post,
            ),
          ),
        ).then((_) {
          // Memuat ulang data setelah kembali
          loadPosts();
        });
      },

      child: Container(
        // Jarak antar card
        margin: const EdgeInsets.only(bottom: 0),

        // Tampilan card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan foto artikel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),

              // Jika artikel memiliki URL foto
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,

                      // ===== RESPONSIVE: MediaQuery =====
                      // Tinggi gambar menyesuaikan lebar layar.
                      height: MediaQuery.sizeOf(context).width < 600
                          ? 170
                          : 150,

                      width: double.infinity,
                      fit: BoxFit.cover,

                      // Tampilan jika URL foto gagal
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return buildImageError();
                      },
                    )
                  : buildImageError(),
            ),

            // Informasi artikel
            Padding(
              padding: const EdgeInsets.all(14),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFFF2028),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 9),

                  // ===== RESPONSIVE: Flexible =====
                  // Membatasi teks agar tidak membuat card overflow.
                  Flexible(
                    child: Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Ringkasan isi artikel
                  Flexible(
                    child: Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== RESPONSIVE: Expanded =====
                  // Membuat area tombol mengikuti lebar card.
                  Row(
                    children: [
                      const Spacer(),

                      const Flexible(
                        child: Text(
                          'Baca Artikel →',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFFF2028),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan pengganti jika foto tidak tersedia
  Widget buildImageError() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ===== RESPONSIVE: LayoutBuilder =====
        final imageHeight = constraints.maxWidth < 600 ? 170.0 : 150.0;

        return Container(
          height: imageHeight,
          width: double.infinity,
          color: const Color(0xFFFFE5E5),
          child: const Center(
            child: Icon(
              Icons.two_wheeler,
              size: 60,
              color: Color(0xFFFF2028),
            ),
          ),
        );
      },
    );
  }

  // Membuat bottom navigation
  Widget buildBottomNav() {
    return NavigationBar(
      selectedIndex: currentIndex,

      // Mengatur perpindahan menu
      onDestinationSelected: changePage,

      backgroundColor: Colors.white,
      elevation: 5,
      indicatorColor: const Color(0xFFFFE5E5),

      // Menu navigasi
      destinations: const [
        // Menu Home
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(
            Icons.home,
            color: Color(0xFFFF2028),
          ),
          label: 'Home',
        ),

        // Menu tambah artikel
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(
            Icons.add_circle,
            color: Color(0xFFFF2028),
          ),
          label: 'Artikel',
        ),

        // Menu Profile
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(
            Icons.person,
            color: Color(0xFFFF2028),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}