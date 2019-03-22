import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'dart:developer';
import 'l10n/messages_all.dart';
import 'user.dart';

void main() {
  debugPaintSizeEnabled = true;
  var hasDebugger = false;
  print('hasDebugger...: $hasDebugger');
  debugger(
    when: hasDebugger,
  );
  runApp(Demo());
  //  serialize();
}

void serialize() {
  Map<String, dynamic> userMap =
      jsonDecode('{"name": "John Smith","email": "john@example.com"}');
  var user = new User.fromJson(userMap);
  print('name: ${user.name}, email: ${user.email}');
  String json = user.toJson().toString(); // jsonEncode(user);
  print('json: $json');
}

class DemoLocalizations {
  static Future<DemoLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return DemoLocalizations();
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  /* intl commands:
  flutter packages pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
  flutter packages pub run intl_translation:generate_from_arb --output-dir=lib/l10n \ --no-use-deferred-loading \ lib/main.dart lib/l10n/intl_en.arb lib/l10n/intl_pl.arb
  */
  String get back => Intl.message('Back', name: 'back');
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  static const en = 'en';
  static const pl = 'pl';

  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [en, pl].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) =>
      DemoLocalizations.load(locale);

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale(DemoLocalizationsDelegate.en),
        const Locale(DemoLocalizationsDelegate.pl),
      ],
      onGenerateRoute: (settings) {
        if (settings.name == SecondScreen.routeName) {
          final ScreenArguments args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => SecondScreen(
                  title: args.title,
                  message: args.message,
                ),
          );
        }
      },
      home: HomeScreen(title: HomeScreen.screenTitle),
      /* initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(title: HomeScreen.screenTitle),
        SecondScreen.routeName: (context) => SecondScreen(),
      }, */
    );
  }
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  static const screenTitle = 'Home Screen';

  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  SecondScreen.routeName,
                  arguments: ScreenArguments(
                    'Title from Home',
                    'Message from Home',
                  ),
                );
              },
              child: Text('Show Second Screen'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Show Second Screen'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  static const routeName = '/second';
  static const screenTitle = 'Second Screen';

  final String title;
  final String message;

  SecondScreen({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* final ScreenArguments args = ModalRoute.of(context).settings.arguments; */
    return Scaffold(
      appBar: AppBar(
        title: Text("$screenTitle - $title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              style: Theme.of(context).textTheme.display1,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('${DemoLocalizations.of(context).back}!'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
