import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSection extends StatelessWidget {
  final String? imageUrl;

  const ImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Отримання розмірів екрану
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Визначення ширини контейнера як певний відсоток від ширини екрану
    double containerWidth = screenWidth * 0.85; // 90% від ширини екрану
    // Визначення висоти контейнера як певний відсоток від висоти екрану
    double containerHeight = screenHeight * 0.25; // 25% від висоти екрану

    return Center(
      child: Container(
        height: containerHeight,
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    height: containerHeight,
                    width: containerWidth,
                    child: const Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text(
                  'No image available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
