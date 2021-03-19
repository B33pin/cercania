import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfo extends StatefulWidget {
  final String address;
  final String contact;
  final String email;

  ShopInfo(this.contact, this.email, this.address);

  @override
  State<StatefulWidget> createState() {
    return ShopInfoState();
  }
}

class ShopInfoState extends State<ShopInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shop Info",
          style: TextStyle(color: Colors.black45),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text("Teléfono: ")),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(widget.contact),
              )
            ]),
            SizedBox(
              height: 20,
            ),
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text("Email: ")),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(widget.email),
              )
            ]),
            SizedBox(
              height: 20,
            ),
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text("Dirección: ")),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: Text(widget.address),
              )
            ]),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Política de usuario",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () async {
                      const url =
                          "https://firebasestorage.googleapis.com/v0/b/ecommerce-81153.appspot.com/o/Privacy%20Policy%20and%20FAQs%2FCercania%20-%20Politicas%20de%20privacidad%20de%20cliente.pdf?alt=media&token=8e5fc739-decc-4e85-8465-11c0518a4ea6";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    indent: 160,
                    endIndent: 160,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
