import 'package:coc_calculator/components/BuildingItem.dart';

import 'package:coc_calculator/data_offline/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/CalcPosition.dart';
import 'my_app_state.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'CoC Calculator',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        ),
        routes: {
          '/': (context) => const MyHomePage()
        },),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 @override
  void initState() {
    super.initState();
    deffBuildings.sort((a,b) =>  a.hitPoints.last.compareTo(b.hitPoints.last));
  }

  void launchCoffee() async => await canLaunchUrl( Uri.parse("https://buymeacoffee.com/bezes")) ? await launchUrl( Uri.parse("https://buymeacoffee.com/bezes" )) : throw 'Could not launch';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon:const Icon(Icons.coffee, color: Colors.orange,), onPressed: launchCoffee),],
        title: Center(
          child: RichText(
            text: TextSpan(
              text: 'CoC ',
              style: DefaultTextStyle.of(context).style.copyWith(color: Colors.orange, decoration: TextDecoration.none, fontSize: 30),
              children: const <TextSpan>[
                TextSpan(text: 'Calculator', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            Center(
              child: Wrap(
                children: attackSpells
                    .map((Entry spell) {
                  return CalcPosition(spell: spell);
                }).toList(),
              ),
            ),
            Center(
              child: Wrap(
                children: deffBuildings
                    .map((Entry spell) {
                  return BuildingItem(spell: spell);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
