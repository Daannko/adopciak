import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService {
  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }

    try {
      var urlRef =
          firebaseStorage.child("animal_images").child(imgName.toLowerCase());
      var imgUrl = await urlRef.getDownloadURL();
      print('-------------------------------------------');
      print(imgUrl);
      return imgUrl;
    } catch (e) {
      return null;
    }
  }
}
