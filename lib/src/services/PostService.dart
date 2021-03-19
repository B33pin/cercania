import 'package:cercania/src/models/Post-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '_Service.dart';
import 'firebase-storage-service.dart';

class PostService extends Service<Post> {
  @override
  String get collectionName => "posts";

  @override
  Post parseModel(DocumentSnapshot document) {
    return Post.fromJson(document.data())..id = document.id;
  }
  
  Future updatedLikedPost(String id, bool liked) async {
    await FirebaseFirestore.instance.collection(collectionName).doc(id).update({"likes": liked ? FieldValue.increment(1) : FieldValue.increment(-1) }).catchError((e) => print(e));
  }

  Future deletePost(Post post) async {
    FirebaseStorageService.deleteImages(post.images.map((e) => e.toString()).toList());
    await FirebaseFirestore.instance.collection(collectionName).doc(post.id).delete().catchError((e) => print(e));
  }

}