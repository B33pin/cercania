import 'dart:io';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/cercania_text-field.dart';
import 'package:cercania/src/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _old = TextEditingController();
  var _new = TextEditingController();
  var _confirmNew = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool autoValidate=false;

  handleValidation(dynamic childValue) {
    setState(() {
      autoValidate = childValue;
    });
  }

  String confirmValidator(String value){
    if(_new.text != value){
      return "New passwords don't match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CercaniaAppBar(context: context,title: 'Change Password',),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            autovalidate: autoValidate,
            child: Column(
              children: <Widget>[
                CercaniaTextField(
                  controller: _old,
                  password: true,
                  context: context,
                  icon: CupertinoIcons.padlock,
                  validator: (value)=>emptyValidator(value,'Old Password'),
                  label: 'Old Password',
                ),
                CercaniaTextField(
                  controller: _new,
                  context: context,
                  password: true,
                  icon: CupertinoIcons.padlock,
                  validator: (value)=>emptyValidator(value,'New Password'),
                  label: 'New Password',
                ),
                CercaniaTextField(
                  context: context,
                  controller: _confirmNew,
                  password: true,
                  icon: CupertinoIcons.padlock,
                  validator: (value)=>confirmValidator(value),
                  label: 'Confirm New Password',
                ),
                Builder(
                  builder: (ctx) => RaisedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      if(formKey.currentState.validate()){
                        FocusScope.of(context).requestFocus(FocusNode());
                        FocusScope.of(context).requestFocus(FocusNode());
                          ProfileService().changePassword(context, _old.text, _new.text);
                      } else {
                        setState(() {
                          autoValidate=true;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
