import 'package:cercania/src/models/Post-model.dart';
import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/PostService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/cercania-drawer.dart';
import 'package:cercania/src/ui/widgets/simple-future-builder.dart';
import 'package:cercania/src/ui/widgets/simple-stream-buider.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cercania/src/utils/date-formatter.dart';
import 'package:cercania/src/utils/show-snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../../mockData/SocialMediaModel.dart';
import 'attached_images.dart';
import 'create-post.dart';
import 'shop_details.dart';

enum PageEnum {
  DeletePost,
}

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  final PostService _postService = PostService();
  final ShopService _shopService = ShopService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  bool liked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CercaniaDrawer(),
        appBar: CercaniaAppBar(context: context, title: 'Product Reviews'),
        floatingActionButton: AppData.isSignedIn
            ? FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AppData.profile
                .likedProducts
                .isNotEmpty
                ? CustomNavigator.navigateTo(context, PostPage())
                : showToastMsg("¡Debe tener cualquier producto favorito para compartir una reseña!",true);
          },
        )
            : SizedBox(),
        body: SimpleStreamBuilder<List<Post>>.simpler(
          context: context,
            noDataMessage: 'No Product Reviews Yet',
            stream: _postService.fetchAllSortedFirestore(),
            builder: (List<Post> snapshot) {
                return ListView.builder(
                    itemCount: snapshot.length,
                    itemBuilder: (context, i) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(

                              children: <Widget>[
                            Row(children: <Widget>[
                              ClipOval(
                                  child: Image.network(
                                    snapshot[i].userImage,
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(snapshot[i].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),

                              AppData.isSignedIn
                                  ? LikeButton(
                                  false, snapshot[i].id, () {})
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    right: 4.0, left: 10.0),
                                child: Icon(Icons.thumb_up),
                              ),
                              Text(snapshot[i].likes.toString()),
                              AppData.isSignedIn ? AppData.profile
                                  .id == snapshot[i].userId ?
                              PopupMenuButton<int>(
                                offset: Offset(0, 40),
                                itemBuilder: (context) =>
                                [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.delete),
                                        Text("Delete Review"),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (int value) {
                                  _postService.deletePost(
                                      snapshot[i]);
                                },
                              ) : SizedBox() : SizedBox(),


                            ]),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                0,
                                8.0,
                                0,
                                12,
                              ),
                              child: Text(
                                snapshot[i].description,
                              ),
                            ),
                            snapshot[i].images.isNotEmpty
                                ? AttachedImages(
                              images: snapshot[i].images,
                            )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0),
                              child: Row(children: <Widget>[

                                SimpleFutureBuilder<Shop>.simpler(

                                    future: _shopService.fetchShopName(
                                        snapshot[i].shopId),
                                    context: context,
                                    builder: (
                                        AsyncSnapshot <Shop> data) {
                                      return InkWell(
                                          splashColor: Colors.grey.shade200,
                                          onTap: () {
                                            CustomNavigator.navigateTo(context,
                                                ShopDetail(shop: data.data));
                                          },
                                          child: data.data != null ? Row(
                                            children: <Widget>[
                                              Icon(
                                                  CupertinoIcons.shopping_cart),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text("${data.data.name}")
                                            ],
                                          ) : SizedBox()
                                      );
                                    }),
                                Expanded(child: Container()),
                                Text(
                                    ((DateTime date) =>
                                    "${date.hour % 12}:${date.minute} ${date
                                        .hour > 12
                                        ? 'PM'
                                        : 'AM'} ${getFormattedDate(
                                        snapshot[i].time.toDate()
                                            .toString())}")(
                                      snapshot[i].time
                                          .toDate(),
                                    ),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0x88000000))),


                              ]),
                            )
                          ]),
                        ),
                      );
                    });
            }));
  }
  }

class LikeButton extends StatefulWidget {
  final String id;
  final bool liked;
  final void Function() onChanged;

  LikeButton(this.liked, this.id, this.onChanged);

  @override
  createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  var liked = false;
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();

    liked = this.widget.liked;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: this.liked
          ? Icon(Icons.thumb_up, color: Colors.blue)
          : Icon(Icons.thumb_up, color: Colors.grey),
      onPressed: () {
        if (this.widget.onChanged != null) {
          this.widget.onChanged();
        }
        setState(() {
          this.liked = !this.liked;
          this.liked
              ? _postService.updatedLikedPost(widget.id, liked)
              : _postService.updatedLikedPost(widget.id, liked);
        });
      },
    );
  }
}
