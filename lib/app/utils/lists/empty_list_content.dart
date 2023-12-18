import 'package:flutter/material.dart';

class EmptyListContent extends StatelessWidget {
  final String title;
  final String message;

  const EmptyListContent({
    Key? key,
    this.title = '...Hum...',
    this.message = 'Por enquanto nada por aqui',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.black54),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
