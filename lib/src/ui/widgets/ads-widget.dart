import 'package:cercania/src/models/Ad-model.dart';
import 'package:cercania/src/services/_Service.dart';
import 'package:flutter/material.dart';

import 'carousel.dart';

class AdsWidget extends StatefulWidget {
  final String currentCategory;
  final Service service;
  AdsWidget({this.service,this.currentCategory});
  @override
  _AdsWidgetState createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {



  @override
  Widget build(BuildContext context) {
   return SliverToBoxAdapter(
      child: widget.currentCategory=='Todos' ? Container(
        height: 270,
        width: double.infinity,
        child: StreamBuilder<List<Ad>>(
            stream: widget.service.fetchAllFirestore(),
            builder: (context, AsyncSnapshot<List<Ad>> snapshot) {
              if (snapshot.hasError) print(snapshot.error.toString());
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox();
                case ConnectionState.active:
                  return Carousel(snapshot.data.map((url) => Image.network(url.url, fit: BoxFit.cover)).toList());
                default:
                  break;
              }
              return Container();
            }),
      ): SizedBox()
   );
  }
}
