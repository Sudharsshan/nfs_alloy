// a class to fetch the images and other relevant data from the Sanity server

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:nfs_alloy/models/wallpaper_loader.dart';

class SanityService {
  static const String projectID = "f624xxvx";
  static const String dataset = "production";

  static const String query = '*[_type == "galleryImage"]';

  final Uri url = Uri.parse(
    'https://$projectID.api.sanity.io/v2021-10-21/data/query/$dataset?query=$query',
  );

  String buildImageUrl(Map<String, dynamic> assetRef) {
    if (assetRef['asset'] == null || assetRef['asset']['_ref'] == null) {
      return ''; // Return a placeholder or handle error
    }
    String ref = assetRef['asset']['_ref'];
    String newRef = ref
        .replaceAll('image-', '')
        .replaceAll('-jpg', '.jpg')
        .replaceAll('-png', '.png')
        .replaceAll('-webp', '.webp');
        
    return 'https://cdn.sanity.io/images/$projectID/$dataset/$newRef';
  }

  Future<List<Wallpaperloader>> fetchGalleryImages() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['result'];

        List<Wallpaperloader> images = [];
        for (var item in results) {
          // Build the URL for this image
          String imageUrl = buildImageUrl(item['image']);

          // Parse the rest of the data
          images.add(Wallpaperloader.fromJSON(item, imageUrl));
        }
        return images;
      } else {
        // Failed to load
        throw Exception('Failed to load images (Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
