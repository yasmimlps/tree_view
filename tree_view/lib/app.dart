import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tree_view/models/asset.dart';
import 'package:tree_view/models/location.dart';
import 'package:tree_view/pages/home_page.dart';
import 'package:tree_view/pages/unit_page.dart';
import 'package:tree_view/utils/json_loader.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree View',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17192D),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/tobias': (context) => buildUnitPage('tobias', 'Tobias Unit'),
        '/jaguar': (context) => buildUnitPage('jaguar', 'Jaguar Unit'),
        '/apex': (context) => buildUnitPage('apex', 'Apex Unit'),
      },
    );
  }

  Widget buildUnitPage(String unit, String unitName) {
    return FutureBuilder(
      future: Future.wait([
        loadAssets(unit),
        loadLocations(unit),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final assets = snapshot.data![0] as List<Asset>;
          final locations = snapshot.data![1] as List<Location>;
          return UnitPage(
            unitName: unitName,
            assets: assets,
            locations: locations,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
