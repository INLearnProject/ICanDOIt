import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/challenge_model.dart';

const String keyAcess = "ChallengesList";

class ChallengesController extends ChangeNotifier {
  List<ChallengeModel> _challengesList = [];
  late SharedPreferences _localData;

  ChallengesController() {
    _initChallengesList();
  }
  List<ChallengeModel> getChallenges() {
    return UnmodifiableListView(_challengesList);
  }

  void _initChallengesList() async {
    _localData = await SharedPreferences.getInstance();
    final List<String>? tempList = _localData.getStringList(keyAcess);

    if (tempList != null) {
      final List<Map<String, dynamic>> jsonDecodeList = tempList
          .map((challengeEncoded) => jsonDecode(challengeEncoded))
          .toList()
          .cast<Map<String, dynamic>>();

      _challengesList = jsonDecodeList
          .map((challenge) => ChallengeModel.fromJSON(challenge))
          .toList();
    }
    notifyListeners();
  }

  void addChallenge(
      {required String name,
      required String target,
      required String unity}) async {
    _challengesList.add(
      ChallengeModel(
        name: name,
        target: int.parse(target),
        unity: unity == "KG" ? UnityChallenge.kg : UnityChallenge.km,
      ),
    );
    await _save();
    notifyListeners();
  }

  Future<bool> _save({bool remove = false}) async {
    if (_challengesList.isEmpty && remove) {
      return _localData.setStringList(keyAcess, []);
    }
    if (_challengesList.isNotEmpty) {
      List<String> jsonList = _challengesList
          .map((challenge) => jsonEncode(challenge.toJSON()))
          .toList();
      return _localData.setStringList(keyAcess, jsonList);
    }
    return false;
  }

  void remove({required int index}) async {
    _challengesList.removeAt(index);
    await _save(remove: true);
    notifyListeners();
  }
}
