import 'package:coc_calculator/SpellContainer.dart';
import 'package:coc_calculator/data.dart';
import 'package:flutter/cupertino.dart';
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade50,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Enabled",style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue, fontSize: 20)),
                    Checkbox(value: appState.enabledSpells[widget.spell], onChanged: (bool? value) {
                      setState(() {
                        appState.enabledSpells[widget.spell] = value!;
                        appState.notify();
                      });
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
