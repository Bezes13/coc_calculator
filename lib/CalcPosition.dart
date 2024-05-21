import 'package:coc_calculator/SpellContainer.dart';
import 'package:coc_calculator/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';

class CalcPosition extends StatefulWidget {
  const CalcPosition({super.key, required this.spell});

  final Entry spell;

  @override
  State<CalcPosition> createState() => _CalcPositionState();
}

class _CalcPositionState extends State<CalcPosition> {
  int sliderValue = 1;
  @override
  void initState() {
    super.initState();
    sliderValue = widget.spell.hitPoints.length;
  }
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);

    return SizedBox(
      width: 200,
      child: Column(
        children: [
          SpellContainer(item: widget.spell, level: sliderValue, times:-1),
          Slider(
            value: sliderValue.toDouble(),
            min: 1,
            max: widget.spell.hitPoints.length.toDouble(),
            divisions: widget.spell.hitPoints.length,
            label: sliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                sliderValue = value.toInt();
                appState.selectedLevels[widget.spell] = value.toInt();
                appState.notify();
              });
            },
          ),
        ],
      ),
    );

  }
}
