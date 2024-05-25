import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tree_view/controller/tree_controller.dart';
import 'package:tree_view/views/widgets/button_check.dart';
import 'package:tree_view/views/widgets/search_field.dart';
import 'package:tree_view/models/asset.dart';
import 'package:tree_view/models/location.dart';
import 'widgets/tree_node.dart';

class TreeView extends StatefulWidget {
  final List<Asset> assets;
  final List<Location> locations;
  final int desiredLevel;

  TreeView({
    required this.assets,
    required this.locations,
    required this.desiredLevel,
  });

  @override
  _TreeViewState createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  late TreeController _viewController;

  @override
  void initState() {
    super.initState();
    _viewController = TreeController(
      assets: widget.assets,
      locations: widget.locations,
      desiredLevel: widget.desiredLevel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Column(
            children: [
              SearchField(
                labelText: 'Buscar Ativo ou Local',
                onChanged: (value) {
                  setState(() {
                    _viewController.searchText = value;
                  });
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonCheck(
                    text: 'Sensor de Energia',
                    iconPath: 'assets/icons/bolt.svg',
                    initialValue: false,
                    onChanged: (value) {
                      setState(() {
                        _viewController
                            .getCriticalAndEnergySensors("operating");
                      });
                    },
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonCheck(
                    text: 'Crítico',
                    iconPath: 'assets/icons/Vector.svg',
                    initialValue: false,
                    onChanged: (value) {
                      setState(() {
                        _viewController.getCriticalAndEnergySensors("alert");
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromRGBO(216, 223, 230, 1),
          thickness: 1.0,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _viewController.buildVisibleNodesCount(),
            itemBuilder: (context, index) {
              return _buildTreeNode(
                  _viewController.getVisibleNodeAtIndex(index));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTreeNode(TreeNode node) {
    return node.children.isEmpty
        ? ListTile(
            title: Row(
              children: <Widget>[
                if (node.icon != null) ...[
                  node.icon!,
                ],
                const SizedBox(width: 10),
                Text(
                  node.title,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(width: 10),
                if (node.iconSensor != null) ...[
                  node.iconSensor!,
                ],
              ],
            ),
          )
        : TreeNode(
            title: node.title,
            icon: node.icon,
            childrenBuilder: () => node.children,
            initiallyExpanded: node.initiallyExpanded,
          );
  }
}
