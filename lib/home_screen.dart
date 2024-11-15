import 'package:flutter/material.dart';
import 'package:flutter_practice/save_as_image/widget_decorated_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Flutter Practice',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const WidgetDecoratedBox(),
    );
  }
}
