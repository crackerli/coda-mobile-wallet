import 'dart:typed_data';

import 'package:coda_wallet/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

// Save the generated qr image data as file
Future<String> saveImageAsFile(GlobalKey qrImageKey) async {
  try {
    RenderRepaintBoundary boundary = qrImageKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
    final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),
      quality: 100, name: 'mina-account-${getCurrentTimeString()}', isReturnImagePathOfIOS: false);
    print(result);
    return result['filePath'];
  } catch (e) {
    print(e);
  }
  return null;
}