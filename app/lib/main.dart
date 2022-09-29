import 'package:grow_me_app/components/card.dart';
import 'package:grow_me_app/components/connection_sheet.dart';
import 'package:grow_me_app/components/device_carousel.dart';
import 'package:grow_me_app/components/device_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(ChangeNotifierProvider(
      create: (context) => DeviceModel(), child: const GrowMeApp()));
}

const primarySwatch = MaterialColor(0xFF273825, {
  50: Color(0xFFE5E7E5),
  100: Color(0xFFBEC3BE),
  200: Color(0xFF939C92),
  300: Color(0xFF687466),
  400: Color(0xFF475646),
  500: Color(0xFF273825),
  600: Color(0xFF233221),
  700: Color(0xFF1D2B1B),
  800: Color(0xFF172416),
  900: Color(0xFF0E170D),
});

const lightBackgroundColor = Color(0xFFE5DBCF);

const PrimaryAssentColor = Color(0x00263825);
const PrimaryDarkColor = Color(0xFF808080);
const ErroColor = Color(0xFF808080);

class GrowMeApp extends StatelessWidget {
  const GrowMeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        primarySwatch: primarySwatch,
      ),
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

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class _MyHomePageState extends State<GrowMeHomePage> {
  Widget _connectionCard() {
    return GrowMeCard(
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Spacer(),
                const Icon(Icons.bluetooth),
                const SizedBox(height: 15),
                const Text(
                  "Grow your forest",
                  textScaleFactor: 2,
                ),
                const SizedBox(height: 15),
                const Text("Add new GrowMe products"),
                const Spacer(),
                const ConnectionSheet(),
              ].toList(),
            )));
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
      backgroundColor: primarySwatch,
      body: Column(
          children: [
        const SizedBox(height: 50),
        DeviceCarousel(leadingCarouselItems: [_connectionCard()]),
        const Spacer(),
      ].toList()),
    );
  }
}
