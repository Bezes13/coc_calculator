import 'package:coc_calculator/data_offline/data.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  Map<Entry, int> selectedLevels = {
    lightning: lightning.hitPoints.length,
    earthquake: earthquake.hitPoints.length,
    spikeball: spikeball.hitPoints.length,
    fireball: fireball.hitPoints.length,
    seekingShield: seekingShield.hitPoints.length,
    giantArrow: giantArrow.hitPoints.length
  };

  Map<Entry, bool> enabledSpells = {
    lightning: true,
    earthquake: true,
    spikeball: true,
    fireball: true,
    seekingShield: true,
    giantArrow: true
  };

  void notify(){
    notifyListeners();
  }
}
