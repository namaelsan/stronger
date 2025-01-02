import 'package:flutter/material.dart';
import 'mylib.dart';

class StatsPage extends StatefulWidget{
  const StatsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatsPageState();
  }
}

class _StatsPageState extends State<StatsPage>{
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return ReusableWidgets.myBackgroundGradient(
      Center(

      ),
    );
  }

}