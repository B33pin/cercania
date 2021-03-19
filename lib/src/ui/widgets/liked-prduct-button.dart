
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:flutter/material.dart';
class LikeButton extends StatefulWidget {
  final String id;
  final bool liked;


  LikeButton(this.liked, this.id);

  @override
  createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  var liked = false;

  @override
  void initState() {
    super.initState();
    liked = !this.widget.liked;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: this.liked
          ? Icon(Icons.favorite, color: Colors.pink)
          : Icon(Icons.favorite_border, color: Colors.grey),
      onPressed: () {


        setState(() {
          this.liked = !this.liked;

          var prof = AppData.profile;
          AppData.likeProduct(widget.id);
          // if (this.liked)
          //   prof?.likedProducts?.add(this.widget.id);
          // else
          //   prof?.likedProducts?.remove(this.widget.id);
          // print(prof.likedProducts);

          ProfileService().updateFirestore(prof);
          prof.save();
        });
      },
    );
  }
}