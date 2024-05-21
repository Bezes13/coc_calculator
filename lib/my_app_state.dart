import 'package:coc_calculator/data.dart';
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

  void notify(){
    notifyListeners();
  }
}
