import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class viewRatings extends StatefulWidget {
  viewRatings({this.shop_id});
  String shop_id;
  @override
  _viewRatingsState createState() => _viewRatingsState();
}

class _viewRatingsState extends State<viewRatings> {
  String comment,name,ratings,type;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var ratingdata;
  bool isloading = true;
  void getdata()async{
    final data = await firestore.collection('products').doc(widget.shop_id).collection('ratings').get();
    ratingdata = data;
    setState(() {
      isloading = false;
    });
  }
  @override
  void initState() {
   getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isloading?Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue[200],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemCount: ratingdata.docs.length,itemBuilder: (context,index)=>CommentBox(stars: ratingdata.docs[index].data()['stars'].toString(),comment: ratingdata.docs[index].data()['description'],name: ratingdata.docs[index].data()['name'],type: ratingdata.docs[index].data()['category'],rating: ratingdata.docs[index].data()['stars'].toInt(),)),
      )),
    );
  }
}

class CommentBox extends StatelessWidget {
  CommentBox({this.rating,this.name,this.type,this.comment,this.stars});
  String comment,name,type,stars;
  int rating;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 50,color: Colors.black54,),
                Container(width: 70,height:33,child: Text(name,style: GoogleFonts.acme(fontSize: 15),textAlign: TextAlign.center,)),
                SizedBox(height: 7,),
                rating==1?Text('⭐',style: TextStyle(fontSize: 11),):SizedBox(),
                rating==2?Text('⭐⭐',style: TextStyle(fontSize: 11),):SizedBox(),
                rating==3?Text('⭐⭐⭐',style: TextStyle(fontSize: 11),):SizedBox(),
                rating==4?Text('⭐⭐⭐⭐',style: TextStyle(fontSize: 11),):SizedBox(),
                rating==5?Text('⭐⭐⭐⭐⭐',style: TextStyle(fontSize: 11),):SizedBox(),
              ],
            ),
            SizedBox(width: 15,),
            Container(width: 3,color: Colors.blueGrey,height: 80,),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20,width: 80,color: Colors.green,child: Center(child:Text(type,style: GoogleFonts.acme(color: Colors.white),)),),
                  SizedBox(height: 5,),
                  Text(comment,style: GoogleFonts.alef(),),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
