// Service untuk menghubungkan Flutter dengan API MotoBlog

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  // Alamat utama API backend
  static const String baseUrl = 'http://localhost:8000/api';

  // Mengambil semua artikel
  static Future<List<Post>> getPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    // Mengecek request berhasil
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      // Mengubah JSON menjadi object Post
      return data
          .map((item) => Post.fromJson(item))
          .toList();
    }

    throw Exception('Gagal mengambil artikel');
  }

  // Mengambil semua kategori
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
    );

    // Mengecek request berhasil
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
        jsonDecode(response.body),
      );
    }

    throw Exception('Gagal mengambil kategori');
  }

  // Menambahkan artikel
  static Future<void> createPost({
    required String title,
    required String content,
    required int categoryId,
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),

      // Header JSON
      headers: {
        'Content-Type': 'application/json',
      },

      // Data artikel
      body: jsonEncode({
        'title': title,
        'content': content,
        'category_id': categoryId,
        'image_url': imageUrl,
      }),
    );

    // Mengecek artikel berhasil dibuat
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan artikel');
    }
  }

  // Mengubah artikel
  static Future<void> updatePost({
    required int id,
    required String title,
    required String content,
    required int categoryId,
    required String imageUrl,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),

      // Header JSON
      headers: {
        'Content-Type': 'application/json',
      },

      // Data artikel yang diperbarui
      body: jsonEncode({
        'title': title,
        'content': content,
        'category_id': categoryId,
        'image_url': imageUrl,
      }),
    );

    // Mengecek artikel berhasil diubah
    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah artikel');
    }
  }

  // Menghapus artikel
  static Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );

    // Mengecek artikel berhasil dihapus
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus artikel');
    }
  }
}