// a model class to download the wallpapers and load them as per request

class Wallpaperloader {

  final String title, description, imageUrl, gameCategory;

  Wallpaperloader({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.gameCategory,
  });

  factory Wallpaperloader.fromJSON(Map<String, dynamic> json, String imageUrl){

    return Wallpaperloader(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl: imageUrl,
      gameCategory: json['game'],
    );
  }
}