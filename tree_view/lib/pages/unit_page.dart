import 'package:flutter/material.dart';
import 'package:tree_view/models/asset.dart';
import 'package:tree_view/models/location.dart';
import 'package:tree_view/views/tree_view.dart';

class UnitPage extends StatelessWidget {
  final String unitName;
  final List<Asset> assets;
  final List<Location> locations;

  UnitPage({
    required this.unitName,
    required this.assets,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Assets',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TreeView(
        assets: assets,
        locations: locations,
        desiredLevel: 2,
      ),
    );
  }
}
