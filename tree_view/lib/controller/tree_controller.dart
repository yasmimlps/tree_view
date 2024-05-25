import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_view/views/widgets/tree_node.dart';
import 'package:tree_view/models/asset.dart';
import 'package:tree_view/models/location.dart';
import 'package:tree_view/utils/list_extension.dart';

class TreeController {
  final List<Asset> assets;
  final List<Location> locations;
  final int desiredLevel;
  String searchText = '';
  bool _showEnergySensors = false;
  bool _showCriticalStatus = false;
  late List<TreeNode> _visibleNodes;

  final Map<String, TreeNode> nodeMap = {};
  final Map<String, TreeNode> nodeMapStatus = {};

  TreeController({
    required this.assets,
    required this.locations,
    required this.desiredLevel,
  }) {
    buildTree(nodeMap);
  }

  TreeNode getNode(Object item, Map<String, TreeNode> nodeMap, String? status,
      String? searchTitle) {
    String id;
    List<Widget> icon;
    Widget iconLocation;
    List<TreeNode> children;

    if (item is Asset) {
      id = item.id;
      icon = _determineIconForAsset(item);
      children = _buildLocationNodes(item.id, 0);
      if (!nodeMap.containsKey(id)) {
        nodeMap[id] = TreeNode(
          childrenBuilder: () => children,
          title: (item as dynamic).name,
          icon: icon.safeGet(0),
          iconSensor: icon.safeGet(1),
          status: item.status,
        );
      }
    } else if (item is Location) {
      id = item.id;
      iconLocation = _determineIconForLocation(item);
      children = _buildLocationNodes(item.id, 0);
      if (!nodeMap.containsKey(id)) {
        nodeMap[id] = TreeNode(
          childrenBuilder: () => children,
          title: (item as dynamic).name,
          icon: iconLocation,
        );
      }
    } else if (item is TreeNode) {
      id = item.title;

      if (item.parent == null) {
        if (!nodeMap.containsKey(id)) {
          List<TreeNode> list = [];
          for (var child in item.children) {
            if (nodeMap.values.contains(child) || child.status == status) {
              list.add(child);
            }
          }
          item.children = list;
          nodeMap[id] = item;
        }
      } else {
        if (!nodeMap.containsKey(id)) {
          List<TreeNode> list = [];
          for (var child in item.children) {
            if (nodeMap.values.contains(child) || child.status == status) {
              list.add(child);
            }
          }
          item.children = list;

          nodeMap[id] = item;
          getNode(item.parent as Object, nodeMap, status, searchTitle);
        }
      }
    } else {
      throw ArgumentError('Unsupported item type');
    }

    return nodeMap[id]!;
  }

  int buildVisibleNodesCount() {
    return _visibleNodes.length;
  }

  TreeNode getVisibleNodeAtIndex(int index) {
    return _visibleNodes[index];
  }

  void buildTree(Map<String, TreeNode> nodeMap) {
    for (var location in locations) {
      final node = getNode(location, nodeMap, null, null);
      final parentId = location.parentId;

      if (parentId != null) {
        final parentNode = getNode(
            locations.firstWhere((loc) => loc.id == parentId),
            nodeMap,
            null,
            null);
        parentNode.addChild(node);
        node.parent = parentNode;
      }
    }

    for (var asset in assets) {
      final node = getNode(asset, nodeMap, null, null);
      final locationId = asset.locationId;
      if (locationId != null) {
        final parentNode = getNode(
            locations.firstWhere((loc) => loc.id == locationId),
            nodeMap,
            null,
            null);
        parentNode.addChild(node);
        node.parent = parentNode;
      }
      final parentId = asset.parentId;
      if (parentId != null) {
        final parentNode = getNode(
            assets.firstWhere((asst) => asst.id == parentId),
            nodeMap,
            null,
            null);
        parentNode.addChild(node);
        node.parent = parentNode;
      }
    }

    _visibleNodes = getNodesAtLevel(0, nodeMap);
  }

  List<TreeNode> getRootsLocations() {
    List<TreeNode> rootNodesLocations = [];

    Widget icon;
    List<TreeNode> children;

    locations.forEach((node) {
      if (node.parentId == null) {
        icon = _determineIconForLocation(node);
        children = _buildLocationNodes(node.id, 0);
        final nodeRoot = TreeNode(
          childrenBuilder: () => children,
          title: (node as dynamic).name,
          icon: icon,
        );
        rootNodesLocations.add(nodeRoot);
      }
    });

    return rootNodesLocations;
  }

  List<TreeNode> getRootsAssets() {
    List<TreeNode> rootNodesAssets = [];

    List<Widget> icon;
    List<TreeNode> children;

    assets.forEach((node) {
      if (node.parentId == null && node.locationId == null) {
        icon = _determineIconForAsset(node);
        children = _buildLocationNodes(node.id, 0);
        final nodeRoot = TreeNode(
          childrenBuilder: () => children,
          title: (node as dynamic).name,
          icon: icon.safeGet(0),
          iconSensor: icon.safeGet(1),
          status: node.status,
        );
        rootNodesAssets.add(nodeRoot);
      }
    });
    return rootNodesAssets;
  }

