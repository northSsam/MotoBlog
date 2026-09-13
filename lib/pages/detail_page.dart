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

    // Kalau artikel berhasil diedit,
    // kembali ke Home untuk mengambil data terbaru
    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      // Navbar atas
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
          // Tombol Edit
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Artikel',
            onPressed: editPost,
          ),

          // Tombol Delete
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus Artikel',
            onPressed: isDeleting ? null : showDeleteDialog,
          ),
        ],
      ),

      // Isi halaman
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto artikel
            if (widget.post.imageUrl != null &&
                widget.post.imageUrl!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 300,
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

            // Isi artikel
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffffe5e5),
                      borderRadius: BorderRadius.circular(20),
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

                  // Judul artikel
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202124),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Isi artikel
                  Text(
                    widget.post.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Color(0xff444444),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Tombol Edit
                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tombol Delete
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed:
                          isDeleting ? null : showDeleteDialog,
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
                          borderRadius: BorderRadius.circular(14),
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
      ),
    );
  }
}