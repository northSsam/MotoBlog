// Halaman Detail Artikel MotoBlog

import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'frompages.dart';

class DetailPage extends StatefulWidget {
  // Data artikel yang dipilih
  final Post post;

  const DetailPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Status proses hapus
  bool isDeleting = false;

  // Fungsi untuk menghapus artikel
  Future<void> deletePost() async {
    setState(() {
      isDeleting = true;
    });

    try {
      // Menghapus artikel melalui API
      await ApiService.deletePost(widget.post.id);

      if (!mounted) return;

      // Kembali ke Home setelah berhasil dihapus
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus artikel'),
        ),
      );
    }
  }

  // Konfirmasi sebelum menghapus artikel
  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Artikel'),
          content: const Text(
            'Yakin ingin menghapus artikel ini?',
          ),
          actions: [
            // Tombol batal
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            // Tombol hapus
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deletePost();
              },
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Membuka halaman edit artikel
  Future<void> editPost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(
          post: widget.post,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // RESPONSIVE: MediaQuery
    // Digunakan untuk mengetahui ukuran layar perangkat.
    // ============================================================
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Di bawah 600 px dianggap mobile,
    // sedangkan 600 px ke atas dianggap desktop/web.
    final isMobile = screenWidth < 600;

    // ============================================================
    // RESPONSIVE: Ukuran padding
    // Padding dibuat lebih kecil di mobile dan lebih besar di desktop.
    // ============================================================
    final horizontalPadding = isMobile ? 20.0 : 60.0;

    // ============================================================
    // RESPONSIVE: Ukuran gambar
    // Tinggi gambar menyesuaikan ukuran layar.
    // ============================================================
    final imageHeight = isMobile ? 230.0 : 380.0;

    // ============================================================
    // RESPONSIVE: Ukuran judul
    // ============================================================
    final titleFontSize = isMobile ? 27.0 : 34.0;

    // ============================================================
    // RESPONSIVE: Lebar konten
    // Desktop dibuat tidak terlalu melebar agar nyaman dibaca.
    // ============================================================
    final contentWidth = isMobile
        ? double.infinity
        : screenWidth > 1000
            ? 850.0
            : screenWidth - 120;

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,

        // Tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // Judul
        title: const Text(
          'Detail Artikel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Tombol Edit dan Delete
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Artikel',
            onPressed: editPost,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus Artikel',
            onPressed: isDeleting ? null : showDeleteDialog,
          ),
        ],
      ),

      // ============================================================
      // ISI HALAMAN
      // ============================================================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ========================================================
            // RESPONSIVE: LayoutBuilder
            // Membatasi lebar konten ketika dibuka di desktop/web.
            // ========================================================
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: contentWidth,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // FOTO ARTIKEL
                      // ==================================================
                      if (widget.post.imageUrl != null &&
                          widget.post.imageUrl!.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          height: imageHeight,
                          child: Image.network(
                            widget.post.imageUrl!,
                            fit: BoxFit.cover,

                            // Jika gambar gagal dimuat
                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // ==================================================
                      // ISI ARTIKEL
                      // ==================================================
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 25,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // Kategori
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffffe5e5),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.post.categoryName,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ==================================================
                            // RESPONSIVE: Judul Artikel
                            // ==================================================
                            Text(
                              widget.post.title,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff202124),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Isi artikel
                            Text(
                              widget.post.content,
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 17,
                                height: 1.7,
                                color: const Color(0xff444444),
                              ),
                            ),

                            const SizedBox(height: 35),

                            // ==================================================
                            // RESPONSIVE: Tombol
                            // Lebar tombol mengikuti lebar layar/konten.
                            // ==================================================

                            // Tombol Edit
                            SizedBox(
                              width: double.infinity,
                              height: isMobile ? 52 : 56,
                              child: OutlinedButton.icon(
                                onPressed: editPost,
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Edit Artikel',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Tombol Delete
                            SizedBox(
                              width: double.infinity,
                              height: isMobile ? 52 : 56,
                              child: OutlinedButton.icon(
                                onPressed: isDeleting
                                    ? null
                                    : showDeleteDialog,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  isDeleting
                                      ? 'Menghapus...'
                                      : 'Hapus Artikel',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}