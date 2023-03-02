import 'dart:io';
import 'dart:typed_data';

import 'package:coda_wallet/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

// Save the generated qr image data as file
Future<String?> saveImageAsFile(GlobalKey qrImageKey) async {
  try {
    RenderRepaintBoundary? boundary = qrImageKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

    var isIOS = false;
    if(Platform.isIOS || Platform.isMacOS){
      isIOS = true;
    }

    final result =
      await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List(),
      quality: 100, name: 'mina-account-${getCurrentTimeString()}', isReturnImagePathOfIOS: isIOS);
    print(result);
    return result['filePath'];
  } catch (e) {
    print(e);
  }
  return null;
}

// Save the generated qr image data as file
Future<String?> saveImageBytesAsFile(Uint8List imageBytes) async {
  try {
    var isIOS = false;
    if(Platform.isIOS || Platform.isMacOS){
      isIOS = true;
    }

    final result =
    await ImageGallerySaver.saveImage(imageBytes,
        quality: 100, name: 'mina-account-${getCurrentTimeString()}', isReturnImagePathOfIOS: isIOS);
    print(result);
    return result['filePath'];
  } catch (e) {
    print(e);
  }
  return null;
}