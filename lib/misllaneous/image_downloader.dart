import 'package:flutter/foundation.dart';

import 'package:web/web.dart' as web;
import 'package:http/http.dart' as http;

import 'dart:js_interop';

class Imagedownloader {
  Future<void> downloadImage(String urL, String fileName) async {
    try {
      final http.Response response = await http.get(Uri.parse(urL));

      final Uint8List bytes = response.bodyBytes;

      final String? contentType = response.headers['content-type'];
      final web.Blob blob = web.Blob(
        // ignore: invalid_runtime_check_with_js_interop_types
        [bytes as JSAny, (contentType ?? 'application/octet-stream').toJS].toJS,
        
      );

      final String blobUrl = web.URL.createObjectURL(blob);

      final web.HTMLAnchorElement anchor = web.HTMLAnchorElement();
      anchor.href = blobUrl;

      // Clean up the filename
      final String cleanFilename =
          '${fileName.replaceAll(RegExp(r'[^\w\s\.-]'), '')}.jpg';
      anchor.download = cleanFilename;

      // Add to the page, click it, and remove it
      web.document.body!.append(anchor);
      anchor.click();
      anchor.remove();

      // Revoke the temporary URL to free up memory
      web.URL.revokeObjectURL(blobUrl);

      if(kDebugMode) print('Successfully downloaded image');
    } catch (e) {
      if (kDebugMode) {
        print('Download failed: $e');
      }
    }
  }
}
