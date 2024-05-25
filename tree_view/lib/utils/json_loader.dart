import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tree_view/models/asset.dart';
import 'package:tree_view/models/location.dart';

Future<List<Asset>> loadAssets(String unit) async {
  final String response =
      await rootBundle.loadString('assets/$unit/assets.json');
  final data = json.decode(response);
  return List<Asset>.from(data.map((item) => Asset.fromJson(item)));
}

Future<List<Location>> loadLocations(String unit) async {
  final String response =
      await rootBundle.loadString('assets/$unit/locations.json');
  final data = json.decode(response);
  return List<Location>.from(data.map((item) => Location.fromJson(item)));
}
