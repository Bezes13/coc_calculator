import 'package:coc_calculator/components/LevelContainer.dart';
import 'package:coc_calculator/data_offline/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpellContainer extends StatelessWidget {
  const SpellContainer({super.key, required this.item, required this.level, required this.times});

  final Entry item;
  final int level;
  final int times;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Column(
        children: [
          Visibility(
              visible: times >= 1,
              child: Text("x$times",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset('lib/images/${item.path}', width: 150),
              Positioned(
                top: 10,
                right: 10,
                child: LevelContainer(level: level, isMax: item.hitPoints.length == level),
              ),
            ],
          )
        ],
      ),
    );
  }
}
