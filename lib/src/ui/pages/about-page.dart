import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CercaniaAppBar(title: "About",context: context,),
      body: Column(
        children: <Widget>[
          Image.asset("assets/cercania.png"),
          Container(
              margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: .5,
                spreadRadius: 1.0,
                color: Colors.black.withOpacity(.12))
          ],
          color:Colors.grey.shade500,
        ),child: Text(' "¡Podemos hacerlo - We can do it!" ',style: TextStyle(color: Colors.white),)),

          SizedBox(height: 20,),

          Container(margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color:Colors.grey.shade300,
                ),child: Text("Nuestro objetivo es hacer crecer a pequeñas empresas y marcas locales, enfocando en la Artesanía y Artes de talento nacional.Cercanía, un vínculo más cercano entre la tienda y los consumidores.")),
        customTile(url :"https://www.CercaniaApp.com",icon: Icon(Icons.attachment)),
        customTile(url :"https://youtu.be/JMIJa0TkVSk",icon: Icon(Icons.play_circle_filled)),
          customTile(email: true, title : "younmin@younmin.com" ,url :"mailto:younmin@younmin.com?subject=Contact&body=",icon: Icon(Icons.mail)),
          customTile(url :"tel:+595 (0)971 157414",icon: Icon(Icons.phone)),

        ],
      ),

    );
  }

  _launchURL(String url) async {
//    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {

      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget customTile({String url,String title,Icon icon,bool email=false}){
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Material(
            child: InkWell(
              child: Text(email ? title : url,style: TextStyle(color: Colors.blue.shade500)),
              onTap: (){
                _launchURL(url);
              },
            ),
          ),
        ],
      ),
    );
  }

}
