import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CarouselView extends StatefulWidget {
  List<dynamic> imageUrls;
  int currentId;
  CarouselView({Key key, @required this.imageUrls, this.currentId}) : super(key: key);
  @override
  _CarouselViewState createState() => _CarouselViewState();
}

class _CarouselViewState extends State<CarouselView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: PageController(initialPage: widget.currentId, keepPage: true, viewportFraction: 1),
            itemCount: widget.imageUrls.length,
          itemBuilder: (context,i) {
            return Center(child: Image.network('${widget.imageUrls[i]}', fit: BoxFit.fill,));
          }
        ),
    );
  }
}
