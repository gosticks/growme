import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grow_me_app/colors.dart';
import 'package:grow_me_app/components/card.dart';
import 'package:grow_me_app/components/connection_sheet.dart';
import 'package:grow_me_app/components/device_carousel.dart';
import 'package:grow_me_app/components/device_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(ChangeNotifierProvider(
      create: (context) => DeviceModel(), child: const GrowMeApp()));
}

class GrowMeApp extends StatelessWidget {
  const GrowMeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrowMe',
      theme: ThemeData(
          fontFamily: 'Manrope',
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: green,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: green, displayColor: sand)),
      home: const GrowMeHomePage(title: 'GrowMe'),
    );
  }
}

class GrowMeHomePage extends StatefulWidget {
  const GrowMeHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GrowMeHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GrowMeHomePage> {
  Widget _connectionCard() {
    return GrowMeCard(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Spacer(),
                const Icon(Icons.forest, size: 120, color: green),
                const SizedBox(height: 15),
                const Text(
                  "Grow your forest",
                  textScaleFactor: 2,
                ),
                const SizedBox(height: 15),
                const Text("Connect new GrowMe products"),
                const Spacer(),
                const ConnectionSheet(),
              ].toList(),
            )));
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the GrowMeHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Image(
            height: 50, image: AssetImage("assets/images/logo.png")),
        leadingWidth: 100,
        // actions: [const Icon(Icons.settings)].toList(),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      backgroundColor: green,
      body: Column(
          children: [
        const Spacer(),
        DeviceCarousel(leadingCarouselItems: [_connectionCard()]),
        const Spacer(),
      ].toList()),
    );
  }
}
