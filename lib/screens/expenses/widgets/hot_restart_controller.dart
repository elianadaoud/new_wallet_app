import 'package:flutter/cupertino.dart';

class HotRestartController extends StatefulWidget {
  final Widget child;

  const HotRestartController({super.key, required this.child});

  static performHotRestart(BuildContext context) {
    final HotRestartControllerState? state =
        context.findAncestorStateOfType<HotRestartControllerState>();
    state?.performHotRestart();
  }

  @override
  HotRestartControllerState createState() => HotRestartControllerState();
}

class HotRestartControllerState extends State<HotRestartController> {
  Key key = UniqueKey();

  void performHotRestart() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
