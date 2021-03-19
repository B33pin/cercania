import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/ui/pages/_base_page.dart';
import 'package:cercania/src/ui/widgets/social-auth-list.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cercania/src/utils/show-snackbar.dart';
import 'package:cercania/src/utils/simple-form.dart';
import 'package:cercania/src/utils/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _service = ProfileService();

  var _simpleFormKey = GlobalKey<SimpleFormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: SimpleForm(
              key: _simpleFormKey,
              message: 'Signing In',
              onError: (dynamic error){
                showToastMsg(error,true);
              },
              afterSubmit: () {
                CustomNavigator.pushReplacement(context, BasePage());
              },
              onSubmit: () async {
                var profile = await _service.fetchProfile(_username.text, _password.text);
                if (profile == null) {
                  throw "Incorrect username or password";
                } else {
                  await AppData.signIn(profile);
                }
              },
              child: Column(
                children: <Widget>[
                  Text("Cercania", style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold
                  )),

                  SizedBox(height: 50),

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username"
                    ),
                    validator: (value) => emptyValidator(value, "Username"),
                    controller: _username,
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    obscureText: true,
                    controller: _password,
                    validator: (value) => emptyValidator(value, "Password"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password"
                    ),
                  ),

                  SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text("Sign in"),
                      onPressed: ()=> _simpleFormKey.currentState.submit()
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(height: 1, width: double.infinity, color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),

                  SocialAuthList(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
