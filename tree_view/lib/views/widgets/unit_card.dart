import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnitCard extends StatelessWidget {
  final String unitName;
  final String routeName;
  final String iconPath;

  UnitCard({
    required this.unitName,
    required this.routeName,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 317,
        height: 76,
        margin: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 21,
              height: 16,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              unitName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
