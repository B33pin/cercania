import 'package:cercania/src/ui/pages/about-page.dart';
import 'package:cercania/src/ui/pages/my-oders.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CercaniaDrawer extends StatefulWidget {
  @override
  _CercaniaDrawerState createState() => _CercaniaDrawerState();
}

class _CercaniaDrawerState extends State<CercaniaDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(height: 190),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 7, color: Colors.grey)),
            color: Colors.black45,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: MediaQuery.of(context).padding.top),
            child: Row(children: <Widget>[
              // SizedBox(
              //     width: 70,
              //     height: 70,
              //     child: CircleAvatar(foregroundColor: Colors.blue)),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Cercania".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ]),
              )
            ]),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Column(children: [
                _DrawerItem(
                  'product',
                  "Productos cosméticos",
                      () => _navigateTo(context, 0),
                ),
                _DrawerItem(
                  'jewelry',
                  "Accesorios",
                      () => _navigateTo(context, 1),
                ),
                _DrawerItem(
                  'painting',
                  "Artesanía y arte",
                      () => _navigateTo(context, 2),
                ),
                _DrawerIconItem(
                  Icons.content_paste,
                  "Compras realizadas",
                      () => CustomNavigator.navigateTo(context, Myorders()),
                ),
              ]),
            ),
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.question_answer,
            color: Colors.black,
          ),
          title: Text("Preguantas Frecuentes"),
          onTap: ()  {
            Navigator.of(context).pop();
            const url =
                'https://firebasestorage.googleapis.com/v0/b/ecommerce-81153.appspot.com/o/Privacy%20Policy%20and%20FAQs%2FFAQs.pdf?alt=media&token=76fdf2b8-361d-4cf8-9816-5c36a7bf72ff';
            // if (await canLaunch(url)) {
            //   await launch(url);
            // } else {
            //   throw 'Could not launch $url';
            // }
            _launchURL(url);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.info,
            color: Colors.black,
          ),
          title: Text("About"),
          onTap: () {
            CustomNavigator.navigateTo(context, AboutPage());
          },
        ),
      ]),
    );
  }

  _navigateTo(context, i) {
    Navigator.of(context).pop();
    CustomNavigator.baseController.index = 0;
    CustomNavigator.homeController.animateTo(i);
  }
    _launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}

class _DrawerItem extends StatelessWidget {
  final String _text;
  final String _icon;
  final void Function() _action;

  _DrawerItem(this._icon, this._text, this._action);

  @override
  build(context) {
    return ListTile(
      title: Text(_text),
      leading: Image.asset("assets/$_icon.png",scale: 4,),
      onTap: this._action,
    );
  }
}


class _DrawerIconItem extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final void Function() _action;

  _DrawerIconItem(this._icon, this._text, this._action);

  @override
  build(context) {
    return ListTile(
      title: Text(_text),
      leading: Icon(_icon),
      onTap: this._action,
    );
  }
}