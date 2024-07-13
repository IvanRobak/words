import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSection extends StatelessWidget {
  final String? imageUrl;

  const ImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 186,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
        ),
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    height: 186,
                    width: double.infinity,
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
