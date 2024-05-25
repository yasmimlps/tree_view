import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tree_view/views/widgets/unit_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17192D),
        title: Center(
          child: SvgPicture.asset(
            'assets/icons/tractian.svg',
            height: 17,
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            UnitCard(
              unitName: 'Jaguar Unit',
              routeName: '/jaguar',
              iconPath: 'assets/icons/home.svg',
            ),
            UnitCard(
              unitName: 'Tobias Unit',
              routeName: '/tobias',
              iconPath: 'assets/icons/home.svg',
            ),
            UnitCard(
              unitName: 'Apex Unit',
              routeName: '/apex',
              iconPath: 'assets/icons/home.svg',
            ),
          ],
        ),
      ),
    );
  }
}
