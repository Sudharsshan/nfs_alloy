// a class to fetch the images and other relevant data from the Sanity server

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:nfs_alloy/models/wallpaper_loader.dart';

class SanityService {
  static const String projectID = "f624xxvx";
  static const String dataset = "production";

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

  Future<List<Wallpaperloader>> fetchGalleryImages({
    int start = 0,
    int end = 19,
    String category = 'All' // Default to showing everything
  }) async {
    
    // 1. Start the Base Query
    // We leave the bracket open to optionally add the game filter
    String queryBuilder = '*[_type == "galleryImage"';

    // 2. Add Filter if a specific category is requested
    if (category != 'All') {
      // This adds: && game == "nfs-heat"
      queryBuilder += ' && game == "$category"';
    }

    // 3. Close the filter and add Sorting + Pagination
    // Final string looks like: *[_type == "galleryImage" && game == "nfs-heat"] | order(_createdAt desc) [0..19]
    final String fullQuery = '$queryBuilder] | order(_createdAt desc) [$start..$end]';

    // 4. Create the URL (Encoding the query safely)
    final Uri url = Uri.parse(
      'https://$projectID.api.sanity.io/v2021-10-21/data/query/$dataset?query=${Uri.encodeComponent(fullQuery)}',
    );

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

  // Fetch only the categories that actually have images
  Future<List<String>> fetchActiveCategories() async {
    // GROQ Query: Get all 'game' fields where game is defined, then deduplicate them
    const String query = 'array::unique(*[_type == "galleryImage" && defined(game)].game)';

    final Uri url = Uri.parse(
      'https://$projectID.api.sanity.io/v2021-10-21/data/query/$dataset?query=${Uri.encodeComponent(query)}',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Returns a simple list of strings: ["nfs-heat", "rdr2", "nfs-2015"]
        return List<String>.from(data['result']);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}