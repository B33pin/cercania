
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:flutter/material.dart';
class LikeShopButton extends StatefulWidget {
  final String id;
  final bool liked;
  LikeShopButton(this.liked, this.id,);

  @override
  createState() => _LikeShopButtonState();
}

class _LikeShopButtonState extends State<LikeShopButton> {
  var liked = false;

  @override
  void initState() {
    super.initState();
    liked = !this.widget.liked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        IconButton(
          icon: this.liked
              ? Icon(Icons.favorite, color: Colors.pink)
              : Icon(Icons.favorite_border, color: Colors.grey),
          onPressed: () {

            setState(() {
              this.liked = !this.liked;
              var prof = AppData.profile;
              AppData.likeShop(widget.id);
              ProfileService().updateFirestore(prof);
              prof.save();
            });
          },
        ),
      ],
    );
  }
}

