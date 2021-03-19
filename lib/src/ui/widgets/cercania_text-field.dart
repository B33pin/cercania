import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CercaniaTextField extends Padding {
  CercaniaTextField(
      {
        bool review = false,
        IconData icon,
      String label,
        bool expandLines=false,
      TextInputType keyboardType,
      BuildContext context,
        bool password=false,
      TextEditingController controller,
  bool onlyNumbers = false,
  Function(String) validator})
      : super(
            padding: const EdgeInsets.fromLTRB(12, 20, 0, 5),
            child: TextFormField(
              inputFormatters: onlyNumbers ? [WhitelistingTextInputFormatter.digitsOnly] : null,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.next,
              obscureText: password,
              onFieldSubmitted: (v) {
                FocusScope.of(context).nextFocus();
              },
              maxLines: (expandLines && !password) ? 3 : 1,
              scrollPadding: EdgeInsets.all(120),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  icon,
                ),
                hintText: '$label',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ) ,
              ),
              validator: validator,
              controller: controller,
            ),
        );
}
