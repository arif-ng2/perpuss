import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() async {
  // Pastikan Flutter diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Buat picture recorder
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Ukuran canvas
  const size = Size(512, 512);
  final rect = Offset.zero & size;

  // Background biru
  final paint = Paint()..color = const Color(0xFF1A237E);
  canvas.drawRect(rect, paint);

  // Icon buku
  final iconPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  // Gambar icon buku
  final path = Path();
  final iconSize = size.width * 0.6;
  final left = (size.width - iconSize) / 2;
  final top = (size.height - iconSize) / 2;

  // Bentuk buku
  path.moveTo(left, top);
  path.lineTo(left + iconSize, top);
  path.lineTo(left + iconSize, top + iconSize);
  path.lineTo(left, top + iconSize);
  path.close();

  // Tambah detail buku
  final spineWidth = iconSize * 0.2;
  path.moveTo(left + spineWidth, top);
  path.lineTo(left + spineWidth, top + iconSize);

  canvas.drawPath(path, iconPaint);

  // Konversi ke image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Simpan file
  final file = File('assets/icon/book_icon.png');
  await file.writeAsBytes(buffer);
  print('Icon berhasil dibuat di: ${file.path}');
} 