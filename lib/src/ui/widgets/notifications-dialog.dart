import 'package:flutter/material.dart';

openNotificationDialog(BuildContext context, List<String> notification) {
  showDialog(
      context: context,
      builder: (context)=>AlertDialog(content: ListTile(
          title:  Row(children: <Widget>[
            Icon(Icons.notifications),
            SizedBox(width: 10,),
            Expanded(child: Text(notification[0]),)
          ],),
          subtitle:   Text(notification[1])),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      ));
}