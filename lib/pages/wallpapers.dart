// a page to view wallpapers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:nfs_alloy/misllaneous/water_rise_animator.dart';
import 'package:nfs_alloy/models/wallpaperLoader.dart';
import 'package:nfs_alloy/misllaneous/sanity_service.dart';


class Wallpapers extends StatefulWidget{
  const Wallpapers({super.key});

  @override
  WallpaperState createState() => WallpaperState();
}


class WallpaperState extends State<Wallpapers>{
  late Future<List<Wallpaperloader>> wallpaperLoader;

  bool isEnabled = true;

  @override
  void initState() {
    super.initState();

    // load the images once
    wallpaperLoader = SanityService().fetchGalleryImages();
  }

  @override
  Widget build(BuildContext context) {
    
    return pageContent();
  }

  Widget pageContent(){

    return ListView(
      
      children: [
        // Wallpaper text
        Text('Wallpapers', style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 240, 240, 240)),),

        // Gallery grid view of images
        FutureBuilder(
          future: wallpaperLoader, 
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator.adaptive(),);
            }

            if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'),);
            }

            if(!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text('No images found.'),);
            }

            List<Wallpaperloader> images = snapshot.data!;
            if(kDebugMode){
              print('No. of images fetched: ${images.length}');
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                crossAxisCount: 4), 
              itemBuilder: (context, index){
                Wallpaperloader img = images[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          img.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          img.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                );
              }
              );
          }
        ),
      ],
    );
  }


  Widget imageBox(int value, String url){


    return Container(
      color: Colors.grey,
      child: Text('Image $value'),
    );
  }
}