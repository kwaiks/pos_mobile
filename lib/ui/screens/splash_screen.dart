import 'package:flutter/material.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/core/viewmodels/splash_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  Future loadSettings(SplashModel model) async {
    bool userExist = await model.userExist();
    if (userExist) {
      return Navigator.of(context).pushReplacementNamed("home");
    }
    return Navigator.of(context).pushReplacementNamed("login");
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<SplashModel>(
      builder: (context, model, child) => new SplashScreen(
        seconds: 3,
        navigateAfterFuture: loadSettings(model),
        title: new Text("Mesan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        loaderColor: Colors.redAccent,
      ),
    );
  }
}
