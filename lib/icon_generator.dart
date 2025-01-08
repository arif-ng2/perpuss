import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  // Inisialisasi binding Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Buat canvas untuk menggambar icon
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Ukuran canvas 512x512 pixel
  const size = Size(512, 512);
  
  // Gambar background biru tua
  final paint = Paint()..color = const Color(0xFF1A237E);
  canvas.drawRect(Offset.zero & size, paint);
  
  // Gambar buku putih
  paint.color = Colors.white;
  final bookPath = Path();
  
  // Cover buku
  bookPath.moveTo(size.width * 0.2, size.height * 0.2);
  bookPath.lineTo(size.width * 0.8, size.height * 0.2);
  bookPath.lineTo(size.width * 0.8, size.height * 0.8);
  bookPath.lineTo(size.width * 0.2, size.height * 0.8);
  bookPath.close();
  
  // Halaman buku
  bookPath.moveTo(size.width * 0.25, size.height * 0.3);
  bookPath.lineTo(size.width * 0.75, size.height * 0.3);
  bookPath.moveTo(size.width * 0.25, size.height * 0.4);
  bookPath.lineTo(size.width * 0.75, size.height * 0.4);
  bookPath.moveTo(size.width * 0.25, size.height * 0.5);
  bookPath.lineTo(size.width * 0.75, size.height * 0.5);
  bookPath.moveTo(size.width * 0.25, size.height * 0.6);
  bookPath.lineTo(size.width * 0.75, size.height * 0.6);
  bookPath.moveTo(size.width * 0.25, size.height * 0.7);
  bookPath.lineTo(size.width * 0.75, size.height * 0.7);
  
  // Gambar path buku
  canvas.drawPath(bookPath, paint);
  
  // Konversi ke image
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  
  // Simpan file
  final currentDir = Directory.current.path;
  final iconDir = path.join(currentDir, 'assets', 'icon');
  await Directory(iconDir).create(recursive: true);
  
  final iconPath = path.join(iconDir, 'book_icon.png');
  await File(iconPath).writeAsBytes(pngBytes);
  
  print('Icon berhasil dibuat di: $iconPath');
} 