import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key? key, required this.num}) : super(key: key);
  final String num;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      num,
      style: const TextStyle(color: Colors.brown),
    ));
  }
}

class KeyBox extends StatelessWidget {
  const KeyBox({Key? key, required this.box}) : super(key: key);
  final Widget box;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0XFFC8AE7D), width: 3),
          image: const DecorationImage(
            image: AssetImage('assets/retro.png'),
            fit: BoxFit.fill,
          ),
        ),
        width: MediaQuery.of(context).size.width / 4 - 3,
        height: 230,
        child: box);
  }
}

class IconStyle extends StatelessWidget {
  const IconStyle({Key? key, required this.icon}) : super(key: key);
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 25, bottom: 25),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0XFFC8AE7D),
          border: Border.all(
            color: const Color(0XFFC8AE7D),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: kElevationToShadow[4],
        ),
        child: icon);
  }
}

class IconStyle2 extends StatelessWidget {
  const IconStyle2({Key? key, required this.icon}) : super(key: key);
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          boxShadow: kElevationToShadow[4],
          image: const DecorationImage(
            image: AssetImage('assets/retro2.jpg'),
            fit: BoxFit.fill,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: icon);
  }
}

class IconStyle1 extends StatelessWidget {
  const IconStyle1({Key? key, required this.icon}) : super(key: key);
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: const Color(0XFFC8AE7D),
          border: Border.all(
            color: const Color(0XFFC8AE7D),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: kElevationToShadow[4],
        ),
        child: icon);
  }
}
