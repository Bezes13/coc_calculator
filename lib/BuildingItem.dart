import 'package:coc_calculator/SpellContainer.dart';
import 'package:coc_calculator/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';

class BuildingItem extends StatefulWidget {
  const BuildingItem({super.key, required this.spell});

  final Entry spell;

  @override
  State<BuildingItem> createState() => _CalcPositionState();
}

class _CalcPositionState extends State<BuildingItem> {
  int sliderValue = 1;
  var showAll = false;
  @override
  void initState() {
    super.initState();
    sliderValue = widget.spell.hitPoints.length;
  }

  void getZapCount(List<(Entry, int)> list, int life, int zap){
    var zapcount = life ~/ zap;
    if(life/zap > 0){
      zapcount++;
    }
    if(zapcount > 0){
      list.add((lightning, zapcount));
    }
  }
  List<List<(Entry, int)>> calcNeededSpells(
      int lifePoints, bool hero, bool isResource, MyAppState appState) {

    var earthQuakeDmg = (lifePoints * earthquake.hitPoints[(appState.selectedLevels[earthquake] ?? 1) - 1]).toInt();
    var secondQuake = earthQuakeDmg ~/ 3;
    var thirdQuake = earthQuakeDmg ~/ 5;
    var zapAllowed = !isResource && (appState.enabledSpells[lightning]??true);
    var zapDmg =  lightning.hitPoints[(appState.selectedLevels[lightning] ?? 1) - 1].toInt();
    List<List<(Entry, int)>> result = [];

    // Without Hero Equipment
    if(zapAllowed) {
      List<(Entry, int)> justLightning = [];
      getZapCount(justLightning, lifePoints, zapDmg);
      result.add(justLightning);


      List<(Entry, int)> oneEarth = [];
      List<(Entry, int)> twoEarth = [];
      if (!hero && (appState.enabledSpells[earthquake]??true)) {
        oneEarth.add((earthquake, 1));

        getZapCount(oneEarth, lifePoints - earthQuakeDmg, zapDmg);

        twoEarth.add((earthquake, 2));
        getZapCount(twoEarth, lifePoints - earthQuakeDmg - secondQuake, zapDmg);
        result.add(oneEarth);

        if ((lifePoints - earthQuakeDmg - secondQuake) ~/ zapDmg !=
            (lifePoints - earthQuakeDmg) ~/ zapDmg) {
          result.add(twoEarth);
        }
      }
    }

    // Hero Equipment
    for( Entry spell in heroSpells){
      if(!(appState.enabledSpells[spell]??true)){
        continue;
      }
      if((spikeball == spell || seekingShield == spell) && hero){
        continue;
      }
      if(seekingShield == spell && isResource){
        continue;
      }

      var heroDmg =  spell.hitPoints[(appState.selectedLevels[spell] ?? 1) - 1].toInt();
      if(zapAllowed) {
        List<(Entry, int)> heroWithZaps = [];
        heroWithZaps.add((spell, 1));
        getZapCount(heroWithZaps, lifePoints - heroDmg, zapDmg);
        result.add(heroWithZaps);
      }else{
        if(heroDmg >= lifePoints){
          List<(Entry, int)> heroWithZaps = [];
          heroWithZaps.add((spell, 1));
          result.add(heroWithZaps);
        }
      }
      if(heroDmg < lifePoints && (appState.enabledSpells[earthquake]??true)){
        List<(Entry, int)> earthFireball = [];
        earthFireball.add((spell, 1));
        earthFireball.add((earthquake,1));
        if(zapAllowed) {
          getZapCount(earthFireball, lifePoints - heroDmg - earthQuakeDmg, zapDmg);
          result.add(earthFireball);
        }
        if(heroDmg + earthQuakeDmg >= lifePoints && (appState.enabledSpells[earthquake]??true)){
          result.add(earthFireball);
        }
      }
      if(heroDmg + earthQuakeDmg < lifePoints && (appState.enabledSpells[earthquake]??true)){
        List<(Entry, int)> earthFireball2 = [];
        earthFireball2.add((spell, 1));
        earthFireball2.add((earthquake,2));
        if(zapAllowed) {
          getZapCount(earthFireball2,
              lifePoints - heroDmg - earthQuakeDmg - secondQuake, zapDmg);
          if ((lifePoints - heroDmg - earthQuakeDmg - secondQuake) ~/ zapDmg !=
              (lifePoints - heroDmg - earthQuakeDmg) ~/ zapDmg) {
            result.add(earthFireball2);
          }
        }
        if(heroDmg + earthQuakeDmg + secondQuake >= lifePoints && (appState.enabledSpells[earthquake]??true)){
          result.add(earthFireball2);
        }
      }
      if(heroDmg + earthQuakeDmg + secondQuake < lifePoints && (appState.enabledSpells[earthquake]??true)){
        List<(Entry, int)> earthFireball3 = [];
        earthFireball3.add((spell, 1));
        earthFireball3.add((earthquake,3));
        if(zapAllowed) {
          getZapCount(earthFireball3,
              lifePoints - heroDmg - earthQuakeDmg - secondQuake - thirdQuake,
              zapDmg);
          if ((lifePoints - heroDmg - earthQuakeDmg - secondQuake) ~/ zapDmg !=
              (lifePoints - heroDmg - earthQuakeDmg) ~/ zapDmg) {
            result.add(earthFireball3);
          }
        }
        if(heroDmg + earthQuakeDmg + secondQuake + thirdQuake >= lifePoints && (appState.enabledSpells[earthquake]??true)){
          result.add(earthFireball3);
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);


    var neededSpells = calcNeededSpells(
                          widget.spell.hitPoints[sliderValue - 1].toInt(),
                          widget.spell.isHero,
                          widget.spell == clanCastle,
                          appState);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/images/${widget.spell.path}',
                    width: 100,
                    height: 100,
                  ),
                  Column(
                    children: [
                      Text("${widget.spell.name}(Level $sliderValue)"),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.heart_broken,
                              color: Colors.red,
                            ),
                            Text(widget.spell.hitPoints[sliderValue - 1]
                                .toString())
                          ])
                    ],
                  )
                ],
              ),
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
                  });
                },
              ),

              if(neededSpells.isNotEmpty)
                Visibility(
                  visible: showAll,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: neededSpells
                        .map((var e) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: e.map((p) {
                            return SpellContainer(
                                item: p.$1,
                                level: appState.selectedLevels[p.$1] ?? 1,
                                times: p.$2);
                          }).toList());
                    }).toList(),
                  ),
                ),
              if(neededSpells.isNotEmpty)
                Visibility(
                    visible: !showAll,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: neededSpells[0].map((p) {
                          return SpellContainer(
                              item: p.$1,
                              level: appState.selectedLevels[p.$1] ?? 1,
                              times: p.$2);
                        }).toList())
                ),
              if(neededSpells.length>1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () =>
                      setState(() {
                        showAll = !showAll;
                      }), child: Text(showAll ? "Hide All" : "Show All")),
                )

            ],
          ),
        ),
      ),
    );
  }
}
