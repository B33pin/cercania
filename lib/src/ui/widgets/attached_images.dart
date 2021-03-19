import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'carousel_FullScreenview.dart';

class AttachedImages extends StatefulWidget {
  DocumentSnapshot report;
  AttachedImages({Key key, @required this.report}) : super(key: key);
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
                  child: widget.report.data()['imageURL'].length == 0
                      ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.image),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                        ),
                        Text("No Attached Images!",style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w400),),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: widget.report.data()['imageURL'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => CarouselView(imageUrls: widget.report.data()['imageURL'],currentId: i)));
                     },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.network( '${widget.report.data()['imageURL'][i]}',
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
