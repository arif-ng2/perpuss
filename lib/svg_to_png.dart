import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currentDir = Directory.current.path;
  final svgPath = path.join(currentDir, 'assets', 'icon', 'book_icon.svg');
  final pngPath = path.join(currentDir, 'assets', 'icon', 'book_icon.png');

  // Load SVG file
  final svgString = await File(svgPath).readAsString();
  final svgDrawableRoot = await svg.fromSvgString(svgString, 'book_icon');

  // Create a picture
  final picture = svgDrawableRoot.toPicture(size: const Size(512, 512));
  final image = await picture.toImage(512, 512);
  
  // Convert to PNG
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Save PNG file
  await File(pngPath).writeAsBytes(pngBytes);
  print('Icon berhasil dikonversi ke PNG: $pngPath');
} 