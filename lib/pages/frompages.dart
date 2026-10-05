// Halaman untuk menambah dan mengedit artikel MotoBlog

import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class FormPage extends StatefulWidget {
  // Data artikel kalau sedang mode edit
  final Post? post;

  const FormPage({
    super.key,
    this.post,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  // Controller untuk input judul
  final TextEditingController titleController = TextEditingController();

  // Controller untuk input isi artikel
  final TextEditingController contentController = TextEditingController();

  // Controller untuk input URL foto
  final TextEditingController imageController = TextEditingController();

  // Menyimpan ID kategori yang dipilih
  int? selectedCategoryId;

  // Menyimpan data kategori dari API
  List<Map<String, dynamic>> categories = [];

  // Status loading
  bool isLoading = false;

  // Mengecek apakah sedang edit atau tambah
  bool get isEdit => widget.post != null;

  @override
  void initState() {
    super.initState();

    // Kalau edit, isi form dengan data artikel sebelumnya
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      contentController.text = widget.post!.content;
      imageController.text = widget.post!.imageUrl ?? '';
      selectedCategoryId = widget.post!.categoryId;
    }

    // Mengambil kategori dari API
    loadCategories();
  }

  // Mengambil kategori dari backend
  Future<void> loadCategories() async {
    try {
      final data = await ApiService.getCategories();

      if (!mounted) return;

      setState(() {
        categories = data;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil kategori'),
        ),
      );
    }
  }

  // Menyimpan artikel
  Future<void> savePost() async {
    // Mengecek judul
    if (titleController.text.trim().isEmpty) {
      showMessage('Judul artikel wajib diisi');
      return;
    }

    // Mengecek isi artikel
    if (contentController.text.trim().isEmpty) {
      showMessage('Isi artikel wajib diisi');
      return;
    }

    // Mengecek kategori
    if (selectedCategoryId == null) {
      showMessage('Kategori wajib dipilih');
      return;
    }

    // Mengecek URL gambar
    if (imageController.text.trim().isEmpty) {
      showMessage('URL foto wajib diisi');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Kalau edit, update artikel
      if (isEdit) {
        await ApiService.updatePost(
          id: widget.post!.id,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          categoryId: selectedCategoryId!,
          imageUrl: imageController.text.trim(),
        );
      } else {
        // Kalau tambah, buat artikel baru
        await ApiService.createPost(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          categoryId: selectedCategoryId!,
          imageUrl: imageController.text.trim(),
        );
      }

      if (!mounted) return;

      // Kembali ke halaman sebelumnya
      // Mengirim true supaya halaman sebelumnya tahu
      // bahwa data berhasil disimpan.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        isEdit
            ? 'Gagal mengubah artikel'
            : 'Gagal menambahkan artikel',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Menampilkan pesan error
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller
    titleController.dispose();
    contentController.dispose();
    imageController.dispose();

    super.dispose();
  }

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
    // RESPONSIVE: Padding
    // Desktop menggunakan jarak lebih besar.
    // ============================================================
    final horizontalPadding = isMobile ? 20.0 : 60.0;

    // ============================================================
    // RESPONSIVE: Lebar form
    // Pada desktop form dibatasi supaya tidak terlalu lebar.
    // ============================================================
    final formWidth = isMobile
        ? double.infinity
        : screenWidth > 1000
            ? 850.0
            : screenWidth - 120;

    return Scaffold(
      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Artikel' : 'Tambah Artikel',
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      // ============================================================
      // ISI HALAMAN
      // ============================================================
      body: SingleChildScrollView(
        // ==========================================================
        // RESPONSIVE: Padding
        // ==========================================================
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 20,
        ),

        child: Center(
          // ========================================================
          // RESPONSIVE: Lebar Form
          // ========================================================
          child: SizedBox(
            width: formWidth,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // INPUT JUDUL
                // ==================================================
                const Text(
                  'Judul Artikel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan judul artikel',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // INPUT KATEGORI
                // ==================================================
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih kategori',
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(
                        category['name'].toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // INPUT URL FOTO
                // ==================================================
                const Text(
                  'URL Foto',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan URL foto artikel',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // INPUT ISI ARTIKEL
                // ==================================================
                const Text(
                  'Isi Artikel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: contentController,
                  maxLines: isMobile ? 8 : 12,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan isi artikel',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // RESPONSIVE: TOMBOL SIMPAN
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 50 : 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : savePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            isEdit
                                ? 'Simpan Perubahan'
                                : 'Tambah Artikel',
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}