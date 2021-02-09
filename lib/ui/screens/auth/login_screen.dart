import "package:flutter/material.dart";
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/utils/colors.dart';
import 'package:pos_mobile/core/viewmodels/auth_model.dart';

import '../base_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool hidePassword = true;

  Widget textField(
      {String label,
      TextEditingController controller,
      Function(String) onChanged,
      bool obscureText = false,
      Widget suffix,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            suffixIcon: suffix != null ? suffix : null,
            isDense: true,
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: Colors.redAccent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(color: kPrimary)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
            alignLabelWithHint: true,
            hintText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BaseScreen<AuthModel>(
        builder: (context, model, child) => new Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Mesan POS",
                              style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimary)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          model.errorMessage != null
                              ? Text(model.errorMessage)
                              : Container(),
                          textField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              label: "Email"),
                          textField(
                              suffix: IconButton(
                                onPressed: () => setState(() {
                                  hidePassword = !hidePassword;
                                }),
                                icon: hidePassword
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                              obscureText: hidePassword,
                              controller: _passController,
                              label: "Password"),
                          Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              child: model.state != StateStatus.Preparing
                                  ? Container(
                                      width: double.infinity,
                                      child: FlatButton(
                                        color: kPrimary,
                                        child: Text("Login",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        height: 50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        onPressed: () {
                                          if (model.state !=
                                              StateStatus.Preparing) {
                                            model.login(_emailController.text,
                                                _passController.text, context);
                                          }
                                        },
                                      ),
                                    )
                                  : CircularProgressIndicator())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
