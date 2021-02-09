import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/utils/colors.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/injector.dart';
import 'package:pos_mobile/ui/router.dart' as Router;
import 'package:provider/provider.dart';
import 'core/models/user.dart';

void main() async {
  setupInjector();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(POSApp());
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class POSApp extends StatefulWidget {
  @override
  _POSAppState createState() => _POSAppState();
}

class _POSAppState extends State<POSApp> {
  final Providers _providers = injector<Providers>();

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          create: (_) => _providers.userController.stream,
        ),
        StreamProvider<UserStore>(
            create: (_) => _providers.activeStoreController.stream),
        StreamProvider<List<Cart>>(
            create: (_) => _providers.cartController.stream)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'OpenSans',
          primaryColor: kPrimary,
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.red,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: Colors.red, primary: Colors.white),
          ),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: Router.initialRoute,
        onGenerateRoute: Router.Router.generateRoute,
        navigatorObservers: [routeObserver],
      ),
    );
  }
}
