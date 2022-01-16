import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String storagePath, Uint8List file, bool isPost) async {
    Reference reference =
        storage.ref().child(storagePath).child(auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();

      reference = reference.child(id);
    }

    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String imgUrl = await snapshot.ref.getDownloadURL();
    return imgUrl;
  }
}