  void searchBy(String? status, String? search) {
    if (status != null) {
      getCriticalAndEnergySensors(status);
    }
    if (search != null) {
      getNodeBySearch(search);
    }
  }

  void getNodeBySearch(String search) {
    List<TreeNode> rootNodesSearch = [];
    nodeMap.values.forEach((node) {
      if (node.parent == null) {
        rootNodesSearch.add(node);
      }
    });

    for (var node in nodeMap.values) {
      findAllPaths(node, null, search);
    }
    _visibleNodes = getNodesAtLevel(0, nodeMapStatus);
  }

  bool containsWord(String title, String search) {
    final lowerTitle = title.toLowerCase();
    final lowerSearch = search.toLowerCase();
    final regex = RegExp(r'\b' + RegExp.escape(lowerSearch) + r'\b');

    return regex.hasMatch(lowerTitle);
  }

  void getCriticalAndEnergySensors(String status) {
    List<TreeNode> rootNodesCritical = [];

    nodeMap.values.forEach((node) {
      if (node.parent == null) {
        rootNodesCritical.add(node);
      }
    });
    for (var node in nodeMap.values) {
      findAllPaths(node, status, null);
    }

    _visibleNodes = getNodesAtLevel(0, nodeMapStatus);
  }

  void findAllPaths(TreeNode node, String? status, String? search) {
    if (status != null) {
      if (node.status == status) {
        getNode(node, nodeMapStatus, status, null);
      }
    }
    if (search != null) {
      if (containsWord(node.title, search)) {
        getNode(node, nodeMapStatus, null, search);
      }
    }

    for (var child in node.children) {
      findAllPaths(child, status, search);
    }
  }

  List<TreeNode> getNodesAtLevel(int level, Map<String, TreeNode> nodeMap) {
    List<TreeNode> result = [];
    List<TreeNode> rootNodes = [];
    nodeMap.values.forEach((node) {
      if (node.parent == null) {
        rootNodes.add(node);
      }
    });
    for (var node in rootNodes) {
      _collectNodesAtLevel(node, level, 0, result);
    }

    return result;
  }

  List<TreeNode> _collectNodesAtLevel(TreeNode node, int desiredLevel,
      int currentLevel, List<TreeNode> result) {
    if (currentLevel == desiredLevel) {
      result.add(node);
      return result;
    } else {
      List<TreeNode> tempResult = List.from(result);
      for (var child in node.children) {
        tempResult = _collectNodesAtLevel(
            child, desiredLevel, currentLevel + 1, tempResult);
      }
      result.clear();
      result.addAll(tempResult);
    }

    return result;
  }

  List<TreeNode> _buildLocationNodes(String? parentId, int currentLevel) {
    return locations
        .where((location) =>
            location.parentId == parentId && currentLevel <= desiredLevel)
        .map<TreeNode>((location) {
      final children = _buildLocationNodes(location.id, currentLevel + 1) +
          _buildAssetNodes(location.id, currentLevel + 1);

      final icon = _determineIconForLocation(location);
      return TreeNode(
        title: location.name,
        icon: icon,
        childrenBuilder: () => children,
        initiallyExpanded: false,
      );
    }).toList();
  }

  List<TreeNode> _buildAssetNodes(String? parentId, int currentLevel) {
    return assets
        .where((asset) =>
            ((asset.parentId == parentId) || (asset.locationId == parentId)) &&
            currentLevel <= desiredLevel)
        .map<TreeNode>((asset) {
      final children = _buildAssetNodes(asset.id, currentLevel + 1);
      final icon = _determineIconForAsset(asset);

      return TreeNode(
        title: asset.name,
        icon: icon.safeGet(0),
        iconSensor: icon.safeGet(1),
        status: asset.status,
        childrenBuilder: () => children,
        initiallyExpanded: false,
      );
    }).toList();
  }

  Widget _determineIconForLocation(Location location) {
    return SvgPicture.asset('assets/icons/GoLocation.svg');
  }

  List<Widget> _determineIconForAsset(Asset asset) {
    List<Widget> list = [];
    if (asset.sensorType == null) {
      list.add(SvgPicture.asset('assets/icons/IoCubeOutline.svg'));
      if (asset.status == "alert") {
        list.add(SvgPicture.asset('assets/icons/alert.svg'));
      } else if (asset.status == "operating") {
        list.add(SvgPicture.asset(
          'assets/icons/bolt_green.svg',
        ));
      }
      return list;
    } else if (asset.status == "operating") {
      list.addAll([
        SvgPicture.asset('assets/icons/Codepen.svg'),
        SvgPicture.asset(
          'assets/icons/bolt_green.svg',
        )
      ]);
      return list;
    } else if (asset.status == "alert") {
      list.addAll([
        SvgPicture.asset('assets/icons/Codepen.svg'),
        SvgPicture.asset('assets/icons/alert.svg')
      ]);
      return list;
    }
    return list;
  }
}
