import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TreeNode extends StatefulWidget {
  final String title;
  final Widget? icon;
  final Widget? iconSensor;
  final String? status;
  final Function() childrenBuilder;
  final bool initiallyExpanded;
  TreeNode? parent;
  List<TreeNode> children;

  TreeNode({
    required this.title,
    this.icon,
    this.iconSensor,
    this.status,
    required this.childrenBuilder,
    this.initiallyExpanded = false,
    this.parent,
  }) : children = [];

  bool addChild(TreeNode child) {
    try {
      child.parent = this;
      children.add(child);

      return true;
    } catch (e) {
      log("$e");
    }
    return false;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return _buildString(0);
  }

  String _buildString(int level) {
    final indent = '  ' * level;
    final buffer = StringBuffer()
      ..writeln(
          '$indent($level) (title: $title) (children: ${children.length})');
    for (var child in children) {
      buffer.write(child._buildString(level + 1));
    }
    return buffer.toString();
  }

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> {
  late bool isExpanded;
  late bool hasChildren;

  @override
  void initState() {
    super.initState();
    hasChildren = widget.childrenBuilder().isNotEmpty;
    isExpanded = widget.initiallyExpanded && hasChildren;
  }

  @override
  Widget build(BuildContext context) {
    final List<TreeNode> children = widget.childrenBuilder();

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: hasChildren
          ? ExpansionTile(
              title: Row(
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (widget.iconSensor != null) ...[
                    widget.iconSensor!,
                  ],
                ],
              ),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (bool expanded) {
                setState(() {
                  isExpanded = expanded;
                });
              },
              children: [
                for (TreeNode child in children)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TreeNode(
                      title: child.title,
                      icon: child.icon,
                      iconSensor: child.iconSensor,
                      childrenBuilder: () => child.children,
                      initiallyExpanded: false,
                    ),
                  ),
              ],
            )
          : ListTile(
              title: Row(
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.title,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(width: 10),
                  if (widget.iconSensor != null) ...[
                    widget.iconSensor!,
                  ],
                ],
              ),
            ),
    );
  }
}
