import 'package:flutter/material.dart';

class AppLifecycleReactor extends StatefulWidget {
  AppLifecycleReactor(this.child);

  final Widget child;

  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
      Navigator.of(context).pushNamedAndRemoveUntil("/localAuth", (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
