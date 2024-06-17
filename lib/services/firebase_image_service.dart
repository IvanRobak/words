import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> fetchImageUrl(String imageName) async {
    final ref = storage.refFromURL(imageName);
    return await ref.getDownloadURL();
  }
}
