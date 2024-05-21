import 'package:flutter/material.dart';

class LevelContainer extends StatelessWidget {
  const LevelContainer({super.key, required this.level, required this.isMax});

  final int level;
  final bool isMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: isMax ? Colors.amber : Colors.blueGrey,
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(level.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
