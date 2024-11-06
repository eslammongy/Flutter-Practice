import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

abstract class ImageCaptureHelper {
  /// Captures the specified widget as a PNG image and returns it as a Uint8List.
  /// This function takes a [GlobalKey] associated with a the [selected widget] and converts the
  /// widget into a PNG image at a specified pixel density.
  /// - Returns: A [Uint8List] of PNG image bytes, or [null] If the capture fails or the widget boundary cannot be found.
  static Future<Uint8List?> captureAsPng(
    GlobalKey widgetKey,
  ) async {
    try {
      final boundary = widgetKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  /// Saves a desired widget as PNG image represented by `pngBytes` to a local directory on the device.
  /// - On Android, saves the image to `/storage/emulated/0/Pictures/flutter_practice`.
  /// - On iOS, saves the image to the app's Documents directory.
  /// - Save the PNG data to the specified file path or Throws an exception if saving fails.
  static Future<void> saveImageLocally(
    Uint8List pngBytes,
  ) async {
    // Get the platform-specific directory
    final directory = Platform.isAndroid
        ? Directory('/storage/emulated/0/Pictures/flutter_practice')
        : await getApplicationDocumentsDirectory();

    // Create directory if not exists (Android only, iOS doesn't need this for Documents)
    if (Platform.isAndroid) {
      await directory.create(recursive: true);
    }

    // Define the file path and save the image
    final imgFile = File('${directory.path}/image${pngBytes.length}.png');

    try {
      await imgFile.writeAsBytes(pngBytes);
    } catch (e) {
      throw Exception('Failed to save widget as image');
    }
  }
}
