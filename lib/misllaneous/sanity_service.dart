// a class to fetch the images and other relevant data from the Sanity server

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
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

  // Add this inside your SanityService class
  Future<String?> fetchRandomBackgroundImage() async {
    // 1. Get the total count of images first (Fast operation)
    const String countQuery = 'count(*[_type == "galleryImage"])';
    
    final Uri countUrl = Uri.parse(
      'https://$projectID.api.sanity.io/v2021-10-21/data/query/$dataset?query=${Uri.encodeComponent(countQuery)}',
    );

    try {
      final countResponse = await http.get(countUrl);
      if (countResponse.statusCode != 200) return null;

      final int totalImages = json.decode(countResponse.body)['result'];
      if (totalImages == 0) return null;

      // 2. Generate a random index
      // We need dart:math for this. Import it at the top if you haven't: import 'dart:math';
      final int randomIndex = Random().nextInt(totalImages);

      // 3. Fetch exactly ONE image at that random index
      // Query: Get all images, order them (vital for consistency), and slice [index...index+1]
      final String fetchQuery = '*[_type == "galleryImage"] | order(_createdAt desc) [$randomIndex...${randomIndex + 1}]';
      
      final Uri fetchUrl = Uri.parse(
        'https://$projectID.api.sanity.io/v2021-10-21/data/query/$dataset?query=${Uri.encodeComponent(fetchQuery)}',
      );

      final fetchResponse = await http.get(fetchUrl);
      
      if (fetchResponse.statusCode == 200) {
        final data = json.decode(fetchResponse.body);
        final List<dynamic> results = data['result'];
        
        if (results.isNotEmpty) {
           // Reuse your existing logic to build the full URL
           return buildImageUrl(results[0]['image']);
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Sniper shot failed: $e");
      }
      return null;
    }
  }
}