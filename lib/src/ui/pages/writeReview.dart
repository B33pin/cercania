import 'package:cercania/src/models/appData-model.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class writeReview extends StatefulWidget {
  writeReview({@required this.id,this.productname});
  String id,productname;
  @override
  _writeReviewState createState() => _writeReviewState();
}

class _writeReviewState extends State<writeReview> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectednum = 1;
  double ratings=5;
  TextEditingController description_controller=TextEditingController();

  void _showIndicator() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Please select the type of the feedback",
              style: TextStyle(
                color: Color(0xFFC5C5C5),
              ),
            ),
            SizedBox(height: 25.0),
            Row(
              children: [
                CircularCheckBox(
                    value: selectednum==1?true:false,
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool x) {
                      setState(() {
                        selectednum = 1;
                      });
                    }),
                Text(
                  'Best Product',
                  style: TextStyle(
                      color: selectednum==1?Colors.blue:Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                CircularCheckBox(
                    value: selectednum==2?true:false,
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool x) {
                      setState(() {
                        selectednum =2;
                      });
                    }),
                Text(
                  'Faulty Product',
                  style: TextStyle(
                      color: selectednum==2?Colors.blue:Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                CircularCheckBox(
                    value: selectednum==3?true:false,
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool x) {
                      setState(() {
                        selectednum=3;
                      });
                    }),
                Text(
                  'Product not as described',
                  style: TextStyle(
                      color: selectednum==3?Colors.blue:Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
            Row(
              children: [
                CircularCheckBox(
                    value: selectednum==4?true:false,
                    activeColor: Colors.blue,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool x) {
                      setState(() {
                        selectednum = 4;
                      });
                    }),
                Text(
                  'Other issues',
                  style: TextStyle(
                      color: selectednum==4?Colors.blue:Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Please give ratings",
              style: TextStyle(
                color: Color(0xFFC5C5C5),
              ),
            ),
            SizedBox(height: 10,),
            RatingBar.builder(
              initialRating: ratings,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  ratings=rating;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 200,
              child: Stack(
                children: [
                  TextField(
                    maxLines: 10,
                    controller: description_controller,
                    decoration: InputDecoration(
                      hintText: "Please briefly describe",
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFFC5C5C5),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFE5E5E5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Spacer(),
            Row(
              children: [
                FlatButton(
                  onPressed: () async{
                    print(widget.productname);
                    FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
                    if(description_controller.text.length>3){
                      _showIndicator();
                    final data = await _firebasefirestore.collection('products').doc(widget.productname).collection('ratings').get();
                    if(data.docs.length==0){
                      await _firebasefirestore.collection('products').doc(widget.productname).collection('ratings').doc().set(
                          {
                            "name": AppData.profile.name,
                            "id": AppData.profile.id,
                            "stars": ratings,
                            "description":description_controller.text,
                            "category": selectednum==1?"Best Product":selectednum==2?"Faulty Product":selectednum==3?"Product not as described":"Other issues"
                          });
                      await _firebasefirestore.collection('products').doc(widget.productname).update({
                        "ratings":ratings,
                      });
                      _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                              content: new Text('Review submitted successfully!')
                          )
                      );
                    } else {
                      final individualdata = await _firebasefirestore.collection('products').doc(widget.productname).collection('ratings').where("id",isEqualTo: AppData.profile.id).get();
                      if(individualdata.docs.length!=0){
                        _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                                content: new Text('You have already submited review for this product!')
                            )
                        );
                      } else {
                        List<double> my_ratings = [];
                        double sum;
                        double stars;
                        for(int i =0; i<data.docs.length;i++){
                          my_ratings.add(data.docs[i].data()['stars']);
                        }
                        if(my_ratings.length>1){
                          sum = my_ratings.fold(0, (p, c) => p + c);
                        } else if(my_ratings.length==1
                        ) {
                          sum = my_ratings[0];
                        } else {
                          sum = 0;
                        }
                        stars = (sum+ratings)/(my_ratings.length+1);
                        await _firebasefirestore.collection('products').doc(widget.productname).collection('ratings').doc().set(
                            {
                              "name": AppData.profile.name,
                              "id": AppData.profile.id,
                              "stars": stars,
                              "description":description_controller.text,
                              "category": selectednum==1?"Best Product":selectednum==2?"Faulty Product":selectednum==3?"Product not as described":"Other issues"
                            });
                        await _firebasefirestore.collection('products').doc(widget.productname).update({
                          "ratings":stars,
                        });
                        _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                                content: new Text('Review submitted successfully!')
                            )
                        );
                      }
                    }
                    Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Color(0xFFE5E5E5),
                  padding: EdgeInsets.all(16.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
