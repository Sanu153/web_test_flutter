import 'package:flutter/material.dart';

class MyTransi extends StatefulWidget {
  @override
  _MyTransiState createState() => _MyTransiState();
}

class _MyTransiState extends State<MyTransi>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //print(_controller.isDismissed);
          if (_controller.isDismissed) {
            _controller.forward();
            return;
          }
          _controller.reverse();
        },
        child: SlideTransition(
            position: _animation,
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(width: 350.0),
              child: Material(
                elevation: 15.0,
                child: Container(
                  color: Colors.green,
                ),
              ),
            )));
  }
}
