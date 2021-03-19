import 'carousel_view.dart';
import 'package:flutter/material.dart';
class AttachedImages extends StatefulWidget {
  List<String> images;
  AttachedImages({Key key, @required this.images}) : super(key: key);
  @override
  _AttachedImagesState createState() => _AttachedImagesState();
}

class _AttachedImagesState extends State<AttachedImages> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 150),
      child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(
                  color: Colors.black26,
                  width: 2.0
                )
              ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.images.length == 0
                      ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.image),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                        ),
                        Text("No Attached Images!",style: TextStyle(fontWeight: FontWeight.w400),),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: widget.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => CarouselView(imageUrls: widget.images,currentId: i)));
                     },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.network( '${widget.images[i]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
